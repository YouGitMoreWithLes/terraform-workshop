# Discussion Notes

## What is Terraform

Terraform is a tool that helps you build, change, and manage infrastructure (like servers, networks, and databases) in a safe and repeatable way. It's like using code to define your infrastructure, so you can easily track changes, automate deployments, and avoid manual errors.

However, Terraform can be used for more than just infrastructure. While it's primarily known for infrastructure as code (IaC), it can also manage other types of resources and services, such as:

 *   Platform as a Service (PaaS) components: Like databases, queues, and application deployments on platforms like Heroku or Cloud Foundry.
 *   Software as a Service (SaaS) applications: Managing user accounts, permissions, and configurations in SaaS tools like Datadog, PagerDuty, or Okta.
 *   DNS records: Managing DNS zones and records with providers like Cloudflare or AWS Route 53.
 *   Cloud provider features: Provisioning serverless functions, setting up monitoring and alerting, and configuring security settings.

Essentially, if there's a Terraform provider available for a service or platform, you can use Terraform to manage it.

## Why Terraform (and more importantly why not others)


Here are some advantages of using Terraform:

*   **Infrastructure as Code (IaC):** Terraform allows you to define your infrastructure in a declarative configuration language. This makes it easy to version, share, and reuse your infrastructure configurations.
*   **Platform Agnostic:** Terraform supports multiple cloud providers (AWS, Azure, Google Cloud, etc.) and on-premises infrastructure. This allows you to manage your entire infrastructure from a single tool.
*   **State Management:** Terraform tracks the state of your infrastructure, which allows you to safely and predictably make changes to your infrastructure.
*   **Automation:** Terraform automates the process of provisioning and managing infrastructure, which can save you time and reduce errors.
*   **Collaboration:** Terraform configurations can be shared and collaborated on by multiple team members.
*   **Modularity:** Terraform allows you to break down your infrastructure into reusable modules, which makes it easier to manage and maintain.
*   **Open Source:** Terraform is an open-source tool, which means it is free to use and has a large and active community.

Why Terraform might be better than other tools:

*   **Declarative vs. Imperative:** Terraform uses a declarative approach, where you define the desired state of your infrastructure, and Terraform figures out how to achieve that state. Other tools may use an imperative approach, where you have to specify the exact steps to take to provision your infrastructure.
*   **State Management:** Terraform's state management capabilities are more robust than some other IaC tools. This helps prevent conflicts and ensures that your infrastructure is always in the desired state.
*   **Provider Ecosystem:** Terraform has a large and growing ecosystem of providers, which allows you to manage a wide variety of infrastructure and services.

## Approach

Terrafomr has 6 major key words/commands. For the most part you will only use init, validate, plan and apply.

*   **terraform init**: Initializes your Terraform working directory. This command downloads the necessary provider plugins and sets up the backend for storing the Terraform state.
*   **terraform validate**: Validates the syntax and configuration of your Terraform files. This command checks for errors in your code and ensures that your configuration is valid.
*   **terraform plan**: Creates an execution plan. This command compares the current state of your infrastructure with the desired state defined in your Terraform files and generates a plan of the changes that need to be made.
*   **terraform apply**: Applies the changes defined in the execution plan. This command provisions or modifies your infrastructure to match the desired state.
*   **terraform destroy**: Destroys all the resources managed by your Terraform configuration.
*   **terraform import**: Imports existing infrastructure resources into your Terraform state, allowing you to manage them with Terraform.

## State management

Terraform state is crucial for tracking the resources managed by your Terraform configuration. It maps your configuration to the real-world resources. By default, Terraform stores the state locally in a file named `terraform.tfstate`.

**Local State:**

*   **Pros:** Simple to set up, good for learning and small, personal projects.
*   **Cons:** Not suitable for team collaboration, no built-in locking, risk of data loss if the local file is corrupted or deleted.

**Configuration (Local State):**

Local state is the default; no specific configuration is needed. The state file (`terraform.tfstate`) will be created in your working directory.  It's recommended to add this file to your `.gitignore` to prevent it from being committed to version control.

**Remote State:**

