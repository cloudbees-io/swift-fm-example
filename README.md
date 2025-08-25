# CloudBees Feature Management - Swift Multi-SDK Example

Welcome to the CloudBees Swift Feature Management multi-SDK example project! This README will guide you on how to implement multiple ROX SDK configurations in a single iOS application.

## About This Project

This project demonstrates how to use multiple ROX SDK keys in a single iOS application, allowing you to manage different feature flag configurations independently. This is particularly useful for:

- Managing production and staging environments in the same app
- Supporting multiple teams with separate feature flag dashboards
- Implementing A/B testing with isolated configurations
- Enterprise applications with different feature sets per customer

## Multi-SDK Architecture

The project implements a clean object-based architecture with these key components:

1. **Multiple ROX Instances**: Each with its own SDK key and configuration
2. **Independent Flag Repositories**: Separate flag storage for each configuration
3. **Reactive UI Updates**: Automatic UI refresh when configurations change
4. **Simplified UI Management**: Centralized UI state management

## Key Components

### AppDelegate

The AppDelegate initializes multiple ROX SDK instances with different SDK keys:

```swift
// Create and setup production instance
productionInstance = ROX.instance(withKey: productionSDKKey)
productionInstance?.setup(withOptions: productionOptions)

// Create and setup staging instance
stagingInstance = ROX.instance(withKey: stagingSDKKey)
stagingInstance?.setup(withOptions: stagingOptions)
```

### Flag Containers

Separate flag containers for each configuration:

```swift
// Register Flags1 to production instance
productionInstance?.register(container: Flags1.INSTANCE)

// Register Flags2 to staging instance
stagingInstance?.register("features", container: Flags2.INSTANCE)
```

### UIUpdateManager

A dedicated manager that handles UI updates when configurations change:

```swift
class UIUpdateManager: ObservableObject {
    static let shared = UIUpdateManager()
    
    // Production configuration values
    @Published var productionTitle: String = "Default Text"
    @Published var productionTitleColor: String = "blue"
    // ...
    
    // Staging configuration values
    @Published var stagingTitle: String = "Default Text"
    @Published var stagingTitleColor: String = "red"
    // ...
    
    func updateProductionValues() {
        // Update UI with production flag values
    }
    
    func updateStagingValues() {
        // Update UI with staging flag values
    }
}
```

### Configuration Fetched Callbacks

Each SDK instance has its own configuration fetched callback that updates the UI:

```swift
productionOptions.onConfigurationFetched = { result in
    // Update UI through UIUpdateManager
    UIUpdateManager.shared.updateProductionValues()
}

stagingOptions.onConfigurationFetched = { result in
    // Update UI through UIUpdateManager
    UIUpdateManager.shared.updateStagingValues()
}
```

## Running This Project

To get started with the swift-fm-example project, follow these steps:

1. **Get SDK Keys from CloudBees Account:** 

   - Create a CloudBees Feature Management account. See [Signup Page](https://app.rollout.io/signup) to create an account.
   - Get two environment keys (for production and staging). Copy your environment keys from App settings > Environments > Key.

2. **Clone the Repository:** Clone the swift-fm-example repository to your local machine using Git:

   ```shell
   git clone git@github.com:cloudbees-io/swift-fm-example.git
   ```

3. **Open the Project:** Navigate to the cloned directory and open the swift-fm-example.xcodeproj file using Xcode.

4. **Setup SDK Keys:** 

   - Open AppDelegate.swift and update the SDK keys:
   ```swift
   let productionSDKKey = "your-production-sdk-key"
   let stagingSDKKey = "your-staging-sdk-key"
   ```

5. **Run the App:** 

   - Run the app by selecting Product > Run or by pressing Cmd + R.
   - The app will display feature flags from both configurations in a list view.

## Implementing Multi-SDK in Your Own Project

### 1. Initialize Multiple SDK Instances

```swift
// Production instance
let productionInstance = ROX.instance(withKey: "your-production-sdk-key")
productionInstance?.setup(withOptions: productionOptions)

// Staging instance
let stagingInstance = ROX.instance(withKey: "your-staging-sdk-key")
stagingInstance?.setup(withOptions: stagingOptions)
```

### 2. Create Separate Flag Containers

```swift
// Production flags
public class ProductionFlags : RoxContainer {
    let featureEnabled = RoxFlag(withDefault: true)
    // ...
    static let INSTANCE = ProductionFlags()
}

// Staging flags
public class StagingFlags : RoxContainer {
    let featureEnabled = RoxFlag(withDefault: false)
    // ...
    static let INSTANCE = StagingFlags()
}
```

### 3. Register Containers to Specific Instances

```swift
// Register to production instance
productionInstance?.register(container: ProductionFlags.INSTANCE)

// Register to staging instance
stagingInstance?.register(container: StagingFlags.INSTANCE)
```

### 4. Handle Configuration Updates

```swift
productionOptions.onConfigurationFetched = { result in
    // Handle production configuration updates
}

stagingOptions.onConfigurationFetched = { result in
    // Handle staging configuration updates
}
```

## Best Practices

1. **Namespace Management**: Use clear namespaces when registering containers
2. **UI State Management**: Centralize UI updates through a dedicated manager
3. **Error Handling**: Add proper error handling for configuration fetch failures
4. **Logging**: Implement appropriate logging for debugging
5. **Testing**: Create unit tests for each configuration

## Additional Resources

- [CloudBees Feature Management Documentation](https://docs.cloudbees.com/docs/cloudbees-feature-management/latest/)
- [ROX SDK API Reference](https://docs.cloudbees.com/docs/cloudbees-feature-management/latest/mobile-sdks/ios-sdk)
- [Feature Flag Best Practices](https://docs.cloudbees.com/docs/cloudbees-feature-management/latest/guides/best-practices)
