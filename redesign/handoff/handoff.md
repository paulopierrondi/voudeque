# VouDeQue — Handoff de Design

> Versão: SS 26 · Edição 048 · Maio 2026
> Direção: editorial fashion magazine (Vogue/AnOther) + cor de feed IG/TikTok 2026

---

## 1. Visão geral

Redesign completo da landing page (web) e das telas-chave do app iOS. Direção visual: **revista de moda** — wordmark condensada (Bodoni Moda), folios de página (`VOL. 04 · N.º 048 · MAIO 2026`), drop caps em editorial, créditos de peças no estilo `CAMISA — Linho off-white, ABERTO ATELIER, R$ 320`, ribbon marquee no topo, grid 3×3 estilo feed.

**Cor primária 2026:** cereja `#D1392E` — referência Pantone-adjacent (fashion red). 4 paletas alternativas disponíveis nos Tweaks (Brat, Cobalto, Mocha, Tomate).

---

## 2. Tokens de design

### 2.1 Cores

```
--accent     #D1392E   Cereja (primária)
--bone       #F8F4EC   Fundo claro (Leite)
--paper      #F1ECDF   Fundo de seção alternada
--linen      #E9E2D1   Tom mais profundo p/ placeholders
--ink        #1A1714   Texto principal (preto quente)
--ink-2      #2B2622   Texto secundário
--ash        #6B655B   Texto terciário / eyebrow
--ash-2      #A39C8F   Texto sobre escuro
--rule       rgba(26,23,20,0.16)   Hairlines
--rule-2     rgba(26,23,20,0.07)   Hairlines sutis
```

### 2.2 Paletas alternativas (Tweaks)

| Nome     | Hex        | Uso sugerido               |
| -------- | ---------- | -------------------------- |
| Cereja   | `#D1392E`  | Default · fashion red 2026 |
| Brat     | `#B8D635`  | Editorial jovem · Charli   |
| Cobalto  | `#2746C8`  | Tech-fashion               |
| Mocha    | `#806149`  | Pantone 2025 · neutro      |
| Tomate   | `#E94A3F`  | Coquette · soft femme      |

Fundos: **Leite** `#F8F4EC` · **Marfim** `#F2EEE3` · **Pétala** `#FBEDE9` · **Carvão** `#181513` (dark mode).

### 2.3 Tipografia

| Família           | Uso                                       | Google Fonts |
| ----------------- | ----------------------------------------- | ------------ |
| **Bodoni Moda**   | Display / masthead / dropcap (800 cond.)  | Sim |
| **Instrument Serif** | Editorial body / títulos médios italic | Sim |
| **Geist**         | UI / sans secundário                       | Sim |
| **Geist Mono**    | Eyebrows / folios / labels técnicos        | Sim |

Escala canônica:
```
Masthead     Bodoni Moda 800, fontStretch 75%, letter-spacing -0.04em
Editorial H1 Bodoni Moda 400, 64–152px, line-height 0.86–0.92
Section H2   Bodoni Moda 400, 36–76px
Body         Geist 16px / Instrument Serif 17px italic
Eyebrow      Geist Mono 10–11px, tracking 0.22em, uppercase
```

### 2.4 Espaçamento + ritmo

- Container: `max-width: 1320px`, padding `clamp(20px, 4vw, 56px)`
- Section vertical: `clamp(64px, 9vw, 140px)`
- Rules: hairlines `1px solid rgba(26,23,20,0.16)`
- Sem drop-shadows nos cards (UI flat). Profundidade vem de cor + rule.

### 2.5 Componentes-chave

| Componente | Pattern |
| -- | -- |
| `.btn-ink` | Botão ink → bone, hover vira accent |
| `.eyebrow` | Mono 11px tracked 0.22em uppercase |
| `.figure` | Placeholder editorial listrado com label canto sup. esquerdo |
| `section.flood` | Bloco de cor (accent flood, texto bone) |
| `.ribbon` | Marquee animado 38s no acento |
| `.igrid` | Grid 3×3 alternando accent/ink/bone/figure |
| `.price-grid` | 2 colunas: gratuito (transparente) + assinado (ink) |
| `.faq-row` | Grid 80px / 1fr / 1.6fr — número / pergunta / resposta |

---

## 3. Estrutura da landing

```
01  Topbar (wordmark · nav · pill CTA)
02  Ribbon (marquee acento)
03  Hero               (eyebrow N.º 01 + headline Bodoni + CTA + 4 credit cells)
04  Filosofia          (manifesto 7/5 + 4-col body)
05  Processo           (3 step-rows com nm/h3/desc/meta)
06  Grid IG (3.5)      (3×3 tiles mixed)
07  Telas (flood)      (4 mockups iOS em strip horizontal)
08  Planos             (2 cols: free / Editorial)
09  FAQ                (5 perguntas em grid 80/1fr/1.6fr)
10  Closing (flood)    ("Pronto? Vista." + CTA App Store)
11  Footer             (4 cols: produto / suporte / legal + legal bar)
```

