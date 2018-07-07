<?php

function flatten($data, $parent = false, $sep = '-')
{
    global $main_data_flat;
    $out = array();
    foreach ($data as $k => $v) {
        if (!$parent) {
            $chain = $k;
        } else {
            $chain = $parent . $sep . $k;
        }
        if (is_array($v)) {
            $out[$chain] = flatten($v, $chain);
        } else {
            $out[$chain] = $v;
            $main_data_flat[$chain] = $v;
        }
    }
    return ($out);
}

function extractDataFromArray($array, $pattern)
{
    if (!is_array($array)) {
        return $pattern;
    }

    foreach ($array as $v) {
        extract($v, $pattern);
    }
}


class Generate
{
    public $tfStateFiles = [];
    public $jsonData = [];
    public $jsonDataEnv = [];
    public $allJsonData = [];
    public $resourceIds = [];
    public $flatResourceArr = [];
    public $flatResourceAttArr = [];

    public function __construct()
    {
    }

    public function loadFiles()
    {
        $fileArr = glob(__DIR__ . '/*/*.tfstate');
        foreach ($fileArr as $file) {
            $envTxt = '';
            if (stristr($file, 'dev-vpc')) {
                $envTxt = 'dev';
            }
            if (stristr($file, 'stage-vpc')) {
                $envTxt = 'stage';
            }
            if (stristr($file, 'live-vpc')) {
                $envTxt = 'live';
            }

            $json = json_decode(file_get_contents($file), 1);
            $resources = $json['modules']['0']['resources'] ?? [];
            $resourcesEnv = [];
            foreach ($resources as $e => $r) {
                $r['env'] = $envTxt;
                $id = $r['primary']['id'] ?? $r['primary']['attributes'] ?? 'NA';

                // remove resource type from name
                list($etc, $envKeyWithoutType,) = explode('.', $e);
                $envKey = $envTxt . '_' . $envKeyWithoutType;

                $r['id'] = $id;
                $resourcesEnv[$envKey] = $r;
                $this->resourceIds[$id] = $envKey;
            }
            //$r = flatten($json['modules']['0']['resources'], $rootTxt, '_');
            $this->jsonData = array_merge($this->jsonData, $resources);
            $this->jsonDataEnv = array_merge($this->jsonDataEnv, $resourcesEnv);
        }
        $this->allJsonData = array_merge($this->jsonDataEnv, $this->jsonData);
    }

    public function returnAttr($resource = [])
    {
        $cacheKey = md5(json_encode($resource));
        if (isset($this->flatResourceAttArr[$cacheKey])) {
            return $this->flatResourceAttArr[$cacheKey];
        }
        $attr = $resource['primary']['attributes'] ?? [];

        $id = $resource['primary']['id'] ?? $attr['id'] ?? 'NA';
        $attr['_id'] = $id;

        $this->flatResourceAttArr[$cacheKey] = $attr;
        return $attr;
    }

    public function flattenResources($data = [], $keysToExtract = [])
    {
        $defaultKeysToExtract = [
            'aws_vpc' => ['cidr_block'],
            'aws_internet_gateway' => [],
            'aws_route53_zone' => ['name'],
            'aws_subnet' => ['cidr_block', 'availability_zone', ['vpc_id.cidr_block' => 'vpc_cidr_block']],
        ];

        $keysToExtract = array_merge_recursive($defaultKeysToExtract, $keysToExtract);

        $flatArray = [];
        foreach ($data as $key => $resource) {
            $flatArray[$key] = [];
            $keyDataArr = [];
            $attr = $this->returnAttr($resource);
            //$flatArray[$key] = ['type' => $resource['type']];
            $type = $resource['type'];

            $keysToGet = $keysToExtract[$type] ?? [];

            if ($keysToGet || isset($keysToExtract[$type])) {
                $keysToGet[] = 'id';
                $keysToGet[] = 'env';
            }
            foreach ($keysToGet as $keyFetch) {

                if (is_array($keyFetch)) {


                    $fKey = array_keys($keyFetch)[0];
                    $keyAs = $keyFetch[$fKey];
                    list($rKey, $rSubKey,) = explode('.', $fKey);
                    $rId = $attr[$rKey] ?? $resource[$rKey] ?? 'NA';

                    $refResource = $this->resourceIds[$rId] ?? [];
                    $refResourceAttr = $this->returnAttr($data[$refResource]);

                    $subKeyValue = $refResourceAttr[$rSubKey] ?? 'NA';
                    $keyDataArr[$keyAs] = $subKeyValue;

                } else {
                    $keyDataArr[$keyFetch] = $attr[$keyFetch] ?? $resource[$keyFetch] ?? 'NA';

                }
            }

            $resKey = str_ireplace('.', '_', $key);
            if ($keyDataArr) {
                $keyDataArr['_key'] = $resKey;
            }
            ksort($keyDataArr);
            $flatArray[$resKey] = $keyDataArr;

        }
        $flatArray = array_filter($flatArray);
        $this->flatResourceArr = $flatArray;

    }

    public function loadAndExtract($keysToExtract)
    {
        $this->loadFiles();
        $this->flattenResources($this->jsonDataEnv, $keysToExtract);

    }

    public function generateTemplate($res)
    {
        $var_name = $res['_key'];
        $var_name = str_ireplace(['dev-', 'stage-', 'live-'], '', $var_name);
        unset($res['_key']);
        $attrText = '';
        foreach ($res as $k => $v) {

            $attrText .= "$k =\"$v\"\n";
        }

        $t = <<<EOF
variable "${var_name}" {
  type = "map"
  default = {
  $attrText
  }
}
EOF;
        return $t;
    }

    public function outPut($filterResources = [])
    {
        file_put_contents(__DIR__ . '/05-variables-template.json', json_encode($this->flatResourceArr, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES));
        $varFile = file_get_contents(__DIR__ . '/05-variables-template.tf');
        $splitTxtVarFile = '###### GENERATED ###### DO NOT REMOVE';
        $varFileArr = explode($splitTxtVarFile, $varFile);

        $varJsonTxT = [];


        foreach ($this->flatResourceArr as $key => $res) {

            $isKeyMatchRegex = false;
            foreach ($filterResources as $regex) {
                if (!$isKeyMatchRegex) {
                    $isKeyMatchRegex = preg_match("#" . $regex . "#", $key);
                }
            }


            if ($isKeyMatchRegex) {
                $varJsonTxT[] = $this->generateTemplate($res);
            }
        }

        $varFileArr[1] = $splitTxtVarFile . "\n\n" . join("\n\n", $varJsonTxT);
        file_put_contents(__DIR__ . '/05-variables-template.tf', join("", $varFileArr));

    }
}

$class = new Generate();
$keysToExtract = [
//    'aws_subnet' => 'availability_zone'
];
$class->loadAndExtract($keysToExtract);

$filerResource = ['.*vpc.*', '.*gateway.*', '.*public-zone.*', '.*subnet.*app',];

$class->outPut($filerResource);

