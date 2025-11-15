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

