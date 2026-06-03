#!/bin/bash
# Script para associar build e preencher metadados no App Store Connect
# NOTA: Screenshots e Review Information precisam ser feitos manualmente no web UI

set -e

ISSUER_ID="20a81f12-b22c-4ff8-8b33-c1e5e411a24b"
KEY_ID="95ULBVD2BW"
KEY_PATH="$HOME/Downloads/AuthKey_95ULBVD2BW.p8"
APP_ID="6770621754"
VERSION_ID="2cb9d05d-818c-4e2f-957c-04ec4aaaf0b2"
LOCALIZATION_ID="4be037c7-304b-43de-9ee0-a08c7638dc7f"
BUILD_ID="00d526ce-5b91-4b3e-ba65-2fd4f77d0b66"

echo "🚀 VouDeQue — App Store Submission Script"
echo "=========================================="

# Gerar JWT
JWT=$(python3 -c "
import jwt, time
with open('$KEY_PATH', 'r') as f:
    key = f.read()
headers = {'alg': 'ES256', 'kid': '$KEY_ID', 'typ': 'JWT'}
payload = {'iss': '$ISSUER_ID', 'iat': int(time.time()), 'exp': int(time.time()) + 1200, 'aud': 'appstoreconnect-v1'}
print(jwt.encode(payload, key, algorithm='ES256', headers=headers))
")

echo ""
echo "📋 CHECKLIST DE SUBMISSÃO:"
echo "--------------------------"

# 1. Associar build à versão
echo ""
echo "1️⃣  Associando build à versão..."
curl -s -X PATCH \
  -H "Authorization: Bearer $JWT" \
  -H "Content-Type: application/json" \
  "https://api.appstoreconnect.apple.com/v1/appStoreVersions/$VERSION_ID/relationships/build" \
  -d "{
    \"data\": {
      \"type\": \"builds\",
      \"id\": \"$BUILD_ID\"
    }
  }" | python3 -m json.tool 2>/dev/null || echo "   ⚠️  Pode precisar fazer manualmente no web UI"

# 2. Atualizar localização (metadados)
echo ""
echo "2️⃣  Preenchendo metadados em pt-BR..."
curl -s -X PATCH \
  -H "Authorization: Bearer $JWT" \
  -H "Content-Type: application/json" \
  "https://api.appstoreconnect.apple.com/v1/appStoreVersionLocalizations/$LOCALIZATION_ID" \
  -d '{
    "data": {
      "type": "appStoreVersionLocalizations",
      "id": "'"$LOCALIZATION_ID"'",
      "attributes": {
        "description": "VouDeQue é seu estilista pessoal alimentado por Inteligência Artificial. Gere looks perfeitos para qualquer ocasião em segundos. Escolha entre casual, trabalho, festa, date e muito mais. Receba combinações únicas com peças, cores e justificativas. Compartilhe na comunidade, participe de desafios diários e descubra seu estilo!",
        "keywords": "looks,moda,ia,ai,estilo,roupa,combinar,outfit,fashion,look do dia",
        "marketingUrl": "https://voudeque-landing.vercel.app",
        "promotionalText": "Gere looks perfeitos em segundos com IA. Seu estilista pessoal no bolso! ✨",
        "supportUrl": "https://voudeque-landing.vercel.app",
        "whatsNew": "• Geração de looks com IA em segundos\n• Desafios diários e ranking\n• Feed da comunidade\n• Compartilhamento para redes sociais\n• Suporte a exclusão de conta"
      }
    }
  }' | python3 -m json.tool 2>/dev/null || echo "   ⚠️  Pode precisar fazer manualmente no web UI"

# 3. Verificar status
echo ""
echo "3️⃣  Verificando status do app..."
curl -s -H "Authorization: Bearer $JWT" \
  "https://api.appstoreconnect.apple.com/v1/appStoreVersions/$VERSION_ID" | python3 -c "
import json, sys
data = json.load(sys.stdin)
state = data['data']['attributes']['appStoreState']
print(f'   Status: {state}')
if state == 'PREPARE_FOR_SUBMISSION':
    print('   ✅ Pronto para preencher dados restantes e submeter')
"

echo ""
echo "=========================================="
echo "✅ Metadados preenchidos via API!"
echo ""
echo "📸 PRÓXIMOS PASSOS MANUAIS:"
echo "   1. Acesse: https://appstoreconnect.apple.com/apps/$APP_ID/appstore"
echo "   2. Faça upload dos screenshots (6 telas, 1290x2796px)"
echo "   3. Preencha App Privacy (dados coletados)"
echo "   4. Preencha Review Information (contato, demo account)"
echo "   5. Clique em 'Add for Review'"
echo ""
echo "⏱️  Review da Apple: 24-48h"
