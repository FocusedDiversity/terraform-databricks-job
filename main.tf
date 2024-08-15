resource "databricks_job" "this" {
  name = var.job_name

  new_cluster {
    spark_version = var.spark_version
    node_type_id  = var.node_type_id
    num_workers   = var.number_of_workers
  }

  dynamic "task" {
    for_each = var.tasks
    content {
      task_key = task.value["task_key"]

      dynamic "notebook_task" {
        for_each = length(lookup(task.value, "notebook_task", {})) > 0 ? [1] : []
        content {
          notebook_path = task.value.notebook_task["notebook_path"]
        }
      }
      max_retries               = lookup(task.value, "max_retries", 0)
      min_retry_interval_millis = lookup(notebook_task.value, "min_retry_interval_millis", 0)
      // Conditionally set depends_on
      dynamic "depends_on" {
        for_each = length(lookup(task.value, "depends_on", [])) > 0 ? [1] : []
        content {
          depends_on = lookup(task.value, "depends_on", [])
        }
      }
    }
  }
}
