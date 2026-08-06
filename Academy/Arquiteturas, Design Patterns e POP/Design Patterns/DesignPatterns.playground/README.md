# 🏭 Design Patterns Playground

Playground Swift com exemplos práticos de dois design patterns clássicos: **Factory Method** e **Singleton**. Cada padrão vive em uma página própria do playground.

## 📂 Páginas

| Página | Descrição |
|---|---|
| `FactoryPattern.xcplaygroundpage` | Uma `ComputerFactory` cria instâncias de `Mac`, `iPhone` ou `iPad` (todos conformando ao protocolo `Computer`) a partir do tipo de `OperatingSystem` informado, sem o código cliente precisar conhecer as classes concretas. |
| `Singleton.xcplaygroundpage` | Duas formas de implementar Singleton em Swift: uma classe `Logger` com `static let shared` marcada `nonisolated(unsafe)`, e um `actor Teste` com `static let shared`, comparando a abordagem tradicional com a compatível com Swift Concurrency. |

---
**Autor:** Manoel Teles · [LinkedIn](https://www.linkedin.com/in/manoeltelesps)
