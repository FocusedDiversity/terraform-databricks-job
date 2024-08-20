variable "name" {
  description = "The name of the Databricks job."
  type        = string
}

variable "description" {
  description = "The description of the Databricks job."
  type        = string
}

variable "spark_version" {
  description = "The version of Spark to use for the job cluster."
  type        = string
}

variable "node_type_id" {
  description = "The node type for the cluster."
  type        = string
  default     = "i3en.large"
}

variable "number_of_workers" {
  description = "The number of workers for the cluster."
  type        = number
  default     = 2
}

variable "tasks" {
  description = "A list of tasks to run as part of the job."
  type = list(object({
    task_key = string
    notebook_task = optional(object({
      notebook_path = string
    }))
    max_retries               = optional(number)
    min_retry_interval_millis = optional(number)
    depends_on                = optional(list(string))
  }))
  default = []
}
