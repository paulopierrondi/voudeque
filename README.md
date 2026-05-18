# VouDeQue

Seu estilista de IA. Tire uma foto, escolha a ocasião e receba looks completos em segundos.

## O que é

VouDeQue é um app iOS de moda com IA generativa e componente social.
O usuário tira uma foto de si mesmo ou de uma peça do guarda-roupa, e uma IA (Gemini Flash)
monta looks completos com descrição, lista de itens e imagem gerada.

O app inclui desafios diários de estilo, feed social da comunidade, votação e ranking.

## Stack

- **iOS**: SwiftUI, async/await, PhotoPicker, ShareSheet
- **Backend**: Python 3.11, FastAPI, PostgreSQL, SQLAlchemy
- **AI**: Google Gemini 2.0 Flash (visão + texto)
- **Deploy**: Railway (Docker), App Store Connect
- **Landing**: HTML/CSS/JS estático

## Estrutura

```
voudeque/
├── ios/VouDeQue/          # App iOS SwiftUI
├── backend/               # API FastAPI
│   ├── app/
│   │   ├── api/routes.py
│   │   ├── core/config.py
│   │   ├── schemas/look.py
│   │   └── services/ai_service.py
│   ├── Dockerfile
│   └── requirements.txt
├── landing/               # Landing page
└── .brain/                # Contexto do projeto
```

## Como rodar local

### Backend

```bash
cd backend
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
cp .env.example .env
# Edite .env com GEMINI_API_KEY
uvicorn app.main:app --reload --port 8000
```

### iOS

```bash
cd ios/VouDeQue
open VouDeQue.xcodeproj
```

### Landing

```bash
cd landing
python -m http.server 8080
```

## Deploy

### Railway

1. Crie um projeto no Railway.
2. Configure as variáveis de ambiente (`GEMINI_API_KEY`, `DATABASE_URL`, `JWT_SECRET`).
3. Deploy via Dockerfile (`railway.toml` já configurado).

### App Store

1. Configure App Store Connect com bundle ID `com.paulopierrondi.voudeque`.
2. Build e archive via Xcode.
3. Upload via Transporter ou Xcode.

## Monetização

- Freemium: 3 looks/dia grátis.
- Premium: looks ilimitados + desafios exclusivos.
- R$ 19,90/mês ou R$ 119,90/ano.

## TikTok Strategy

- Hook: "Minha IA me vestiu em 3 segundos"
- Formatos: antes/depois, reação a look gerado, batalha de estilo com amiga.
- CTA: "Baixa o app e descobre seu look de hoje".

## Licença

Proprietário — Paulo Pierrondi.
