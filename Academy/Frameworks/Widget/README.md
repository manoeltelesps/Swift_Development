# 📱 Widget

Estudo do framework **WidgetKit**: um app anfitrião (`WidgetStudies`) com uma extensão de widget (`WidgetMensal`) instalada nele.

## 📂 Arquivos
| Arquivo | Descrição |
|---|---|
| `WidgetMensal/WidgetMensal.swift` | Define o widget: um `TimelineProvider` que gera entradas de hora em hora (`SimpleEntry` com data e emoji) e uma `WidgetMensalEntryView` que exibe a hora e o emoji atual no widget. |
| `WidgetMensal/WidgetMensalBundle.swift` | Ponto de entrada (`@main`) que registra o widget no `WidgetBundle`. |
| `WidgetStudies/ContentView.swift` | Tela do app anfitrião, ainda no template padrão do Xcode. |

---
**Autor:** Manoel Teles · [LinkedIn](https://www.linkedin.com/in/manoeltelesps)
