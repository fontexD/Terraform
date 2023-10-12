# Terraform Proxmox Infrastructure Script

This script provides a structured way to manage and deploy virtual machine instances on a Proxmox server using Terraform. The script is designed with Kubernetes in mind but can be easily adapted for any kind of setup by tweaking the module templates.

## Features:

- **Flexible Deployment**: Separate modules for `haproxy`, `controller`, and `worker` allow for easy scaling and management.
- **Dynamic TFTP Configuration**: Generates a TFTP configuration based on the deployed instances.
- **Customizable Resource Allocation**: Set CPU cores, memory, and disk space per module.

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

1. **Modify Module Templates**: Update the `source` paths and parameters in the `module` sections to match your desired configuration.
2. **Adjust Variables**: Change the `variable` values or introduce new variables as needed.

## Note:
Ensure you have the required Terraform providers installed. Specifically, this script uses the `Telmate/proxmox` provider version `2.9.14`.