---

## 4. Telas do app iOS

Cada tela é uma "página" de uma edição. Folio comum: `VOL. 04 · N.º 048 · MAIO · 2026`.

### 4.1 Capa (Home — Pág. 003)
- Masthead `VOUDEQUE` condensada centralizada
- Cover story: foto editorial 3:4 + headline italic overlay
- "Nesta edição" — sumário de 4 entradas (P. 008 / 014 / 022 / 034)
- Tab bar: Capa · Briefing · Em pauta · Arquivo (com underline na ativa)

### 4.2 Briefing (Gerar — Pág. 014)
- Header gigante "O **briefing** de hoje." com deck italic
- 3 etapas (01. / 02. / 03.) cada uma com número Bodoni italic 44px
  - 01. Foto (placeholder editorial 4:5 com `+` central)
  - 02. Ocasião (6 chips serif italic; selecionada em ink)
  - 03. Notas (campo editorial entre regras pretas)
- CTA "Fechar a edição" com tempo estimado `≈ 2,8 s`

### 4.3 Editorial (Look — Pág. 022)
- Hero full-bleed dark, foto editorial com headline 64px Bodoni overlay
- Folio dark: `← Capa  ·  EDITORIAL · N.º 048  ·  ↗`
- Body com **drop cap** Bodoni 800 76px no acento
- Painel "Credits" — 4 peças no formato `CAMISA — Linho off-white, manga longa, ABERTO ATELIER, R$ 320`
- CTAs duplos: "Outro" (ghost) · "Guardar no arquivo" (ink)

### 4.4 Em pauta (Feed — Pág. 022)
- Section opener Bodoni "O que veste o **Brasil** esta semana."
- Filtros estilo magazine tabs (italic serif)
- Posts numerados em **algarismo romano** (I. / II. / III…) com:
  - Byline (nome serif + handle/cidade mono)
  - Figura 4:5 com label `LOOK · {nome}` + byline vertical
  - Pull-quote italic
  - Ações: `VOTAR · Compartilhar · Guardar` + `♥ {count}`

---

## 5. Porting para Swift (iOS nativo)

### 5.1 Custom fonts

Adicionar ao `Info.plist`:
```xml
<key>UIAppFonts</key>
<array>
  <string>BodoniModa-VariableFont_opsz,wght.ttf</string>
  <string>BodoniModa-Italic-VariableFont_opsz,wght.ttf</string>
  <string>InstrumentSerif-Regular.ttf</string>
  <string>InstrumentSerif-Italic.ttf</string>
  <string>Geist-VariableFont_wght.ttf</string>
  <string>GeistMono-VariableFont_wght.ttf</string>
</array>
```

### 5.2 Color tokens (Swift)

```swift
extension Color {
    // 2026 — Edição Cereja
    static let vdqAccent  = Color(hex: "#D1392E")
    static let vdqBone    = Color(hex: "#F8F4EC")
    static let vdqPaper   = Color(hex: "#F1ECDF")
    static let vdqLinen   = Color(hex: "#E9E2D1")
    static let vdqInk     = Color(hex: "#1A1714")
    static let vdqInk2    = Color(hex: "#2B2622")
    static let vdqAsh     = Color(hex: "#6B655B")
    static let vdqAsh2    = Color(hex: "#A39C8F")
    static let vdqRule    = Color.vdqInk.opacity(0.16)
}
```

### 5.3 Typography modifiers (substituir os Runway* atuais)

```swift
extension Font {
    // Bodoni Moda (display)
    static func vdqMasthead(_ size: CGFloat) -> Font {
        Font.custom("BodoniModa-Bold", size: size)
            .width(.condensed)
    }
    static func vdqDisplay(_ size: CGFloat, italic: Bool = false) -> Font {
        Font.custom(italic ? "BodoniModa-Italic" : "BodoniModa-Regular", size: size)
    }
    // Instrument Serif (body editorial)
    static func vdqSerif(_ size: CGFloat, italic: Bool = false) -> Font {
        Font.custom(italic ? "InstrumentSerif-Italic" : "InstrumentSerif-Regular", size: size)
    }
    // Geist
    static func vdqSans(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        Font.custom("Geist-Regular", size: size).weight(weight)
    }
    static func vdqMono(_ size: CGFloat) -> Font {
        Font.custom("GeistMono-Regular", size: size)
    }
}

// Eyebrow modifier
extension View {
    func vdqEyebrow() -> some View {
        self.font(.vdqMono(11))
            .kerning(2.4)
            .textCase(.uppercase)
            .foregroundColor(.vdqAsh)
    }
}
```

