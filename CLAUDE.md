# CLAUDE.md — VouDeQue

## Projeto

VouDeQue — App iOS de moda com IA e componente social.

## Comandos Uteis

```bash
# Backend
cd backend
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload --port 8000

# iOS
cd ios/VouDeQue
open VouDeQue.xcodeproj

# Landing
cd landing
python -m http.server 8080
```

## Decisoes Arquiteturais

- FastAPI async para suportar streaming de respostas da OpenAI.
- Imagens de looks armazenadas no S3/R2 (Cloudflare) com URL assinada.
- iOS usa `URLSession` com `async/await` e cache de imagens via `AsyncImage`.
- Auth com JWT + Apple Sign In.

## Estado Atual

- Scaffolding inicial.
