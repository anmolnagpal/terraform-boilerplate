## USERS
## ops
resource "aws_iam_user" "dev-user-anmol-nagpal" {
  name     = "anmol.nagpal"
  path     = "/"
  provider = "aws.dev"
}

resource "aws_iam_access_key" "dev-key-anmol-nagpal" {
  user     = "${aws_iam_user.dev-user-anmol-nagpal.name}"
  provider = "aws.dev"
}

## IAM Groups
resource "aws_iam_group" "dev-group-devops-admin" {
  name     = "DevopsAdmin"
  path     = "/"
  provider = "aws.dev"
}

resource "aws_iam_group" "dev-group-super-admin" {
  name     = "SuperAdmin"
  path     = "/"
  provider = "aws.dev"
}

## IAM Group Policy
# Super Admin
resource "aws_iam_group_policy" "dev-group-policy-superadmin" {
  name  = "AdministratorAccess"
  group = "${aws_iam_group.dev-group-super-admin.id}"

  policy   = "${file("policy-iam-super-admin.json")}"
  provider = "aws.dev"
}

# DevOps Admin
resource "aws_iam_group_policy" "dev-group-policy-devopsadmin" {
  name  = "AdministratorAccess"
  group = "${aws_iam_group.dev-group-devops-admin.id}"

  policy   = "${file("policy-iam-devops-admin.json")}"
  provider = "aws.dev"
}

## IAM Group Membership
resource "aws_iam_group_membership" "dev-memeber-devops-admin" {
  name = "dev-devops-admin-membership"

  users = [
    "${aws_iam_user.dev-user-anmol-nagpal.name}",
  ]

  group    = "${aws_iam_group.dev-group-devops-admin.name}"
  provider = "aws.dev"
}
