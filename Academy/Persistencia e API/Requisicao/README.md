# 🌐 Requisicao

Estudo de requisições de rede com **URLSession**, seguindo uma organização MVVM simples (`Model` / `View` / `ViewModel`). Busca posts de teste na API pública [jsonplaceholder.typicode.com](https://jsonplaceholder.typicode.com/posts) e lista os títulos na tela.

## 📂 Arquivos
| Arquivo | Descrição |
|---|---|
| `Model/Post.swift` | Struct `Post` (`Codable`, `Identifiable`) que modela a resposta da API. |
| `ViewModel/PostViewModel.swift` | `PostViewModel` (`ObservableObject`) faz a requisição HTTP com `URLSession.shared.dataTask`, decodifica o JSON e publica a lista de posts. |
| `View/ContentView.swift` | Exibe os posts em uma `List`, disparando `fetchPosts()` no `.onAppear`. |

---
**Autor:** Manoel Teles · [LinkedIn](https://www.linkedin.com/in/manoeltelesps)
