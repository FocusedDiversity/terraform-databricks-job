# terraform-databricks-job

A Terraform module to create and manage Databricks jobs.

## Usage

```hcl
provider "databricks" {
  host  = var.databricks_host
  token = var.databricks_token
}

module "databricks_job" {
  source   = "github.com/FocusedDiversity/terraform-databricks-job"
  provider = databricks.workspace

  name          = "example-job"
  description   = "example-job-description"
  spark_version = "7.3.x-scala2.12"
  node_type_id  = "i3.xlarge"
  num_workers   = 2

  tasks = [
    {
      task_key = "task1"
      notebook_task = {
        notebook_path = "/Users/example@example.com/Notebook1"
      }
      max_retries = 3
      min_retry_interval_millis = 3000
    },
    {
      task_key = "task2"
      python_task = {
        python_file = "dbfs:/path/to/your/script.py"
      }
      max_retries    = 1
      depends_on = ["task1"]
    }
  ]
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