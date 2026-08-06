# 🎛️ StudiesUIKit

App de estudos de **UIKit**, navegando entre uma tela baseada em Storyboard e telas construídas por código — inclusive misturando UIKit com SwiftUI via `UIHostingController`. Também serve de base para praticar testes unitários e de UI.

## 📂 Arquivos
| Arquivo | Descrição |
|---|---|
| `ViewController.swift` | Tela inicial (Storyboard), com um contador simples e botões que navegam para as outras duas telas. |
| `SegundaView.swift` | Segunda tela, construída **100% por código** (sem Storyboard/XIB), com `UILabel` e `UIButton` posicionados via `NSLayoutConstraint`, apresentada de forma modal. |
| `TerceiraView.swift` | Terceira tela, escrita em **SwiftUI**, embrulhada em um `UIHostingController` e empurrada na navigation stack do UIKit — demonstra interoperabilidade entre os dois frameworks. |
| `StudiesUIKitTests/` | Alvo de testes unitários (XCTest), ainda com os testes de exemplo do template do Xcode. |
| `StudiesUIKitUITests/` | Alvo de testes de UI (XCUITest), incluindo teste de tempo de lançamento do app. |

---
**Autor:** Manoel Teles · [LinkedIn](https://www.linkedin.com/in/manoeltelesps)
