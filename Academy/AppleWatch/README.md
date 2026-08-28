# Apple Watch Studies

Este repositório reúne projetos simples de estudo para **watchOS**, focados em explorar frameworks nativos da Apple direto no relógio.

---

## 📁 Projeto 1 — WorkoutTest

### Sobre
Estudo básico de **`HKWorkoutSession`** e **`HKLiveWorkoutBuilder`**. O app inicia e encerra uma sessão de treino e exibe a frequência cardíaca em tempo real durante o exercício.

### Principais componentes
- `WorkoutManager.swift` — gerencia a sessão de treino (start/stop) e coleta os dados de frequência cardíaca via delegate.
- `ContentView.swift` — interface simples com o bpm atual e um botão para iniciar/parar o treino.

### Frameworks
- `HealthKit`
- `SwiftUI`

---

## 📁 Projeto 2 — HealthTest

### Sobre
Estudo básico de leitura de dados do **HealthKit**. O app solicita autorização e busca a contagem de passos do dia atual.

### Principais componentes
- `HealthKitManager.swift` — solicita autorização de leitura e consulta os passos do dia via `HKStatisticsQuery`.
- `ContentView.swift` — exibe a contagem de passos com um botão para atualizar.

### Frameworks
- `HealthKit`
- `SwiftUI`

---

## 🛠 Stack

- **Linguagem:** Swift
- **UI:** SwiftUI
- **Plataforma:** watchOS
- **IDE:** Xcode

## ⚙️ Configuração necessária

Ambos os projetos exigem a capability **HealthKit** habilitada no target *Watch App* (Signing & Capabilities), além das descrições de uso já configuradas no Info.plist (`NSHealthShareUsageDescription`, `NSHealthUpdateUsageDescription` e, no caso do WorkoutTest, o background mode `workout-processing`).

## ⚠️ Aviso

Projetos criados exclusivamente para fins de estudo pessoal de watchOS e HealthKit.
