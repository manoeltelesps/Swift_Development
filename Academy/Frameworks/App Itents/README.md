# ☕️ App Intents — Coffee

Estudo do framework **App Intents**, usado para expor ações do app à Siri, ao app Atalhos e à Spotlight Search. O projeto parte de um app de exemplo de uma cafeteria (baseado em código de exemplo da Apple) e adiciona intents próprias em cima dele.

## 📂 Arquivos
| Arquivo | Descrição |
|---|---|
| `Intents/OpenFavoritesIntents.swift` | `AppIntent` que abre a tela de Favoritos do app (`openAppWhenRun = true`), injetando o `Model` via `@Dependency`. |
| `Intents/ProductDetailIntent.swift` | `AppIntent` que busca o preço de um produto pelo nome sem abrir o app (`openAppWhenRun = false`); usa `@Parameter` e `requestValue` para pedir o nome do produto quando ele não vem preenchido pelo Atalhos/Siri. |
| `Intents/Shortcuts.swift` | `AppShortcutsProvider` que registra as frases de voz (`AppShortcut`) que disparam cada intent. |
| `Models/`, `Views/`, `UIComponents/` | Camadas de dados e interface SwiftUI do app de exemplo da cafeteria (menu, carrinho, favoritos). |

---
**Autor:** Manoel Teles · [LinkedIn](https://www.linkedin.com/in/manoeltelesps)
