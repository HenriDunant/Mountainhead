# Mountainhead
Stand up a reproducible Azure platform that ships containerized apps, provisions infra with Terraform, and enforces cost controls by default—including a Budget Kill Switch (BKS) that safely scales down/pauses non-critical resources when monthly spend crosses thresholds.

This serves as accumulation of my knowledge from my collaborative experience in Cloud project with related functions from my professional career 

Terraform-driven Azure landing zone + container runtime with FinOps guardrails.
**No GitHub Actions**; GitHub Desktop + VS Code Dev Containers workflow.

## Stack
Terraform · Docker · GitHub Desktop · VS Code · PowerShell · Azure · FinOps

## Phases
- Phase 0: Devcontainer + remote tfstate + TF scaffold
- Phase 1: Policy/ACR/KV/Logs
- Phase 2: Budgets + lifecycle
- Phase 3: Budget Kill Switch (BKS)

## Getting started
1. Install Docker Desktop, VS Code, GitHub Desktop, Azure CLI.
2. Clone with GitHub Desktop.
3. Open in VS Code → “Reopen in Container”.
4. Run `scripts/bootstrap-tfstate.ps1` (PowerShell host) to create remote state.
5. `terraform init -backend-config=backend.hcl` inside `infra/platform`.
