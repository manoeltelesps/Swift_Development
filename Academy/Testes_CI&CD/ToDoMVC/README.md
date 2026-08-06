# ✅ ToDoMVC

Projeto de terceiros ([SwiftUI-TodoMVC](http://todomvc.com/), por **Ryan Ashcraft**, © 2019) usado como base de estudo de testes unitários. O app implementa a especificação clássica do [TodoMVC](http://todomvc.com/) em SwiftUI — criar, completar, filtrar e limpar tarefas.

Minha contribuição foi adicionar testes unitários próprios sobre a `TodoViewModel` já existente no projeto original.

## 📂 Arquivos
| Arquivo | Descrição |
|---|---|
| `TodoMVC/TodoViewModel.swift` | ViewModel original (Ryan Ashcraft) com toda a lógica de tarefas: criar, completar, editar título, remover e limpar concluídas. |
| `TodoMVC/ContentView.swift` | Tela original em SwiftUI, com filtros (todas / ativas / concluídas). |
| `TodoMVCTests/TodoViewModel.swift` | Testes unitários (XCTest) que escrevi cobrindo `createTodo`, incluindo o caso de título vazio. |

Veja também o [README do projeto de terceiros](../README.md) para mais contexto sobre a origem do código.

---
**Autor:** Manoel Teles · [LinkedIn](https://www.linkedin.com/in/manoeltelesps)
