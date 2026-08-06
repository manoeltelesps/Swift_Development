# 🧪 TodoList-UITests

Projeto de terceiros (por **Nick Sarno**, © 2021) usado como base de estudo de **testes de UI (XCUITest)**. É um app de lista de tarefas simples, persistindo os itens em `UserDefaults`.

Minha contribuição foi escrever os testes de UI sobre o fluxo existente do app.

## 📂 Arquivos
| Arquivo | Descrição |
|---|---|
| `TodoList/ViewModels/ListViewModel.swift` | ViewModel original com o CRUD de tarefas (`getItems`, `addItem`, `updateItem`, `deleteItem`), persistindo em `UserDefaults` via `JSONEncoder`/`JSONDecoder`. |
| `TodoList/Views/` | Telas SwiftUI originais (lista, adicionar item, linha da lista, estado vazio). |
| `TodoListUITests/TodoListUITests.swift` | Testes de UI que escrevi com `XCUIApplication`, cobrindo adicionar tarefa, adicionar e depois apagar, e persistência dos dados entre sessões do app. |

Veja também o [README do projeto de terceiros](../README.md) para mais contexto sobre a origem do código.

---
**Autor:** Manoel Teles · [LinkedIn](https://www.linkedin.com/in/manoeltelesps)
