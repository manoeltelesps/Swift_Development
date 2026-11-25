# Spec: app de treino de ritmo de fala (iPhone + Apple Watch)

Documento de especificação para implementação. Estudo de caso.

---

## 1. Objetivo

App que ajuda a pessoa a controlar o ritmo da fala em apresentações e entrevistas.
O iPhone escuta e analisa o áudio em tempo real; quando a pessoa passa do ritmo
confortável dela por tempo suficiente, o Apple Watch dá um toque háptico discreto
no pulso. Ao fim da sessão, o app mostra um relatório do ritmo ao longo do tempo.

**Escopo desta versão: modo ensaio.** Uma pessoa só falando, sozinha, treinando.

---

## 2. Decisões de arquitetura (já tomadas — não reabrir)

Estas decisões saíram de uma análise anterior. Se algo aqui parecer estranho, o
motivo está escrito ao lado. **Não substituir por alternativas "mais óbvias".**

| Decisão | Motivo |
|---|---|
| **Sem frequência cardíaca.** Nenhuma API de HealthKit. | FC exige `HKWorkoutSession` (suja os anéis de atividade, come bateria), tem latência, e não distingue nervosismo de estar em pé falando. |
| **Áudio processado no iPhone, não no Watch.** | Mais CPU, mais bateria, mic melhor. O watchOS suspende app com tela apagada de forma agressiva. |
| **O Watch é canal de saída, não sensor.** Ele só recebe gatilho e vibra. | É a única coisa que o iPhone não faz: háptico privado no pulso. |
| **Métrica interna em sílabas/segundo, não em WPM.** | Sílabas por palavra varia por idioma (PT ≈ 2,2–2,4; EN ≈ 1,4–1,6). Comparando contra a baseline da própria pessoa, o fator some da conta. WPM só aparece na UI. |
| **Sem reconhecimento de fala em tempo real.** | `SFSpeechRecognizer` tem latência de segundos, gasta bateria e pede permissão que assusta. Usado **só** na calibração (Fase 3). |
| **Nada de áudio é gravado ou sai do device.** | Buffers processados e descartados. Persistir só métricas numéricas. |
| **Feedback com histerese e cooldown.** | Vibrar em cada pico transforma o app num gerador de ansiedade. |

### Não-objetivos (não implementar)

- Modo "ao vivo" durante entrevista real
- Separação de locutores / diarização
- Transcrição da sessão
- Detecção de palavras de preenchimento ("tipo", "né", "hum")
- Sincronização em nuvem, contas, login
- Qualquer UI no Watch além de start/stop — a pessoa não pode olhar o pulso

---

## 3. Fases

Cada fase tem um critério de aceite. **Não avançar sem passar no critério.**

### Fase 0 — Harness de validação (fazer primeiro, é a fase mais importante)

Target de linha de comando em macOS (ou test target) que roda o detector em
arquivos de áudio `.wav` do disco e imprime a contagem de sílabas.

- Entrada: pasta `Fixtures/` com arquivos `.wav` (16 kHz, mono) e um `groundtruth.json`
  com a contagem de sílabas real de cada arquivo, contada à mão.
- Saída: por arquivo — sílabas detectadas, esperadas, erro %; e o erro médio absoluto do conjunto.

Isto existe para permitir ajustar os thresholds sem rebuildar app nenhum.

**Critério de aceite:** roda em `swift run` e imprime a tabela de erro.

---

### Fase 1 — Detector de núcleos silábicos

`SpeechRateDetector` puro, sem dependência de UI ou de `AVAudioEngine`.
Entrada: `[Float]` de samples PCM. Saída: índices dos núcleos detectados.

Algoritmo (detalhado na seção 4). Desenvolver inteiramente contra o harness da Fase 0.

**Critério de aceite:** erro médio absoluto abaixo de 10% no conjunto de fixtures,
com pelo menos 5 arquivos de vozes diferentes.

---

### Fase 2 — Captura ao vivo no iPhone

`AVAudioEngine` com tap no input node, downsample para 16 kHz mono, alimentando o
detector da Fase 1 numa janela deslizante.

- Janela de 8 segundos, atualizada a cada 0,5 s
- Publicar taxa de articulação atual via `@Published` / `AsyncStream`
- Tela mínima: número grande ao vivo + botão start/stop

**Critério de aceite:** falando devagar e rápido de propósito, o número na tela
acompanha de forma estável (sem tremer freneticamente).

---

### Fase 3 — Calibração

Tela de setup no iPhone. A pessoa lê em voz alta um texto de contagem silábica
conhecida (embutir no app um texto em PT-BR com a contagem já feita).

Duas saídas:
1. **Baseline pessoal** — a taxa de articulação confortável dessa pessoa, em síl/s.
2. **Ajuste de thresholds** — comparar a contagem detectada com o gabarito e ajustar
   `valleyDepthDB` e o piso de ruído até bater. Uma calibração por usuário, na voz
   dele, no ambiente dele.

Opcionalmente usar `SFSpeechRecognizer` on-device aqui para conferir se a pessoa leu
o texto certo. Só aqui, nunca em tempo real.

**Critério de aceite:** duas pessoas diferentes calibram e recebem baselines
diferentes e plausíveis (faixa típica: 4–7 síl/s).

---

### Fase 4 — Lógica de alerta

```
teto = baseline * 1.15   (ajustável pelo usuário)

se taxa_atual > teto de forma contínua por >= 8 s
   e passaram >= 40 s desde o último alerta
   → dispara alerta
```

O gatilho é sobre a **taxa de articulação** (sílabas / tempo falando), não sobre a
taxa bruta. Uma pessoa que pausa muito tem taxa bruta baixa e articulação alta.

