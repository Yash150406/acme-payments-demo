# acme-payments-demo

⚠️ **Intentionally vulnerable demo repository.**
Scan target for SentinelIQ. All credentials are fake
(AWS documented dummy keys only). Do not deploy. Do not copy patterns.

## Planted issues (by finding type)

| Type | Where |
|---|---|
| hardcoded_secret | app/main.py, terraform/main.tf, docker-compose.yml |
| vulnerable_dependency | app/requirements.txt |
| public_s3_bucket | terraform/main.tf |
| open_security_group | terraform/main.tf |
| unencrypted_storage | terraform/main.tf |
| overly_permissive_iam | terraform/main.tf |
| weak_tls | terraform/main.tf |
| missing_logging | terraform/main.tf, app/Dockerfile |

## Scan

    checkov -d . --compact -o json --output-file checkov_output.json
    socket scan create ./app --json > socket_deps_output.json
    nmap -sV -p 1-10000 127.0.0.1 -oX nmap_output.xml
