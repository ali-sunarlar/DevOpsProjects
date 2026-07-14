variable "rg_name" {
  type        = string
  description = "Her lab başlangicinda değişen güncel kaynak grubu adi"
}

variable "location" {
  type        = string
  default     = "westus"
  description = "Kaynaklarin kurulacaği Azure bölgesi"
}