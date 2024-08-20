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
}

variable "number_of_workers" {
  description = "The number of workers for the cluster."
  type        = number
  default     = 2
}

variable "run_as_service_principal_name" {
  description = "The Service Principal name that will be used to run the task(s)."
  type        = string
}

variable "parameters" {
  description = "A list of parameters to be passed to the tasks."
  type = list(object({
    name    = string
    default = string
  }))
  default = []
}

variable "tags" {
  type        = map(string)
  description = "(Optional) List of tags to be propagated across all resources."
  default     = {}
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
    depends_on                = optional(object({
      task_keys = list(string)
    }))
  }))
  default = []
}
