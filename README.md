# terraform-databricks-job

A Terraform module to create and manage Databricks jobs.

## Usage

```hcl
provider "databricks" {
  alias         = "workspace"
  host          = var.databricks_workspace_host_url
  client_id     = var.databricks_workspace_service_principal_id
  client_secret = var.databricks_client_secret
}

data "databricks_spark_version" "latest" {
  provider = databricks.workspace
}

data "databricks_node_type" "smallest" {
  provider   = databricks.workspace
  local_disk = true
}

module "databricks_job_example" {
  source = "github.com/FocusedDiversity/terraform-databricks-job?ref=0.1.0"
  providers = {
    databricks = databricks.workspace
  }

  name        = "${local.environment_uppercase} - EXAMPLE - ${var.databricks_job_example_version}"
  description = "EXAMPLE Job"

  spark_version = data.databricks_spark_version.latest.id
  node_type_id  = data.databricks_node_type.smallest.id

  run_as_service_principal_name = databricks_service_principal.example.application_id

  tags = {
    ENV      = local.environment_uppercase
    JOB_TYPE = "EXAMPLE"
    VERSION  = var.databricks_job_example_version
  }

  parameters = [{
    name    = "ENV"
    default = local.environment_uppercase
  }]

  tasks = [{
    task_key = "example"

    notebook_task = {
      notebook_path = databricks_notebook.example.path
    }

    # Retry Config
    max_retries               = 2
    min_retry_interval_millis = 1800000

    depends_on = []
  }]

  depends_on = [databricks_access_control_rule_set.example]
}

# Databricks resources that map the source code of the Example Job to a Notebook resource in the Databricks console

resource "databricks_notebook" "example" {
  provider = databricks.workspace

  source = "${path.module}/databricks-notebooks/example/example.py"
  path   = "/Shared/terraform/example/example"
}
```

## Authentication to Databricks Workspace
To authenticate to a Databricks workspace, you need to provide the following variables:

**Databricks Host**: The URL of your Databricks workspace (e.g., https://<databricks-instance>.cloud.databricks.com).

**Databricks Token**: A personal access token generated from your Databricks account.

```hcl
variable "databricks_host" {
  description = "The URL of the Databricks workspace."
  type        = string
}

variable "databricks_token" {
  description = "The personal access token for Databricks."
  type        = string
  sensitive   = true
}
```

Alternatively, you can set these values using environment variables:

```sh
export DATABRICKS_HOST=https://<databricks-instance>.cloud.databricks.com
export DATABRICKS_TOKEN=<your-access-token>
```
Terraform will automatically use these environment variables for authentication if you don’t explicitly pass them as variables in your configuration.

## License
This project is licensed under the MIT License.