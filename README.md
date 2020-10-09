# terraform-aws-letsencrypt

A terraform module to issue and maintain [Let's Encrypt certificates](https://letsencrypt.org/) for AWS using Fargate. The module utilizes the [USSBA/sba-certificate-renewal](https://hub.docker.com/r/ussba/sba-certificate-renewal) docker image to facilitate the renewing of certificates. For more insight into how this all works, check out the [GitHub repo](https://github.com/USSBA/sba-certificate-renewal).

Features:

* Straightforward and sane defaults
* Wildcard cert issued by default
* Ability to notify an SNS topic

## Prerequisites

* S3 bucket to store and backup the certificates
* Depending on your top level domain, you may need a [CAA record](https://letsencrypt.org/docs/caa/) for the domain you are requesting a cert for.

Example CAA record set value that allows [Amazon](https://docs.aws.amazon.com/acm/latest/userguide/setup-caa.html) and Letsencrypt issue certs for you domain:

```
0 issue "letsencrypt.org"
0 issue "amazon.com"
0 issue "amazontrust.com"
0 issue "awstrust.com"
0 issue "amazonaws.com"
```

## Usage

### Variables

#### Required

* `service_name` - A name for the Fargate service.
* `environment_name` - Name of your environment, e.g. Dev, Staging, Prod, etc. Used to seperate out your certs in the S3 bucket and for various naming conventions. Do not use special characters like `/`.
* `aws_s3_bucket_name` - The name of the S3 bucket where certs will be stored.
* `registration_email` - The email address under which the LetsEncrypt certificate will be created.
* `cert_hostname` - The hostname to be registered. Do not include wildcard, e.g. `cheeseburger.mydomain.com`
* `hosted_zone_id` - The Route53 Hosted Zone ID of the domain needing a cert. Used for domain validation.
* `cluster_name` - The name of the ECS cluster where the fargate task should run.
* `subnet_ids` - A list of subnet id's that the task can run on.

#### Optional

* `container_name` - Default `ussba/sba-certificate-renewal:latest`; The Letsencrypt certificate renewal Docker Image. Highly recommended to not change this unless you have your own working process.
* `container_cpu` - Default `256`; How much CPU should be reserved for the container (in aws cpu-units).
* `container_memory` - Default `512`; How much Memory should be reserved for the container (in MB).
* `dry_run` - Default `false`; Enable or disable dry run of renewal process.
* `log_stream_prefix` - Default `letsencrypt`; Name of the stream prefix to be used in the Cloudwatch log group.
* `log_retention_in_days` - Default `60`; The number of days you want to retain log events in the log group.
* `registration_wildcard` - Default `true`; Whether or not a wildcard certificate should be requested.
* `sns_topic_arn` - Default `""`; What SNS Topic ARN should be used for notifying.
* `schedule_expression` - Default `rate(7 days)`; How often Cloudwatch Events should kick off the renewal task. Recommended to run at least every 30 days.

### Example

```terraform
module "my-letsencrypt-renewal-task" {
  source             = "USSBA/letsencrypt/aws"
  version            = "~> 2.1"
  service_name       = "letsencrypt-renewal"
  environment_name   = "cheeseburger"
  aws_s3_bucket_name = "my-bucket-name"
  registration_email = "my-email@cheeseburger.cool"
  cert_hostname      = "cheeseburger.mydomain.com"
  hosted_zone_id     = "Z000000000000"
  cluster_name       = "cheeseburger"
  subnet_ids         = ["subnet-a46032fc"]
}
```

## Contributing

We welcome contributions.
To contribute please read our [CONTRIBUTING](CONTRIBUTING.md) document.

All contributions are subject to the license and in no way imply compensation for contributions.

### Terraform 0.12

Our code base now exists in Terraform 0.13 and we are halting new features in the Terraform 0.12 major version.  If you wish to make a PR or merge upstream changes back into 0.12, please submit a PR to the `terraform-0.12` branch.

## Code of Conduct

We strive for a welcoming and inclusive environment for all SBA projects.

Please follow this guidelines in all interactions:

* Be Respectful: use welcoming and inclusive language.
* Assume best intentions: seek to understand other's opinions.

## Security Policy

Please do not submit an issue on GitHub for a security vulnerability.
Instead, contact the development team through [HQVulnerabilityManagement](mailto:HQVulnerabilityManagement@sba.gov).
Be sure to include **all** pertinent information.
