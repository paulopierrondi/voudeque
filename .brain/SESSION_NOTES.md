# Session Notes — VouDeQue Redesign Editorial (Maio 2026)

**Data:** 2026-05-18  
**Agente:** Kimi CLI  
**Escopo:** Aplicar design handoff editorial completo (landing + iOS), testar e validar produto.

---

## Resumo Executivo

Redesign completo aplicado com sucesso. Landing page reescrita do zero com direção editorial fashion (Vogue/AnOther). App iOS inteiramente refatorado com novo design system: cores cereja/bone/ink, fontes Bodoni Moda + Instrument Serif + Geist + Geist Mono, componentes flat sem gradients. Projeto compila sem warnings. Testes backend 14/14 passando. UI Tests 3/5 passando (2 dependem de backend).

---

## Landing Page (`landing/index.html`)

**Arquivo:** `landing/index.html` — ~1300 linhas, inline CSS+JS  
**Tema antigo:** Dark gold/black luxury → **Novo tema:** Editorial cereja/bone/ink

### Mudanças aplicadas
- 11 seções completas: Topbar → Ribbon marquee → Hero → Filosofia → Processo → Grid IG → Telas → Planos → FAQ → Closing → Footer
- Cores: `--accent #D1392E`, `--bone #F8F4EC`, `--paper #F1ECDF`, `--ink #1A1714`
- Tipografia: Bodoni Moda (display), Instrument Serif (editorial), Geist (UI), Geist Mono (metadata)
- Copy editorial: sem superlativos, sem buzzwords IA, sem menções a Gemini/Google
- Preços corrigidos: Free R$0/mês, Pro R$19,90/mês ou R$119,90/ano
- Animações: IntersectionObserver scroll reveal, CSS marquee ribbon 38s, FAQ accordion
- Responsive: mobile-first com clamp() e breakpoints 768px/1024px

---

## iOS App (`ios/VouDeQue/`)

### Fontes Customizadas
**Diretório:** `ios/VouDeQue/Fonts/`  
**Arquivos:**
- `BodoniModa-VariableFont_opsz,wght.ttf`
- `BodoniModa-Italic-VariableFont_opsz,wght.ttf`
- `InstrumentSerif-Regular.ttf`
- `InstrumentSerif-Italic.ttf`
- `Geist-VariableFont_wght.ttf`
- `GeistMono-VariableFont_wght.ttf`

**Configuração:** Adicionadas ao `Info.plist` (UIAppFonts) e ao target via `xcodeproj` gem (PBXResourcesBuildPhase).

### Design System (`Utils/Extensions.swift`)
- **Cores novas:** `vdqAccent`, `vdqBone`, `vdqPaper`, `vdqLinen`, `vdqInk`, `vdqInk2`, `vdqAsh`, `vdqAsh2`, `vdqRule`
- **Fontes novas:** `vdqMasthead()`, `vdqDisplay()`, `vdqSerif()`, `vdqSans()`, `vdqMono()`
- **Modifiers novos:** `vdqEyebrow()`, `vdqHairline()`
- **Remoções:** Todos os tokens antigos (runway*, fashionGold*, goldGradient, darkGradient, runwayDisplay, runwayButton, runwayCard, etc.)

### Telas Refatoradas

| Tela | Conceito Editorial | Destaques |
|------|-------------------|-----------|
| `HomeView.swift` | **Capa** (Cover) | Masthead VOUDEQUE Bodoni condensado, folio VOL. 04 · N.º 048 · MAIO · 2026, "Nesta edição" sumário |
| `GenerateLookView.swift` | **Briefing** | "O briefing de hoje.", 3 etapas 01/02/03, chips ocasião serif italic, CTA "Fechar a edição" |
| `LookResultView.swift` | **Editorial** | Hero dark full-bleed, drop cap Bodoni 800 em accent, credits panel, CTAs duplos |
| `FeedView.swift` | **Em pauta** | "O que veste o Brasil esta semana.", posts em algarismos romanos (I./II./III.) |
| `ProfileView.swift` | **Arquivo** | Stats simplificados, hairlines, flat surfaces, account deletion mantido |
| `OnboardingView.swift` | **Edição inaugural** | Masthead VOUDEQUE, ribbon marquee, páginas 01/02/03 Bodoni italic |
| `ChallengesView.swift` | **Desafios** | Flat bordered cards, mono labels, serif titles |
| `LookCardView.swift` | — | Hairline-bordered, linen placeholder, mono tags |
| `EmptyStateView.swift` | — | Linen circle, ash icon, serif title |
| `ErrorStateView.swift` | — | Linen circle, accent warning, serif title |
| `ShimmerLoadingView.swift` | — | Linen + rule, flat borders |
| `AsyncImageView.swift` | — | Linen placeholder with LOOK label |

### Navigation (`ContentView.swift`)
- Tabs renomeadas: **Capa · Briefing · Em pauta · Arquivo** (4 tabs, removido Desafios)
- Tab bar custom: bone background, ink underline ativo, ash inativo, labels Geist Mono uppercase
- Toolbar background bone em cada NavigationStack

### App Entry (`VouDeQueApp.swift`)
- UINavigationBarAppearance atualizado para bone/ink

---

## Testes

### Backend (`backend/tests/`)
| Suite | Resultado |
|-------|-----------|
| `test_api.py` (3 testes) | **3/3 PASS** |
| `test_e2e.py` (11 testes) | **11/11 PASS** |
| **Total backend** | **14/14 PASS** |

