# 🗄️ CrudCoreData

CRUD (criar, listar e apagar) usando **Core Data** integrado a uma View SwiftUI via `@FetchRequest`.

## 📂 Arquivos
| Arquivo | Descrição |
|---|---|
| `Persistence.swift` | Configura o `NSPersistentContainer` (`PersistenceController`), incluindo um container em memória usado nas previews. |
| `ContentView.swift` | Lista os itens salvos com `@FetchRequest`, ordenados por `timestamp`; permite adicionar (`addItem`) e apagar (`deleteItems`) itens, salvando no `viewContext`. |
| `EditItemView.swift` | Tela de detalhe/edição de um item existente. |
| `CrudCoreData.xcdatamodeld` | Modelo de dados Core Data com a entidade `Item`. |

---
**Autor:** Manoel Teles · [LinkedIn](https://www.linkedin.com/in/manoeltelesps)
