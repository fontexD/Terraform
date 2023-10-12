# Terraform Proxmox Infrastructure Script

This script provides a structured way to manage and deploy virtual machine instances on a Proxmox server using Terraform. The script is designed with Kubernetes in mind but can be easily adapted for any kind of setup by tweaking the module templates.

## Features:

- **Flexible Deployment**: Separate modules for `haproxy`, `controller`, and `worker` allow for easy scaling and management.
- **Dynamic TFTP Configuration**: Generates a TFTP configuration based on the deployed instances.
- **Customizable Resource Allocation**: Set CPU cores, memory, and disk space per module.

## Creating the Proxmox User and Role for Terraform

Instead of using cluster-wide Administrator rights, follow these steps to set up a dedicated user and role for Terraform in Proxmox:

1. **Log into Proxmox**: Using ssh or through the GUI, access your Proxmox cluster or host.

2. **Create a New Role**: 
    ```bash
    pveum role add TerraformProv -privs "Datastore.AllocateSpace Datastore.Audit Pool.Allocate Sys.Audit Sys.Console Sys.Modify VM.Allocate VM.Audit VM.Clone VM.Config.CDROM VM.Config.Cloudinit VM.Config.CPU VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Migrate VM.Monitor VM.PowerMgmt"
    ```

3. **Create the User**:
    ```bash
    pveum user add terraform-prov@pve --password <password>
    ```

4. **Assign the Role to the User**:
    ```bash
    pveum aclmod / -user terraform-prov@pve -role TerraformProv
    ```

5. **Use API Key (Optional)**: This provider also supports using an API key rather than a password. Check provider documentation for more details.

6. **Modify Role Privileges (If Needed)**: If you need to adjust the privileges of the `TerraformProv` role later, you can use the modify command:
    ```bash
    pveum role modify TerraformProv -privs "Datastore.AllocateSpace Datastore.Audit Pool.Allocate Sys.Audit Sys.Console Sys.Modify VM.Allocate VM.Audit VM.Clone VM.Config.CDROM VM.Config.Cloudinit VM.Config.CPU VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Migrate VM.Monitor VM.PowerMgmt"
    ```

7. **Reference**: For additional details on roles and privileges in Proxmox, consult the official [Proxmox User Management documentation](https://pve.proxmox.com/wiki/User_Management).



## How to Use:

1. **Set Up Proxmox Provider**:
    Replace `<ip_of_proxmox>` in the `provider "proxmox"` section with your Proxmox server's IP address.

2. **Configure VM Instances**:
    Adjust the instance counts, CPU, memory, and disk size in the `variable` sections at the end of the script to fit your needs.

3. **Initialization**:
    ```bash
    terraform init
    ```

4. **Plan & Apply**:
    ```bash
    terraform plan
    terraform apply
    ```

## Customization:

To tailor this script for setups other than Kubernetes:

1. **Modify Module Templates**: Update the parameters in the `module` sections to match your desired configuration.
2. **Adjust Variables**: Change the `variable` values or introduce new variables as needed.

## Note:
Ensure you have the required Terraform providers installed. Specifically, this script uses the `Telmate/proxmox` provider version `2.9.14`.
