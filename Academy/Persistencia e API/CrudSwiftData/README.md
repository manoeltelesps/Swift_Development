# 🗃️ CrudSwiftData

O mesmo exercício de CRUD do projeto `CrudCoreData`, mas reescrito com **SwiftData** — o sucessor moderno do Core Data, com sintaxe declarativa via macros.

## 📂 Arquivos
| Arquivo | Descrição |
|---|---|
| `Item.swift` | Modelo `Item` anotado com `@Model`, substituindo a entidade do `.xcdatamodeld` do Core Data por uma struct/classe Swift comum. |
| `ContentView.swift` | Lista os itens com `@Query` (equivalente ao `@FetchRequest`), adiciona itens direto no `modelContext.insert(...)` e apaga com `modelContext.delete(...)` — bem menos boilerplate que a versão Core Data. |
| `EditItemView.swift` | Tela de detalhe/edição de um item existente. |

---
**Autor:** Manoel Teles · [LinkedIn](https://www.linkedin.com/in/manoeltelesps)
