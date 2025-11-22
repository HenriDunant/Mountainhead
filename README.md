# Mountainhead
A reproducible Azure platform that ships containerized apps, provisions infra with Terraform, and enforces cost controls by default—including a Budget Kill Switch (BKS) that safely scales down/pauses non-critical resources when monthly spend crosses thresholds.

A Terraform-driven Azure landing zone + container runtime with FinOps guardrails.

This serves as accumulation of my knowledge from my collaborative experience in Cloud project with related functions from my professional career. (Even though it's an indirect respondsibility, but hey)

## Disclaimer
This is not a "AI built this app in X minutes demo". What you see will probably burns your eyes out. But hey, I am trying to iron the kinks out and trying to do better day by day

## Stack
Terraform · Docker · GitHub Desktop · VS Code · PowerShell · Azure · FinOps

## Phases
- Phase 0: Devcontainer + remote tfstate + TF scaffold
- Phase 1: Policy/ACR/KV/Logs
- Phase 2: Budgets + lifecycle
- Phase 3: Budget Kill Switch (BKS)

