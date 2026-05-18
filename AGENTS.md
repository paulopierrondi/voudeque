# AGENTS.md — VouDeQue

## Contexto

VouDeQue é um app iOS de moda com IA que responde à pergunta "Vou de quê?".
O usuário tira foto de si mesmo ou de peças do guarda-roupa, e uma IA generativa monta looks completos para qualquer ocasião (trabalho, date, festa, academia).

O app tem componente social forte: desafios diários de estilo, feed da comunidade, votação em looks e ranking de estilistas.

## Stack

- **iOS**: SwiftUI, Combine, Async/Await, Camera/Photos, ShareSheet
- **Backend**: Python 3.11, FastAPI, PostgreSQL, SQLAlchemy, Alembic
- **AI**: OpenAI GPT-4o Vision / DALL-E 3 para geração de looks e análise de imagens
- **Deploy**: Railway (backend), App Store Connect (iOS)
- **Landing**: HTML/CSS/JS estático (Vercel ou GitHub Pages)

## Estrutura de Diretórios

```
voudeque/
├── ios/                    # App iOS SwiftUI
│   └── VouDeQue/
├── backend/                # API FastAPI
│   ├── app/
│   │   ├── api/
│   │   ├── core/
│   │   ├── models/
│   │   ├── schemas/
│   │   └── services/
│   ├── tests/
│   └── alembic/
├── landing/                # Landing page
├── .brain/
└── docs/
```

## Convencoes

- SwiftUI puro, sem Storyboards.
- ViewModels com `@MainActor` e `@Observable` (iOS 17+).
- Backend usa async/await, Pydantic v2, SQLAlchemy 2.0.
- Commits em PT-BR, convencional: `feat:`, `fix:`, `refactor:`.
- Nunca commitar `.env` ou secrets.

## Secrets

- `OPENAI_API_KEY` — backend only, via Railway env var.
- `DATABASE_URL` — PostgreSQL connection string.
- `JWT_SECRET` — autenticação.

## Monetizacao

- Freemium: 3 looks gerados/dia no free.
- Premium: looks ilimitados + desafios exclusivos + IA avancada.
- Preco: R$ 19,90/mes ou R$ 119,90/ano.

## TikTok Strategy

- Hook: "Minha IA me vestiu em 3 segundos"
- Formatos: antes/depois, reacao a look gerado, batalha de estilo com amiga.
- CTA: "Baixa o app e descobre seu look de hoje".
