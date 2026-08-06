# 🧩 MVPArch

App UIKit para estudar a arquitetura **MVP (Model-View-Presenter)**, buscando uma lista de usuários na API pública [jsonplaceholder.typicode.com](https://jsonplaceholder.typicode.com/users). A pasta `MVP/` separa claramente as três camadas do padrão.

## 📂 Arquivos
| Arquivo | Descrição |
|---|---|
| `MVP/Model/Users.swift` | Struct `User` (`Codable`) que modela os dados vindos da API. |
| `MVP/Presenter/Presenter.swift` | `UserPresenter` faz a requisição HTTP com `URLSession`, decodifica o JSON e repassa o resultado para a View através do protocolo `UserPresenterDelegate` — o Presenter não conhece a View concreta, apenas essa interface. |
| `MVP/Views/UsersViewController.swift` | View responsável por implementar `UserPresenterDelegate` e exibir os usuários recebidos do Presenter. |

> Nota: `UsersViewController.swift` está em desenvolvimento — a declaração da tabela (`tableView`) ainda está incompleta no código atual.

---
**Autor:** Manoel Teles · [LinkedIn](https://www.linkedin.com/in/manoeltelesps)