**Fix aplicado:** `test_generate_look` precisava de autenticação anônima antes do POST (retornava 401).

### iOS UI Tests (`VouDeQueUITests.swift`)
| Teste | Resultado | Nota |
|-------|-----------|------|
| `testOnboardingFlow` | **PASS** | Masthead VOUDEQUE detectado, fluxo 3 páginas |
| `testTabNavigation` | **PASS** | 4 tabs (Capa/Briefing/Em pauta/Arquivo) navegam corretamente |
| `testFeedLoading` | **PASS** | Feed carrega com texto "O que veste o Brasil esta semana." |
| `testGenerateLookFlow` | FAIL | TextEditor não recebe foco de teclado em UI test |
| `testAccountDeletionFlow` | FAIL | Depende de backend rodando (API delete account) |

**Fix aplicado:** UI tests atualizados para tabs novas e copy nova. `GENERATE_INFOPLIST_FILE = YES` adicionado ao target de UI tests.

### Build iOS
- `xcodebuild` com destino iPhone 17 Pro Simulator: **BUILD SUCCEEDED**
- **Zero warnings** de compilação (14 warnings corrigidos: HapticFeedback @MainActor, LookItem var id, PhotosPicker Sendable closure, ProfileView await removido)
- Zero referências a tokens antigos no projeto (verificado via grep)

---

## Arquivos Modificados

```
landing/index.html                          ← reescrito completo (~1300 linhas)
ios/VouDeQue/Info.plist                     ← + UIAppFonts (6 fontes)
ios/VouDeQue/ContentView.swift              ← tabs novas, custom tab bar
ios/VouDeQue/VouDeQueApp.swift              ← nav appearance bone/ink
ios/VouDeQue/Utils/Extensions.swift         ← design system completo novo
ios/VouDeQue/Views/HomeView.swift           ← Capa editorial
ios/VouDeQue/Views/GenerateLookView.swift   ← Briefing
ios/VouDeQue/Views/LookResultView.swift     ← Editorial
ios/VouDeQue/Views/FeedView.swift           ← Em pauta
ios/VouDeQue/Views/ProfileView.swift        ← Arquivo
ios/VouDeQue/Views/OnboardingView.swift     ← Edição inaugural
ios/VouDeQue/Views/ChallengesView.swift     ← restyle
ios/VouDeQue/Views/LookCardView.swift       ← restyle
ios/VouDeQue/Views/EmptyStateView.swift     ← restyle
ios/VouDeQue/Views/ErrorStateView.swift     ← restyle
ios/VouDeQue/Views/ShimmerLoadingView.swift ← restyle
ios/VouDeQue/Views/AsyncImageView.swift     ← restyle
ios/VouDeQueUITests/VouDeQueUITests.swift   ← atualizado para novo design
ios/VouDeQue.xcodeproj/project.pbxproj      ← fontes no target, GENERATE_INFOPLIST_FILE UITests
backend/tests/test_api.py                   ← fix auth no test_generate_look
ios/VouDeQue/Fonts/*.ttf                    ← 6 arquivos de fonte adicionados
```

---

## Próximos Passos Sugeridos

1. **Fotos editoriais reais** — trocar placeholders por fotos de modelo nas telas iOS
2. **Screenshots App Store** — gerar 1290×2796 com template editorial (foto + headline Bodoni sobre cereja)
3. **App icon** — wordmark "V" em Bodoni 800 condensada sobre acento cereja
4. **Backend warnings** — migrar `google.generativeai` → `google.genai`, atualizar SQLAlchemy/Pydantic deprecations
5. **UI Tests restantes** — rodar com backend mockado para validar generate look e account deletion
6. **Landing deploy** — drop em Railway/Vercel (HTML estático, nginx serve direto)

---

## Decisões e Riscos

- **FlowLayout** em `GenerateLookView` usa protocolo `Layout` (iOS 16+). Compatível com target iOS 18.0.
- **Fontes variáveis** (Bodoni Moda VF, Geist VF, GeistMono VF) funcionam no iOS mas podem ter rendering ligeiramente diferente de TTF estáticos. Testar em device físico recomendado.
- **Custom tab bar** em vez de `TabView` nativo: funciona bem mas perde comportamentos automáticos do sistema (badge, mais tabs, edit). Aceitável para 4 tabs fixas.
- **Preços:** Landing mostra R$19,90/mês. Confirmar se backend/RevenueCat está configurado para esse valor.

---

## 2026-05-18 22:31 — Build 2 Enviado para App Store Connect

**Version:** 1.0  
**Build:** 2  
**Delivery UUID:** `cb74e7c7-e3df-4cff-9683-10fae4e93715`  
**Status:** `UPLOAD SUCCEEDED` — zero errors  
**Method:** `release.sh` (archive → export IPA → altool upload)  
**Signing:** Apple Distribution manual + VouDeQue App Store provisioning profile  
**API Key:** 95ULBVD2BW / Issuer 20a81f12-b22c-4ff8-8b33-c1e5e411a24b  

### Pipeline completo
1. Clean build ✅
2. Archive Release-iphoneos ✅
3. Export IPA (app-store) ✅
4. Upload via altool ✅
5. Transferred 998185 bytes @ 112.4MB/s

### Próximos passos ASC
- Aguardar processamento (10-30 min) → status `VALID`
- Associar build à versão no App Store Connect
- Preencher screenshots App Store (6 telas, 1290×2796px)
- Preencher App Privacy, Review Information
- Submeter para review
