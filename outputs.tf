output "sftp_id" {
  value = "${aws_transfer_server.sftp.id}"
}

output "sftp_arn" {
  value = "${aws_transfer_server.sftp.arn}"
}

output "sftp_endpoint" {
  value = "${aws_transfer_server.sftp.endpoint}"
}

output "sftp_fingerprint" {
  value = "${aws_transfer_server.sftp.host_key_fingerprint}"
}

output "sftp_cname" {
  value = "${format("%s.%s-%s.%s", "sftp", var.tags["project"], var.tags["environment"], "es.company.com")}"
}
