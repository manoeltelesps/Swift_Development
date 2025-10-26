import AppIntents
import SwiftUI

@main
struct CoffeeApp: App {
    
    @State var model: Model
    
    init() {
        let newModel = Model()
        model = newModel
        
        AppDependencyManager.shared.add(dependency: newModel)
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(model)
        }
    }
}
