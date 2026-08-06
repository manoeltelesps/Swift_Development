# 🧠 FoundationTeste

Estudo do framework **Foundation Models** (iOS 26), que expõe o modelo de linguagem on-device da Apple via `LanguageModelSession`. Apesar do nome da pasta, o foco não é o framework `Foundation` clássico, e sim esse novo LLM local.

## 📂 Arquivos
| Arquivo | Descrição |
|---|---|
| `Teste.swift` | `#Playground` (framework `Playgrounds`) testando uma `LanguageModelSession` com um prompt simples ("crie um roteiro de 3 dias em Paris"). |
| `ContentView.swift` | Tela SwiftUI com um `TextField` para o usuário perguntar algo a uma `LanguageModelSession` configurada com instruções de sistema ("você é um confeiteiro"), exibindo a resposta gerada on-device. |

---
**Autor:** Manoel Teles · [LinkedIn](https://www.linkedin.com/in/manoeltelesps)
