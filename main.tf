resource "databricks_job" "job" {
  name        = var.name
  description = var.description
  tags        = var.tags

  run_as {
    service_principal_name = var.run_as_service_principal_name
  }

  # Create as many parameters as are specified
  dynamic "parameter" {
    for_each = var.parameters
    content {
      name    = parameter.value["name"]
      default = lookup(parameter.value, "default", "")
    }
  }

  dynamic "task" {
    for_each = var.tasks
    content {
      task_key = task.value["task_key"]

      job_cluster_key           = lookup(task.value, "job_cluster_key", null)
      max_retries               = lookup(task.value, "max_retries", 0)
      min_retry_interval_millis = lookup(task.value, "min_retry_interval_millis", 1000)

      dynamic "notebook_task" {
        for_each = length(lookup(task.value, "notebook_task", {})) > 0 ? [1] : []
        content {
          notebook_path = task.value.notebook_task["notebook_path"]
        }
      }

      # Create as many depends_on blocks as are specified
      dynamic "depends_on" {
        for_each = length(lookup(task.value, "depends_on", [])) > 0 ? [1] : []
        content {
          task_key = lookup(task.value, "depends_on", "")
        }
      }
    }
  }
}
