variable "subscription_id" {
  type        = string
  description = "ID de l'abonnement Azure for Students utilisé pour le déploiement"
}

variable "location" {
  type        = string
  description = "Région Azure retenue lors du TP"
}

variable "binome" {
  type        = string
  description = "Nom du binôme, utilisé dans le nommage des ressources (<type>-nimbus-<binome>)"
}

variable "owner" {
  type        = string
  description = "Propriétaire des ressources, utilisé pour le tag owner"
}

variable "environment" {
  type        = string
  description = "Environnement, utilisé pour le tag env"
  default     = "dev"
}

variable "numero_groupe" {
  type        = number
  description = "Numéro de groupe, utilisé pour le plan d'adressage 10.<numero_groupe>.0.0/16"
  default     = 5
}
variable "vm_size" {
  type        = string
  description = "Taille des VM (celle retenue lors du TP Azure)"
  default     = "Standard_B2s_v2"
}

variable "admin_username" {
  type        = string
  description = "Nom de l'utilisateur administrateur des VM"
  default     = "azuruser"
}

variable "ssh_public_key_path" {
  type        = string
  description = "Chemin de la clé publique SSH utilisée pour se connecter aux VM"
  default     = "~/.ssh/id_rsa.pub"
}
variable "admin_source_ip" {
  type        = string
  description = "IP publique autorisée à se connecter en SSH à la jumpbox, au format CIDR (ex. 203.0.113.10/32)"
}
variable "alert_email" {
  type        = string
  description = "Adresse mail qui reçoit les alertes Azure Monitor"
}