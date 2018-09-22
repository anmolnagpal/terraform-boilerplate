<p align="center"><img src="https://user-images.githubusercontent.com/4303310/42405951-88afac1e-81af-11e8-9d78-f694c6e982f6.png" /></p>

> Terraform for beginners 

### Install terraform 
For MAC OS
```sh
brew install terraform
```
### Export AWS secret keys, else define them in `aws-provider.tf`
```sh
export AWS_ACCESS_KEY_ID=AKIA********
export AWS_SECRET_ACCESS_KEY=8s8v1lT*******************
export AWS_DEFAULT_REGION=us-east-1
```

### Commands
```
$ terraform plan                        # plan
$ terraform apply                       # shortcut for plan & apply - avoid this in production

$ terraform plan -out changes.terraform # terraform plan and write the plan to out file
$ terraform apply changes.terraform     # apply terraform plan using out file

$ terraform show                        # show current state
$ cat terraform.tfstate                 # show state in JSON format
```

## Contribution

* Report issues
* Open pull request to **DEV BRANCH** with improvements
* Spread the word
* Reach out to me directly at ianmolnagpal@gmail.com or on twitter [@anmol_nagpal](https://twitter.com/anmol_nagpal)
