data "sops_file" "providers" {
  source_file = "providers.enc.json"
}

data "sops_file" "github-app" {
  source_file = "github-app.enc.json"
}