Remote state stores the Terraform state in a remote backend. This is essential for team collaboration, as it provides locking and prevents concurrent modifications that can lead to state corruption.

*   **Pros:** Enables team collaboration, provides state locking, supports versioning and encryption, more secure.
*   **Cons:** Requires setting up and managing a remote backend (e.g., AWS S3, Azure Storage Account, HashiCorp Cloud).

**Configuration (Remote State - Example using Azure Storage Account):**

To configure remote state using Azure Storage Account, you'll need:

1.  An Azure subscription.
2.  A resource group.
3.  A storage account.
4.  A container within the storage account.

Here's an example configuration block to include in your Terraform configuration:

```terraform
terraform {
  backend "azurerm" {
    resource_group_name  = "your-resource-group-name"
    storage_account_name = "yourstorageaccountname"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
```

*   `resource_group_name`: The name of the Azure resource group.
*   `storage_account_name`: The name of the Azure storage account.
*   `container_name`: The name of the container within the storage account.
*   `key`: The name of the state file (usually `terraform.tfstate`).

**Important:**  Before applying this configuration, ensure the resource group, storage account, and container exist in your Azure subscription.  You can create them using the Azure CLI or Azure portal.

**Other Remote Backends:**

Terraform supports various other remote backends, including:

*   **AWS S3:**  Popular for AWS deployments.
*   **HashiCorp Cloud:** HashiCorp's managed service for state storage, collaboration, and more.
*   **Google Cloud Storage:** For Google Cloud deployments.

The configuration details vary depending on the chosen backend. Refer to the Terraform documentation for specific instructions.

## Folder structure

Organizing your Terraform code into a well-defined folder structure is crucial for maintainability, especially as your infrastructure grows in complexity. Here are some best practices:

*   **Root Module:** The main directory for your project, containing the core infrastructure configuration.
*   **Modules Directory:** A directory to store reusable modules. Each module should have its own subdirectory.
*   **Environments:** Separate directories for different environments (e.g., `dev`, `staging`, `prod`). Each environment directory contains the Terraform configuration specific to that environment, often referencing modules from the `modules` directory.

**Example Structure:**

```
├── modules/
│   ├── compute/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── network/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── ...
├── environments/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── terraform.tfvars
│   ├── staging/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── terraform.tfvars
│   └── prod/
│       ├── main.tf
│       ├── variables.tf
│       └── terraform.tfvars
├── main.tf
├── variables.tf
└── outputs.tf
```

**Explanation:**

*   **`modules/`**: Contains reusable modules.  Each module (e.g., `compute`, `network`) encapsulates a specific piece of infrastructure.  Modules should be self-contained and configurable via variables.
*   **`environments/`**: Contains environment-specific configurations.  Each environment (e.g., `dev`, `staging`, `prod`) defines the infrastructure for that environment.  The `main.tf` file in each environment directory typically calls the modules defined in the `modules/` directory, passing in environment-specific variables.
*   **Root Module Files (`main.tf`, `variables.tf`, `outputs.tf`):**  These files define the core infrastructure components that are not part of reusable modules.  In many cases, the root module will primarily orchestrate the deployment of modules.
*   **`terraform.tfvars`:** This file contains variable definitions specific to an environment.

**Best Practices:**

