# 🔔 Notifications

Estudos do framework **UserNotifications**, cobrindo tanto notificações locais agendadas quanto o registro para push notifications (APNs). Dois mini-projetos SwiftUI separados.

## 📂 Projetos

| Pasta | Descrição |
|---|---|
| `Notify/NotificationsStudies/` | Notificações **locais**: agenda uma notificação em um horário escolhido via `DatePicker`, usando `UNMutableNotificationContent` + `UNCalendarNotificationTrigger`, com botões para agendar e cancelar todas as notificações pendentes. |
| `Pushcation/Pushcation/` | Notificações **push (APNs)**: `CustomAppDelegate` registra o app para receber notificações remotas (`registerForRemoteNotifications`), captura o device token e implementa `UNUserNotificationCenterDelegate` para tratar notificações recebidas em primeiro plano e taps do usuário. |

---
**Autor:** Manoel Teles · [LinkedIn](https://www.linkedin.com/in/manoeltelesps)