### 5.4 Componentes a substituir

| Atual (Runway*) | Novo (Vdq*) | Notas |
| -- | -- | -- |
| `Color.runwayBlack` | `Color.vdqInk` | preto → ink quente |
| `Color.fashionGold` | `Color.vdqAccent` | dourado → cereja |
| `Color.fashionChampagne` | `Color.vdqBone` | champagne → bone |
| `Color.goldGradient` | sólida `Color.vdqAccent` ou `Color.vdqInk` | sem gradientes |
| `.runwayCard()` (border-radius 16) | flat surface + hairline 1pt | sem radius nos blocos editoriais |
| `runwayDisplay(_)` | `.vdqDisplay(_)` ou `.vdqMasthead(_)` | escolher por contexto |
| `runwayTitle(_)` | `.vdqSerif(_, italic: true)` p/ títulos médios | preferir italic Bodoni |
| `runwayBody(_)` | `.vdqSans(_)` | corpo neutro |
| `runwayCaption()` | `.vdqEyebrow()` | mono + tracked |
| `runwayTag()` | chip serif italic dentro de border 1pt | sem fill colorido |
| `runwayButton()` | retângulo ink, sem corner-radius (ou 2pt) | flat editorial |

### 5.5 Telas a refatorar

- `HomeView.swift` → estrutura "Capa" (masthead + sumário + cover story)
- `GenerateLookView.swift` → "Briefing" (01/02/03 etapas verticais)
- `LookResultView.swift` → "Editorial" (hero dark + drop cap + credits)
- `FeedView.swift` → "Em pauta" (posts em algarismo romano)
- `OnboardingView.swift` → pode virar "Edição inaugural" — splash com wordmark + ribbon
- `ChallengesView.swift` → "Desafios" pode entrar como aba no Em pauta

### 5.6 Remoções obrigatórias

- Todos os `Color.goldGradient` e gradientes em geral
- `RoundedRectangle(cornerRadius:)` em surfaces editoriais → usar `Rectangle()` + `.border()`
- Stats falsos (`UserStats.sample` com números inflados) → usar dados reais ou esconder card
- Ícones SF Symbols decorativos (`sparkles`, `flame.fill`, `trophy.fill`) → substituir por glyphs serif `I. II. III.` ou letras mono `A / G / C / V`
- Emojis na UI

---

## 6. Copy aprovada (PT-BR)

### Headlines da landing
```
Hero      Estilo, em um gesto.
Filosofia Roupa nunca foi sobre roupa. É sobre presença.
Processo  Três passos. Um look completo.
Grid IG   Um grid, como qualquer outro. Exceto que você é a capa.
Telas     A interface, em quatro atos.
Planos    Comece grátis. Suba quando quiser.
FAQ       O que costumam perguntar.
Closing   Pronto? Vista.
```

### Voice
- Confiante, curta, editorial.
- Itálico Bodoni reservado p/ palavra-chave da frase (a "punchline").
- Mono tracked p/ tudo que é metadata (folio, eyebrow, número de página).
- Evitar: superlativos (incrível, perfeito, revolucionário), buzzwords IA (powered by, alimentado por).

---

## 7. Arquivos

```
redesign/
├── index.html                      ← landing principal
├── screens.jsx                     ← 4 telas iOS (React)
├── tweaks.jsx                      ← painel Tweaks (acento/fundo/blocos)
├── ios-frame.jsx                   ← starter iOS 26 device frame
├── tweaks-panel.jsx                ← starter Tweaks shell
└── handoff/
    ├── handoff.md                  ← este documento
    ├── screens.html                ← grid live das 4 telas isoladas
    ├── 01..10-landing.png          ← prints da landing
    └── screens/01..05-app.png      ← prints das telas iOS
```

---

## 8. Próximos passos sugeridos

1. **Fotos editoriais reais** — trocar `VdqFigure` por `<image-slot>` ou `<img>` com fotos de modelo.
2. **Onboarding e Arquivo** — desenhar as 2 telas restantes nesta linguagem (Onboarding como "Edição inaugural", Arquivo como índice cronológico).
3. **Animações iOS** — transição entre telas com efeito "virar página" (slide horizontal com bone overlay 100ms).
4. **App icon** — wordmark "V" em Bodoni 800 condensada sobre acento cereja; canto vivo, sem rounded extras (iOS aplica máscara automaticamente).
5. **Screenshots App Store** — usar template editorial: foto da tela + headline Bodoni 800 em bone sobre cereja; 1290×2796 para iPhone 6.7".
6. **Web → produção** — landing já é estática, basta drop em Railway (nginx atual serve direto).

---

_Direção: VouDeQue Studio · Maio 2026._
