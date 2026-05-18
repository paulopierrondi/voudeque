#!/bin/bash
set -e

# Deploy VouDeQue backend to Railway
# Requer: railway CLI instalado e autenticado
# Instalar: npm install -g @railway/cli

PROJECT_ID="abf9e104-6bd0-4d21-b0e0-17e6949eae6b"

echo "=== VouDeQue Railway Deploy ==="
echo "Project ID: $PROJECT_ID"

# Link project
railway link --project "$PROJECT_ID"

# Provision PostgreSQL (se ainda nao existir)
echo "Verifique se o PostgreSQL esta provisionado no Railway dashboard."
echo "Se nao estiver, adicione um database PostgreSQL ao projeto."

# Deploy backend
cd backend
railway up

echo "=== Deploy iniciado ==="
echo "Acompanhe em: https://railway.app/project/$PROJECT_ID"
