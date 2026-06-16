#!/bin/bash
set -euo pipefail

log() { echo "[$(date '+%H:%M:%S')] $*"; }

# ── 1. Install ArgoCD ──────────────────────────────────
log "Installing ArgoCD..."
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml --server-side

log "Waiting for ArgoCD to be ready..."
kubectl wait --for=condition=available deployment/argocd-server \
  -n argocd --timeout=180s
log "ArgoCD ready"

# ── 2. Apply management chart via ArgoCD ───────────────
log "Applying management app..."
kubectl apply -f argocd.yaml
log "Management app submitted to ArgoCD"