**Critério de aceite:** falar rápido de propósito por 10 s dispara exatamente um
alerta; picos de 2–3 s não disparam nada.

---

### Fase 5 — Watch como saída

App watchOS mínimo + `WatchConnectivity`.

- iPhone envia mensagem de gatilho → Watch chama `WKInterfaceDevice.current().play(.notification)`
- **Um único padrão háptico.** Sob pressão ninguém distingue dois padrões.
- Tela do Watch: só um botão start/stop e um indicador de "sessão ativa"
- Se o Watch não estiver alcançável, degradar em silêncio (sessão continua, só sem háptico)

**Critério de aceite:** com o iPhone na mesa e o Watch no pulso, o toque chega em
menos de 1 s do gatilho.

---

### Fase 6 — Relatório pós-sessão

Provavelmente a parte de mais valor do app, e não exige nenhum acerto em tempo real.

- Gráfico de linha: taxa de articulação ao longo da sessão, com a linha da baseline
- Marcadores nos pontos de alerta
- Números: duração, taxa média, **densidade de pausas** (% do tempo em silêncio),
  número de alertas
- Persistir sessões localmente com SwiftData

**Densidade de pausas merece destaque na UI.** Pessoa nervosa para de pausar — emenda
tudo. Às vezes o problema real não é velocidade, é ausência de respiro.

---

## 4. Especificação do algoritmo

### Detecção de núcleos silábicos

Sílaba é um pico de energia na fala. Não é preciso saber *o que* foi dito.

1. Áudio mono 16 kHz
2. Frames de 10 ms, calcular RMS por frame, converter para dB
3. Suavizar o envelope com média móvel de ~50 ms (mata a oscilação interna da sílaba)
4. Piso de ruído adaptativo: mediana móvel dos frames abaixo do percentil 20
5. Selecionar máximos locais que passem em três filtros:
   - **acima de** `noiseFloor + 6 dB`
   - **vale de pelo menos 3 dB** entre picos vizinhos ← parâmetro mais crítico; é o que
     impede contar uma sílaba duas vezes
   - **distância mínima de 100 ms** entre picos (>10 síl/s é fisiologicamente impossível)
6. Checagem de vozeamento: núcleo silábico é vozeado. Proxy barato = zero-crossing rate
   baixo + energia alta. Filtra papel amassando, tosse, batida na mesa.

```swift
var nuclei: [Int] = []
for i in 1..<(env.count - 1) {
    guard env[i] > env[i-1], env[i] >= env[i+1] else { continue }
    guard env[i] > noiseFloor + minPeakAboveFloorDB else { continue }
    if let last = nuclei.last {
        guard (i - last) * frameMs >= minPeakDistanceMs else { continue }
        let valley = env[last...i].min() ?? env[i]
        guard min(env[last], env[i]) - valley >= valleyDepthDB else { continue }
    }
    nuclei.append(i)
}
```

### VAD e as duas métricas

VAD simples por energia (frame acima do piso de ruído + histerese de ~200 ms para não
picotar). Com ele:

- **Taxa de articulação** = núcleos / tempo falando → é isto que "falar rápido" significa
- **Densidade de pausas** = tempo em silêncio / tempo total

### Conversão para WPM (apenas na UI)

```
wpm = sílabas_por_segundo * 60 / sílabasPorPalavra
```
`sílabasPorPalavra` = 2.3 para PT-BR, 1.5 para EN. Nunca usar na lógica de decisão.

---

## 5. Parâmetros

Todos num único struct `DetectorConfig`, com defaults, editáveis pelo harness da Fase 0:

| Parâmetro | Default |
|---|---|
| `frameMs` | 10 |
| `smoothingMs` | 50 |
| `valleyDepthDB` | 3.0 |
| `minPeakAboveFloorDB` | 6.0 |
| `minPeakDistanceMs` | 100 |
| `analysisWindowSec` | 8.0 |
| `sustainedBreachSec` | 8.0 |
| `alertCooldownSec` | 40.0 |
| `ceilingMultiplier` | 1.15 |
| `syllablesPerWord` | 2.3 |

---

## 6. Privacidade

- `NSMicrophoneUsageDescription` explicando que o áudio não é gravado nem enviado
- Nenhum `AVAudioFile`, nenhum buffer persistido em disco
- Persistir apenas: timestamps, taxas, contagens
- Sem rede. Sem analytics de áudio.

---

## 7. Estrutura sugerida

```
SpeechPace/
├── Core/                        ← sem dependência de UI, testável
│   ├── SpeechRateDetector.swift
│   ├── EnvelopeExtractor.swift
│   ├── VoiceActivityDetector.swift
│   ├── AlertPolicy.swift
│   └── DetectorConfig.swift
├── iOS/
│   ├── AudioCaptureService.swift
│   ├── SessionViewModel.swift
│   ├── CalibrationView.swift
│   ├── SessionView.swift
│   └── ReportView.swift
├── Watch/
│   ├── HapticService.swift
│   └── SessionView.swift
├── Shared/
│   └── WatchBridge.swift
└── Tools/
    └── ValidationHarness/       ← Fase 0
```

`Core/` não importa SwiftUI, AVFoundation nem WatchConnectivity. É o que permite a
Fase 0 existir.

---

## 8. Ordem de execução

Fase 0 → 1 → 2 → 4 → 5 → 3 → 6

A Fase 3 (calibração) vem depois da 5 de propósito: dá para testar o loop completo com
uma baseline chutada (5.5 síl/s) e só depois construir a calibração de verdade. Assim o
sistema fica end-to-end mais cedo.
