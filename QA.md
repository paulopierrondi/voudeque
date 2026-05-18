# VouDeQue — QA Checklist

## Funcionalidades Core

### Onboarding
- [ ] App abre mostrando onboarding na primeira vez
- [ ] 3 telas com swipe ou botão "Próximo"
- [ ] Botão "Começar" na última tela leva ao app
- [ ] Onboarding não aparece novamente após "Começar"

### Autenticação
- [ ] App obtém token JWT anônimo automaticamente
- [ ] Token é válido por 30 dias
- [ ] Requisições autenticadas funcionam

### Home
- [ ] Daily challenge carrega do backend
- [ ] Contador regressivo funciona
- [ ] Stats cards renderizam
- [ ] Botão "Gerar Novo Look" navega para GenerateLookView
- [ ] Card de atividade recente renderiza

### Gerar Look
- [ ] Photo picker abre e permite seleção
- [ ] Chips de ocasião são selecionáveis
- [ ] TextEditor aceita notas de estilo
- [ ] Botão "Gerar Look" chama API com loading state
- [ ] Resultado aparece com itens, descrição, cores
- [ ] Share sheet funciona
- [ ] Save to gallery funciona

### Feed
- [ ] Feed carrega looks do backend
- [ ] Pull-to-refresh funciona
- [ ] Empty state aparece quando vazio
- [ ] Error state aparece em falha
- [ ] Vote button incrementa votos
- [ ] Share button abre share sheet

### Desafios
- [ ] Desafio ativo carrega
- [ ] Ranking mostra top looks
- [ ] Participar funciona

### Perfil
- [ ] Stats do usuário renderizam
- [ ] Menu items são clicáveis
- [ ] **Account Deletion**: Botão excluir → confirmação → conta deletada → volta para onboarding

## Testes de API (Backend)

```bash
cd backend
pytest tests/test_e2e.py -v
```

Endpoints testados:
- POST /api/v1/auth/anonymous
- POST /api/v1/looks/generate
- GET /api/v1/looks/feed
- POST /api/v1/looks/vote
- GET /api/v1/challenges/daily
- DELETE /api/v1/users/me

## Testes de UI (iOS)

```bash
cd ios
xcodebuild test -project VouDeQue.xcodeproj -scheme VouDeQue -destination 'platform=iOS Simulator,name=iPhone 16 Pro'
```

## Performance
- [ ] App inicia em < 3 segundos
- [ ] Generate look responde em < 5 segundos
- [ ] Feed carrega em < 2 segundos
- [ ] Scroll é fluido (60fps)

## Acessibilidade
- [ ] VoiceOver lê todos os elementos
- [ ] Contraste de cores adequado
- [ ] Tamanhos de fonte dinâmicos suportados

## Compatibilidade
- [ ] iOS 18.0+
- [ ] iPhone 14, 15, 16 ( todos os tamanhos)
- [ ] Modo escuro
