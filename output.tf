output "vm"{
value = {for id in keys(var.vm_data) : var.vm_data[id]["vm_name"] => var.vm_data[id]["rg_name"]}
}