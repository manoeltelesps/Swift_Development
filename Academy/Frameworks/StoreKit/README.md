# 🛒 StoreKit

Estudos do framework **StoreKit** (StoreKit 2), cobrindo tanto compra avulsa (in-app purchase) quanto assinaturas. Dois mini-projetos SwiftUI separados.

## 📂 Projetos

| Pasta | Descrição |
|---|---|
| `AppleWatchBuy/` | Compra avulsa de um produto: busca produtos por ID com `Product.products(for:)` e executa a compra com `product.purchase()`, exibindo o preço e um botão de compra. |
| `Assinaturas/StoreKitEstudo/` | Assinaturas: usa `SubscriptionStoreView` (UI pronta do StoreKit para exibir planos de um grupo de assinatura) e o modificador `.onInAppPurchaseCompletion` para capturar o resultado da compra e guardar os IDs assinados. Inclui uma configuração local (`LocalConfig.storekit`) para testar compras no simulador/Xcode sem depender do App Store Connect. |

---
**Autor:** Manoel Teles · [LinkedIn](https://www.linkedin.com/in/manoeltelesps)
