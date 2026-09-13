variable "github_branch" {
  default = "main"
}

data "http" "github_oidc" {
  url = "https://api.github.com/repos/${var.github_repo}/actions/oidc/customization/sub"

  request_headers = {
    Accept               = "application/vnd.github+json"
    X-GitHub-Api-Version = "2026-03-10"
  }

  lifecycle {
    postcondition {
      condition     = self.status_code == 200
      error_message = "Failed to retrieve GitHub OIDC configuration."
    }
  }

}

locals {
  github_oidc = jsondecode(data.http.github_oidc.response_body)

  github_oidc_sub = "${local.github_oidc.sub_claim_prefix}:ref:refs/heads/${var.github_branch}"
}
