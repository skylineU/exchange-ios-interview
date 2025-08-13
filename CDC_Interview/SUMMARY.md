
# Based on the requirements, I have rewritten and improved all functionalities and unit tests. The entire process is as follows:

1. **Architecture & Technology Stack** The demo adopts MVVM architecture, implemented using Swift + SwiftUI + Combine + RxSwift technologies for core functionality.

2. **Singleton Pattern Implementation** Due to the Singleton pattern for Dependency, the init method is set to private to prevent multiple object instances and injection failures.

3. **Protocol-Oriented Service Design**
    Designed FileLoaderType, NetworkServiceType, and SettingsServiceType protocol to standardize service behaviors.

    Service classes (FileLoaderService, NetworkService, SettingsService) adhere to these protocols, reducing coupling by using protocol types for dependencies.

4. **Service Implementation**
    FileLoaderService : Handles file loading and parsing.

    NetworkService : Manages API requests and responses.

    SettingsService : Controls application settings (e.g., supportEUR).

5. **Unified Data Model**
    Created a generic model class for usdPrices.json and allPrices.json(similar structures).

    Dynamically generates usdPrice and eurPrice fields based on the presence of "usd" and "price" keys, facilitating data management.

6. **Componentized UI Design**
    MainView : Organizes components into modular sections: search bar, error page, list view, and price row to avoid clutter.

    SettingsView : Integrates a toggle for supportEUR that updates MainViewModel via environment object, triggering data refresh.

7. **Toggle Binding & Data Refresh Mechanism**
    The Toggle in SettingsViewi bound to the supportEUR property in SettingsService.

    SettingsService is injected as an environment variable into MainView. When supportEUR is toggled, it triggers MainViewModel to re-fetch data, ensuring UI synchronization with the updated configuration.

8. **ViewModel Implementation**
    * MainViewModel :
        Injects NetworkServiceType and SettingsServiceType for testability and decoupling.

        Triggers fetchAllPrices()or fetchUSDPrices()via networkService based on settingsService.supportEUR.

        Uses flatMapLatest to handle search logic: returns all data if searchText is empty, or filtered results otherwise.

        Manages loading states (isLoading) and error scenarios (errorMessage) for UI feedback.

9. **Unit Testing**
    Rewrote unit tests with ​​mocked implementations​​ for FileLoaderService, NetworkService, and SettingsService, supported by a custom TestDataFactory.
    
    Created test classes for Dependency, FileLoaderService, NetworkService, SettingsService, MainViewModel, and data models to validate functionality.