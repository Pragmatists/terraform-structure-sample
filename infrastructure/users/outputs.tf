output "user_names" {
  value = {
    asset_store = "${aws_iam_user.asset_store.name}"
  }
}
