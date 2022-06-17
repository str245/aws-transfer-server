resource "aws_iam_role" "role_transfer" {
  name = "${var.tags["environment"]}-${var.tags["project"]}-transfer-user-iam-role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Principal": {
            "Service": "transfer.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
        },
        {
        "Sid": "",
        "Effect": "Allow",
        "Principal": {
            "AWS": "arn:aws:iam::1234567890:root"
        },
        "Action": "sts:AssumeRole"
    }
    ]
}
EOF
}

resource "aws_iam_role_policy" "s3_policy_transfer" {
  name = "${var.tags["environment"]}-${var.tags["project"]}-transfer-user-s3-policy"
  role = "${aws_iam_role.role_transfer.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Sid": "",
        "Effect": "Allow",
        "Action": [
            "s3:*"
        ],
        "Resource": "*"
        },
        {
        "Sid": "LimitedS3",
        "Effect": "Deny",
        "Action": [
            "s3:DeleteBucket",
            "s3:CreateBucket"
        ],
        "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "log_policy_transfer" {
  name = "${var.tags["environment"]}-${var.tags["project"]}-transfer-user-log-policy"
  role = "${aws_iam_role.role_transfer.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Sid": "AllowFullAccesstoCloudWatchLogs",
        "Effect": "Allow",
        "Action": [
            "logs:*"
        ],
        "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "kms_attach" {
  role       = "${aws_iam_role.role_transfer.id}"
  policy_arn = "arn:aws:iam::${var.account_number}:policy/${var.tags["project"]}-${var.tags["environment"]}-kms-encrypted"
}

resource "aws_transfer_server" "sftp" {
  identity_provider_type = "SERVICE_MANAGED"
  logging_role           = "${aws_iam_role.role_transfer.arn}"
  tags                   = "${merge(var.tags, map("Name", format("%s-%s-transfer-server", var.tags["environment"], var.tags["project"])))}"
}

resource "aws_transfer_user" "sftp_user" {
  server_id      = "${aws_transfer_server.sftp.id}"
  user_name      = "sftp_user"
  role           = "${aws_iam_role.role_transfer.arn}"
  tags           = "${merge(var.tags, map("Name", "sftp_user"))}"
  home_directory = "${var.home_directory}"
}

resource "aws_transfer_ssh_key" "ssh_key_sftp" {
  server_id = "${aws_transfer_server.sftp.id}"
  user_name = "${aws_transfer_user.sftp_user.user_name}"
  body      = "${var.public_key}"
}