*   **Keep Modules Small and Focused:** Each module should have a single responsibility.
*   **Use Variables for Configuration:**  Make your modules configurable using variables.
*   **Use Outputs to Expose Values:**  Expose important values from your modules using outputs.
*   **Version Control:**  Store your Terraform code in a version control system (e.g., Git).
*   **Separate State:**  Use separate state files for each environment to avoid conflicts.  Remote state is highly recommended.
*   **DRY (Don't Repeat Yourself):**  Avoid duplicating code by using modules and variables.

## Providers

A Terraform provider is a plugin that allows Terraform to interact with a specific infrastructure platform, cloud provider, or service. Providers are responsible for understanding API interactions and exposing resources that can be managed by Terraform.

In essence, providers translate Terraform configurations into API calls to create, read, update, and delete resources on the target platform.

**Main Cloud Providers:**

Terraform has providers for all major cloud platforms, including:

*   **AWS (Amazon Web Services):** The AWS provider allows you to manage resources on Amazon's cloud platform, such as EC2 instances, S3 buckets, VPCs, and more. To use the AWS provider, you need to configure your AWS credentials (e.g., access key and secret key) and specify the region.

    ```terraform
    terraform {
      required_providers {
        aws = {
          source  = "hashicorp/aws"
          version = "~> 4.0"
        }
      }
    }

    provider "aws" {
      region = "us-west-2"
      # Configuration options
    }
    ```

*   **GCP (Google Cloud Platform):** The GCP provider enables you to manage resources on Google's cloud platform, such as Compute Engine instances, Cloud Storage buckets, and networking resources. To use the GCP provider, you need to configure your Google Cloud credentials (e.g., service account key) and specify the project.

    ```terraform
    terraform {
      required_providers {
        google = {
          source  = "hashicorp/google"
          version = "~> 4.0"
        }
      }
    }

    provider "google" {
      project = "your-gcp-project-id"
      region  = "us-central1"
      # Configuration options
    }
    ```

*   **Azure (Microsoft Azure):** The Azure provider allows you to manage resources on Microsoft's cloud platform, such as virtual machines, storage accounts, and networking resources. To use the Azure provider, you need to configure your Azure credentials (e.g., using the Azure CLI) and specify the subscription ID.

    ```terraform
    terraform {
      required_providers {
        azurerm = {
          source  = "hashicorp/azurerm"
          version = "~> 3.0"
        }
      }
    }

    provider "azurerm" {
      features {}
      # Configuration options
    }
    ```

**Provider Configuration:**

Each provider has its own set of configuration options, such as region, project, and authentication credentials. These options are typically specified in the `provider` block in your Terraform configuration.

**Finding Providers:**

You can find a comprehensive list of Terraform providers on the Terraform Registry: [https://registry.terraform.io/](https://registry.terraform.io/)

## Syntax

Terraform uses a declarative configuration language to define infrastructure. The basic syntax revolves around several key elements: blocks, providers, resources, and data sources.

**1. Blocks:**

Blocks are the fundamental building blocks of Terraform configuration. They have a type, a label (optional), and a body enclosed in curly braces `{}`.

```terraform
block_type "label" {
  # Block body: attributes and nested blocks
  attribute = "value"

  nested_block "nested_label" {
    # Nested block body
  }
}
```

**2. Providers:**

The `provider` block configures a specific provider, which is responsible for interacting with an infrastructure platform.

```terraform
provider "aws" {
  region = "us-west-2"
  # Other provider-specific settings
}
```

**3. Resources:**

The `resource` block defines a piece of infrastructure, such as a virtual machine, storage bucket, or network interface.

```terraform
resource "aws_instance" "example" {
  ami           = "ami-0c55b947ead33a26a"
  instance_type = "t2.micro"

  tags = {
    Name = "Example Instance"
  }
}
```

*   `aws_instance`: The resource type (e.g., an AWS EC2 instance).
*   `example`: The local name for this resource within the Terraform configuration.
*   The block body defines the attributes of the resource.

**4. Data Sources:**

The `data` block retrieves information from an external source, such as a cloud provider or API. Data sources do not create or modify infrastructure; they only read data.

```terraform
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}
```

*   `aws_ami`: The data source type (e.g., an AWS AMI).
*   `ubuntu`: The local name for this data source.
*   The block body defines the criteria for retrieving the data.

**Attributes and Expressions:**

Within blocks, you define attributes using the `=` operator. Attribute values can be simple strings, numbers, or booleans, or more complex expressions.

```terraform
attribute = "string value"
number    = 123
boolean   = true
list      = ["a", "b", "c"]
map       = {
  key1 = "value1"
  key2 = "value2"
}
```

Terraform also supports expressions, which allow you to dynamically calculate values. Expressions can include variables, functions, and references to other resources or data sources.

```terraform
instance_type = var.instance_type
name          = "instance-${random_string.suffix.result}"
```

## Managing multiple environments

Managing multiple environments (e.g., DEV, TEST, PROD) is a common requirement in infrastructure management. Terraform provides several ways to handle this, and using `.tfvars` files is a popular and effective approach.

**Best Practices:**

1.  **Separate Directories:** Create separate directories for each environment. This provides clear separation and prevents accidental modifications to the wrong environment.

    ```
    ├── environments/
    │   ├── dev/
    │   │   ├── main.tf
    │   │   ├── variables.tf
    │   │   └── terraform.tfvars
    │   ├── test/
    │   │   ├── main.tf
    │   │   ├── variables.tf
    │   │   └── terraform.tfvars
    │   └── prod/
    │       ├── main.tf
    │       ├── variables.tf
    │       └── terraform.tfvars
    ```

2.  **`terraform.tfvars` Files:** Use `terraform.tfvars` files to define environment-specific variable values. This allows you to keep your core Terraform configuration (e.g., `main.tf`, `variables.tf`) generic and customize it for each environment.

    *   `dev/terraform.tfvars`:

        ```terraform
        instance_type = "t2.micro"
        region        = "us-west-2"
        environment   = "dev"
        ```

    *   `test/terraform.tfvars`:

        ```terraform
        instance_type = "t2.small"
        region        = "us-east-1"
        environment   = "test"
        ```

    *   `prod/terraform.tfvars`:

        ```terraform
        instance_type = "t2.medium"
        region        = "us-east-1"
        environment   = "prod"
        ```

3.  **Variables Definition (`variables.tf`):** Define all your variables in a `variables.tf` file. This makes your configuration more organized and easier to understand.

    ```terraform
    variable "instance_type" {
      type        = string
      description = "The EC2 instance type"
    }

    variable "region" {
      type        = string
      description = "The AWS region"
    }

    variable "environment" {
      type        = string
      description = "The environment (dev, test, prod)"
    }
    ```

4.  **Usage in `main.tf`:** Reference the variables in your `main.tf` file.

    ```terraform
    resource "aws_instance" "example" {
      ami           = "ami-0c55b947ead33a26a"
      instance_type = var.instance_type

      tags = {
        Name        = "Example Instance"
        Environment = var.environment
      }
    }
    ```

5.  **Applying Configurations:** To apply the configuration for a specific environment, navigate to the environment's directory and run `terraform init`, `terraform plan`, and `terraform apply`. Terraform automatically loads the `terraform.tfvars` file in the current directory.

    ```bash
    cd environments/dev
    terraform init
    terraform plan
    terraform apply
    ```

6.  **Benefits:**

    *   **Clear Separation:** Each environment has its own directory and configuration files.
    *   **Reusability:** The core Terraform configuration is reusable across environments.
    *   **Flexibility:** You can easily customize each environment by modifying the `terraform.tfvars` file.
    *   **Security:** You can store sensitive values (e.g., API keys) in separate `terraform.tfvars` files and manage them securely.

7. **Alternative approaches:**

    *   **Using Input Variables:** You can specify variable values directly on the command line using the `-var` flag. However, this is less convenient for managing multiple environments.
    *   **Using Environment Variables:** You can set environment variables with the `TF_VAR_` prefix. This can be useful for CI/CD pipelines, but it can be less transparent than using `.tfvars` files.

## Managing/using preexisting resources (state management)

Sometimes, you need to manage resources with Terraform that already exist outside of your Terraform configuration. While `terraform import` can bring existing resources under Terraform management, another common scenario is needing to reference existing resources for context without fully managing them. This is where the `data` resource block becomes invaluable.

**Using Data Sources to Capture Information:**

The `data` block allows you to read information about existing resources without attempting to create, update, or delete them. This is particularly useful when you need to reference properties of resources that are managed elsewhere or are outside the scope of your current Terraform configuration.

**Example: Referencing an Existing Azure Virtual Network**

Suppose you have an Azure Virtual Network that was created outside of Terraform, and you want to create a subnet within that existing network using Terraform. You can use the `azurerm_virtual_network` data source to retrieve information about the existing virtual network.

```terraform
data "azurerm_virtual_network" "existing" {
  name                = "existing-vnet"
  resource_group_name = "existing-resource-group"
}

resource "azurerm_subnet" "subnet" {
  name                 = "new-subnet"
  resource_group_name  = data.azurerm_virtual_network.existing.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.existing.name
  address_prefixes     = ["10.0.1.0/24"]
}
```

**Explanation:**

1.  **`data "azurerm_virtual_network" "existing"`:** This block defines a data source that retrieves information about an Azure Virtual Network.
    *   `name`: Specifies the name of the existing virtual network.
    *   `resource_group_name`: Specifies the name of the resource group containing the virtual network.

2.  **`resource "azurerm_subnet" "subnet"`:** This block defines a new subnet that will be created within the existing virtual network.
    *   `resource_group_name`: Uses the `resource_group_name` attribute from the `azurerm_virtual_network` data source to ensure the subnet is created in the same resource group as the virtual network.
    *   `virtual_network_name`: Uses the `name` attribute from the `azurerm_virtual_network` data source to associate the subnet with the correct virtual network.
    *   `address_prefixes`: Defines the address prefix for the new subnet.

**Benefits of Using Data Sources:**

*   **Referencing Existing Resources:** Allows you to reference existing infrastructure components without managing their entire lifecycle.
*   **Dynamic Configuration:** Enables you to dynamically configure your Terraform resources based on the properties of existing resources.
*   **Reduced Scope:** Limits the scope of your Terraform configuration to only the resources you need to manage, while still providing the necessary context from existing resources.

**Important Considerations:**

*   **Data Source Attributes:** Ensure you understand the attributes exposed by the data source and use them correctly in your resource configurations.
*   **Resource Existence:** Data sources will fail if the specified resource does not exist. Consider using `try()` or `optional()` functions to handle cases where the resource might not always be present.
*   **Permissions:** The Terraform provider must have the necessary permissions to read the attributes of the existing resource.

## Modules

Terraform modules are reusable, self-contained packages of Terraform configurations that can be used to create infrastructure components. Modules help you organize and simplify your Terraform code, making it easier to manage and maintain.

**Creating a Local Module (Example: `storage-account-module`)**

Let's assume you have a module named `storage-account-module` located in the `src/modules` directory of your Terraform project. This module is designed to create an Azure Storage Account with configurable networking settings.

**1. Module Structure:**

The `storage-account-module` directory contains the following files:

*   `main.tf`: Contains the main resource definitions for the storage account.
*   `variables.tf`: Defines the input variables for the module.
*   `outputs.tf`: Defines the output values that the module exposes.

**2. `variables.tf` (Example):**

```terraform
variable "resource_group" {
  type = object({
    name     = string
    location = string
  })
  description = "The resource group in which to create the storage account."
}

variable "base_name" {
  type        = string
  description = "The base name for the storage account."
}

variable "network_config" {
  type = object({
    enable_public_access     = bool
    virtual_network_subnet_ids = list(string)
  })
  default = {
    enable_public_access     = true
    virtual_network_subnet_ids = []
  }
  description = "Networking configuration for the storage account."
}
```

**3. `main.tf` (Example):**

```terraform
resource "azurerm_storage_account" "content_sa" {
  name                     = "${var.base_name}sa"
  resource_group_name      = var.resource_group.name
  location                 = var.resource_group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  identity {
    type = "SystemAssigned"
  }

  public_network_access_enabled = var.network_config.enable_public_access
  shared_access_key_enabled     = true
  https_traffic_only_enabled    = true
  min_tls_version             = "TLS1_2"

  network_rules {
    default_action             = var.network_config.enable_public_access ? "Allow" : "Deny"
    bypass                     = ["AzureServices"]
    virtual_network_subnet_ids = var.network_config.virtual_network_subnet_ids
  }
}
```

**4. Using the Local Module:**

To use the `storage-account-module` in your root module, you need to reference it using the `module` block and provide the required input variables.

```terraform
module "storage_account" {
  source = "./src/modules/storage-account-module"

  resource_group = {
    name     = "existing-resource-group"
    location = "westus2"
  }
  base_name = "uniqueapp"
  network_config = {
    enable_public_access     = false
    virtual_network_subnet_ids = ["/subscriptions/your-subscription-id/resourceGroups/your-rg/providers/Microsoft.Network/virtualNetworks/your-vnet/subnets/your-subnet"]
  }
}
```

**Explanation:**

*   **`source = "./src/modules/storage-account-module"`:** Specifies the path to the local module directory.
*   **`resource_group = { ... }`:** Provides the values for the `resource_group` input variable.
*   **`base_name = "uniqueapp"`:** Provides the value for the `base_name` input variable.
*   **`network_config = { ... }`:** Provides the values for the `network_config` input variable, disabling public access and associating the storage account with a specific subnet.

**5. Outputs (Optional):**

If your module defines output values in `outputs.tf`, you can access them in your root module using the `module.<module_name>.<output_name>` syntax.

```terraform
output "storage_account_id" {
  value = module.storage_account.storage_account_id
}
```

**Benefits of Using Modules:**

*   **Reusability:** Modules can be reused across multiple projects or environments.
*   **Organization:** Modules help you organize your Terraform code into logical units.
*   **Abstraction:** Modules provide an abstraction layer, hiding the complexity of the underlying infrastructure components.
*   **Maintainability:** Modules make it easier to maintain and update your Terraform code.

## Remote modules

In addition to local modules, Terraform allows you to use modules from remote sources, such as the Terraform Registry, Git repositories, or internal module repositories. This enables you to leverage pre-built, community-maintained, or organization-specific modules in your infrastructure configurations.

**1. Terraform Registry:**

The Terraform Registry ([https://registry.terraform.io/](https://registry.terraform.io/)) is a public repository of Terraform modules. You can use modules from the registry by specifying the module source in the following format:

```terraform
module "example" {
  source  = "hashicorp/consul/aws"
  version = "~> 1.0.0"

  # Module inputs
}
```

*   `source = "hashicorp/consul/aws"`: Specifies the module source in the format `<namespace>/<name>/<provider>`.
*   `version = "~> 1.0.0"`: Specifies the module version.

**2. Git Repository:**

You can use modules from Git repositories by specifying the Git URL as the module source. Terraform supports various Git providers, including GitHub, GitLab, and Bitbucket.

```terraform
module "example" {
  source = "git::https://github.com/your-org/terraform-modules.git//storage-account-module?ref=v1.0.0"

  # Module inputs
}
```

*   `source = "git::https://github.com/your-org/terraform-modules.git//storage-account-module?ref=v1.0.0"`: Specifies the Git URL, the path to the module within the repository (`//storage-account-module`), and the Git reference (e.g., tag, branch, commit) using the `ref` parameter.

**3. Internal Module Repository:**

If your organization has an internal module repository, you can use modules from that repository by specifying the appropriate source URL. The specific format of the source URL will depend on the repository type.

**Benefits of Using Remote Modules:**

*   **Code Reuse:** Avoid writing code from scratch by leveraging pre-built modules.
*   **Community Contributions:** Benefit from the expertise and contributions of the Terraform community.
*   **Standardization:** Enforce consistent infrastructure configurations across your organization by using standardized modules.
*   **Version Control:** Manage module versions and dependencies using Git or other version control systems.

## DevOps

DevOps practices are essential for automating and streamlining the Terraform deployment lifecycle. GitHub Actions provides a powerful platform for creating CI/CD pipelines to manage Terraform deployments to multiple environments.

**Creating a GitHub Actions CI/CD Pipeline:**

1.  **Workflow File:** Create a workflow file in the `.github/workflows` directory of your repository (e.g., `.github/workflows/terraform.yml`).

2.  **Workflow Definition:** Define the workflow using YAML syntax. The workflow typically consists of the following steps:

    *   **Checkout Code:** Check out the code from the repository.
    *   **Terraform Init:** Initialize the Terraform working directory.
    *   **Terraform Validate:** Validate the Terraform configuration.
    *   **Terraform Plan:** Generate a Terraform plan.
    *   **Terraform Apply:** Apply the Terraform configuration (typically requires manual approval for production environments).

**Example CI Workflow File (`.github/workflows/terraform-ci.yml`):**

```yaml
name: Terraform-CI

on:
  workflow_dispatch:
  pull_request:
    types: [closed]
    branches:
      - main
    paths:
      - "src/**"
      - ".github/workflows/terraform-ci.yml"
      - ".github/workflows/terraform-cd.yml"

env:
  ARM_CLIENT_ID: ${{ secrets.ARM_CLIENT_ID }}
  ARM_CLIENT_SECRET: ${{ secrets.ARM_CLIENT_SECRET }}
  ARM_SUBSCRIPTION_ID: ${{ secrets.ARM_SUBSCRIPTION_ID }}
  ARM_TENANT_ID: ${{ secrets.ARM_TENANT_ID }}
  TF_VAR_resource_group_name: rg-terraform-github-actions
  TF_VAR_location: eastus3

jobs:
  terraform:
    name: Terraform
    name: "Terraform build/integrate"
    if: >
      github.event_name == 'workflow_dispatch' || github.event.pull_request.merged == true

    runs-on: ubuntu-latest
    permissions:
      contents: read
      id-token: write
    defaults:
      run:
        working-directory: ./src
    env:
      ARM_CLIENT_ID: ${{ secrets.ARM_CLIENT_ID }}
      ARM_CLIENT_SECRET: ${{ secrets.ARM_CLIENT_SECRET }}
      ARM_SUBSCRIPTION_ID: ${{ secrets.ARM_SUBSCRIPTION_ID }}
      ARM_TENANT_ID: ${{ secrets.ARM_TENANT_ID }}

    steps:
      - name: Checkout
        uses: actions/checkout@v4
        with:
          ref: ${{ github.event_name == 'workflow_run' && github.event.workflow_run.head_branch || github.ref }}
          token: ${{ secrets.GITHUB_TOKEN }}
          fetch-depth: 0

      - name: Azure login
        uses: azure/login@v2
        with:
          client-id: ${{ secrets.ARM_CLIENT_ID }}
          subscription-id: ${{ secrets.ARM_SUBSCRIPTION_ID }}
          tenant-id: ${{ secrets.ARM_TENANT_ID }}
          allow-no-subscriptions: true
          enable-AzPSSession: false
          environment: "AzureCloud"

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v3

      - name: Terrformm init
        run: terraform init -no-color

      - name: Terrform validate
        id: validate
        run: terraform validate -no-color
```

*Example CD Workflow File (`.github/workflows/terraform-cd.yml`):**

```yaml
name: Terraform-CD

on:
  workflow_dispatch:
  workflow_run:
    workflows: ["Terraform-CI"]
    types:
      - completed

env:
  ARM_CLIENT_ID: ${{ secrets.ARM_CLIENT_ID }}
  ARM_CLIENT_SECRET: ${{ secrets.ARM_CLIENT_SECRET }}
  ARM_SUBSCRIPTION_ID: ${{ secrets.ARM_SUBSCRIPTION_ID }}
  ARM_TENANT_ID: ${{ secrets.ARM_TENANT_ID }}
  TF_VAR_resource_group_name: rg-terraform-github-actions
  TF_VAR_location: westus3


permissions: read-all

jobs:
  terraform:
    name: "Terraform build/deploy"
    if: ${{ github.event.workflow_run.conclusion == 'success' }}

    runs-on: ubuntu-latest
    permissions:
      contents: read
      id-token: write
    defaults:
      run:
        working-directory: ./src
    env:
      ARM_CLIENT_ID: ${{ secrets.ARM_CLIENT_ID }}
      ARM_CLIENT_SECRET: ${{ secrets.ARM_CLIENT_SECRET }}
      ARM_SUBSCRIPTION_ID: ${{ secrets.ARM_SUBSCRIPTION_ID }}
      ARM_TENANT_ID: ${{ secrets.ARM_TENANT_ID }}

    steps:
      - name: Checkout
        uses: actions/checkout@v4
        with:
          ref: ${{ github.event_name == 'workflow_run' && github.event.workflow_run.head_branch || github.ref }}
          token: ${{ secrets.GITHUB_TOKEN }}
          fetch-depth: 0

      - name: Azure login
        uses: azure/login@v2
        with:
          client-id: ${{ secrets.ARM_CLIENT_ID }}
          subscription-id: ${{ secrets.ARM_SUBSCRIPTION_ID }}
          tenant-id: ${{ secrets.ARM_TENANT_ID }}
          allow-no-subscriptions: true
          enable-AzPSSession: false
          environment: "AzureCloud"

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v3

      - name: Terrformm init
        run: terraform init -no-color

      - name: Terrform plan
        id: plan
        run: terraform plan -no-color -var-file=./dev.tfvars

      - name: Terrform apply
        id: apply
        run: terraform apply --auto-approve -no-color -var-file=./dev.tfvars
```

## Trouble shooting issues

Terraform deployments can sometimes encounter issues. Here are some common problems and strategies for finding and debugging their root causes:

**1. Syntax Errors:**

*   **Issue:** Terraform configuration files contain syntax errors, preventing Terraform from parsing the configuration.
*   **Debugging:**
    *   Run `terraform validate`: This command checks the syntax of your Terraform files and reports any errors.
    *   Carefully review the error messages: Terraform error messages often provide the line number and a description of the syntax error.
    *   Use a Terraform language server: IDE extensions for Terraform can provide real-time syntax checking and error highlighting.

**2. Provider Errors:**

*   **Issue:** The Terraform provider encounters an error while interacting with the infrastructure platform (e.g., AWS, Azure, GCP).
*   **Debugging:**
    *   Review the error message: Provider error messages often contain details about the API call that failed and the reason for the failure.
    *   Check provider credentials: Ensure that the Terraform provider has the necessary permissions to create, read, update, and delete resources on the target platform.
    *   Verify resource limits: Check if you have exceeded any resource limits on the target platform (e.g., maximum number of virtual machines).
    *   Examine provider logs: Some providers provide logs that can help you diagnose issues.

**3. State Conflicts:**

*   **Issue:** The Terraform state file is out of sync with the actual infrastructure, leading to conflicts when Terraform attempts to modify resources.
*   **Debugging:**
    *   Run `terraform refresh`: This command updates the Terraform state file with the current state of the infrastructure.
    *   Inspect the Terraform plan: Carefully review the Terraform plan to identify any unexpected changes.
    *   Use state locking: Remote state backends provide state locking to prevent concurrent modifications that can lead to state corruption.
    *   Manually update the state file (as a last resort): If the state file is severely corrupted, you may need to manually edit it to match the actual infrastructure. **Use extreme caution when doing this, as it can lead to data loss or infrastructure instability.**

**4. Dependency Issues:**

*   **Issue:** Resources depend on each other, and Terraform fails to create or update resources in the correct order.
*   **Debugging:**
    *   Use explicit dependencies: Use the `depends_on` attribute to explicitly define dependencies between resources.
    *   Review the Terraform plan: The Terraform plan shows the order in which resources will be created or updated.
    *   Use data sources: Data sources can be used to retrieve information about existing resources, which can help Terraform determine the correct order of operations.

**5. Variable Issues:**

*   **Issue:** Incorrect or missing variable values can cause Terraform to fail.
*   **Debugging:**
    *   Verify variable values: Ensure that all required variables have been assigned values.
    *   Check variable types: Ensure that variable values are of the correct type (e.g., string, number, boolean).
    *   Use default values: Provide default values for optional variables to prevent errors if the variables are not explicitly set.

**6. Module Issues:**

*   **Issue:** Problems within a module can cause Terraform to fail.
*   **Debugging:**
    *   Isolate the module: Test the module in isolation to identify any issues.
    *   Check module inputs: Ensure that the module is receiving the correct input values.
    *   Review module code: Carefully review the module code for errors.

**General Troubleshooting Tips:**

*   **Read the Error Messages Carefully:** Terraform error messages often provide valuable information about the cause of the problem.
*   **Use Verbose Logging:** Enable verbose logging by setting the `TF_LOG` environment variable to `DEBUG` or `TRACE`.
*   **Simplify the Configuration:** Try simplifying the Terraform configuration to isolate the problem.
*   **Test Incrementally:** Make small, incremental changes to the configuration and test them frequently.
*   **Consult the Terraform Documentation:** The Terraform documentation provides detailed information about Terraform concepts, providers, and resources.
*   **Search Online Forums and Communities:** Many online forums and communities are dedicated to Terraform, where you can find answers to common questions and get help from other users.


