# Pulsewatch

Pulsewatch is an uptime monitoring app. You give it a list of websites, it checks them every minute, and it shows you which ones are up, how fast they respond, and their history.

I'm building it as part of my CoderCo DevOps programme. The app itself is simple on purpose. The point of the project is everything around it: the AWS infrastructure in Terraform, the pipelines, and doing it properly and securely.

> **Status: work in progress.** The infrastructure is being built module by module. The app, pipelines and screenshots come next.

## How it works

One Docker image runs as two services on ECS Fargate:

- **Web** serves the dashboard. It sits behind a load balancer and only does something when someone visits.
- **Worker** runs all the time in the background. It pings every site on the list and saves the results to the database.

That always-on worker is the reason this runs on ECS and not as a serverless function.

## Architecture

![Pulsewatch architecture](/docs/images/architecture.svg)

- Visitors come in through the internet gateway to the ALB, which ends HTTPS and passes the request to a web task
- Tasks reach out to the internet (for example the worker pinging sites) through the NAT gateway in their own AZ
- The database subnets have no route to the internet in either direction. Only the web and worker tasks can reach RDS

Region: `eu-west-2` (London). Domain: `pulsewatch.karimothman.co.uk`.

## What's built so far

- [x] **Bootstrap**: S3 bucket for Terraform state (versioned, encrypted, locked with `use_lockfile`), GitHub OIDC provider, and two IAM roles for the pipelines
- [x] **Networking**: VPC, 6 subnets over 2 AZs, internet gateway, one NAT gateway per AZ, route tables
- [x] **Security groups**: one per role (ALB, web, worker, RDS), referencing each other instead of IP ranges
- [x] **ECR**: image repository with immutable tags, scan on push and a lifecycle policy
- [x] **ACM**: TLS certificate validated through Route 53 DNS
- [x] ALB
- [x] RDS
- [ ] CloudWatch logs and alarms
- [ ] ECS cluster and services
- [ ] The app (Next.js dashboard, worker, `/health` endpoint, Dockerfile)
- [ ] CI/CD pipelines

## Repo structure

```
terraform/
  bootstrap/            state bucket, OIDC, IAM roles (built once, never destroyed)
  modules/
    networking/
    security-groups/
    ecr/
    acm/
  environments/
    prod/               calls the modules, this is where plan and apply run
```

## Decisions I made and why

**No AWS keys in GitHub.** The pipelines log in with OIDC and get short-lived credentials instead.

**Two pipeline roles, not one.** The repo is public, so pull requests from forks can run before anyone reviews them. The role for pull requests can only plan (read-only). Only code merged to `main` gets the role that can apply.

**One NAT gateway per AZ.** The module defaults to a single NAT to save money, but prod runs one per AZ so losing a zone doesn't cut off the other. I destroy the environment after every session, so the extra cost is small.

**Security groups reference each other.** For example RDS only allows the web and worker security groups on port 5432. Fargate tasks change IP all the time, so IP-based rules would break.

**The Route 53 hosted zone isn't managed by Terraform.** It's read with a data block. I destroy everything at the end of each session, and this way destroy can never delete the zone or change my nameservers.

## Running it

You need Terraform 1.10 or newer and AWS credentials for the account.

```bash
# one time only
cd terraform/bootstrap
terraform init
terraform apply

# the environment
cd ../environments/prod
terraform init
terraform plan
terraform apply

# when finished
terraform destroy
```

## Author

Karim Othman, [github.com/K-Othman](https://github.com/K-Othman)