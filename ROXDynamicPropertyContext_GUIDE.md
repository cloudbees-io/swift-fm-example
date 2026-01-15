# ROXDynamicPropertyContext - Complete Usage Guide

## What is ROXDynamicPropertyContext?

`ROXDynamicPropertyContext` is a dictionary-like container that holds key-value pairs which can be:
1. **Passed directly** to flag evaluation methods (per-evaluation context)
2. **Set globally** via `setGlobalContext()` (applies to all evaluations)
3. **Accessed in `dynamicPropertiesRule`** callback for custom property resolution

## Important Understanding

- **ROXDynamicPropertyContext** is for passing **evaluation-time context** to flags
- **setCustomProperty()** is for defining **user/device properties** for target groups
- These serve **different purposes** and can be used together!

---

## Three Ways to Use ROXDynamicPropertyContext

### Method 1: Per-Evaluation Context (Most Flexible)

Pass context directly when evaluating a flag:

```swift
import ROX

// Create context with values
let context = ROXDynamicPropertyContext(values: [
    "userRole": "admin" as NSString,
    "featureAccessLevel": NSNumber(value: 3),
    "experimentGroup": "variantA" as NSString
])

// Pass context to flag evaluation
if Flags1.INSTANCE.showtitle.isEnabled(context) {
    print("Feature enabled for this specific context")
}

// Works with other flag types too
let titleColor = Flags1.INSTANCE.titleColors.value(context)
let titleSize = Flags1.INSTANCE.titleSize.value(context)
```

**Use Case:** When context varies per flag evaluation

---

### Method 2: Global Context (Applies to All Evaluations)

Set a global context that applies to all flag evaluations:

```swift
import ROX

func application(_ application: UIApplication,
                didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    // Set global context BEFORE setup
    let globalContext = ROXDynamicPropertyContext(values: [
        "sessionId": UUID().uuidString as NSString,
        "experimentVariant": "control" as NSString,
        "featureToggle": NSNumber(booleanLiteral: true)
    ])

    ROX.setGlobalContext(context: globalContext)

    // Register and setup
    ROX.register(Flags1.INSTANCE)
    ROX.setup(withKey: "your-sdk-key")

    return true
}

// Later, evaluate flags without passing context explicitly
// They will use the global context automatically
if Flags1.INSTANCE.showtitle.isEnabled {
    print("Global context is used automatically")
}
```

**Use Case:** When same context applies to all flag evaluations

---

### Method 3: Dynamic Properties Rule (Advanced)

Use context in a custom property resolution rule:

```swift
import ROX

func setupWithDynamicPropertiesRule() {
    let options = ROXOptions()

    // This callback is invoked whenever SDK needs to resolve a property
    options.dynamicPropertiesRule = { (propName: String, context: ROXDynamicPropertyContext) -> NSObject? in

        // Access values from context
        let featureLevel = context.get("featureAccessLevel") as? NSNumber
        let experimentGroup = context.get("experimentGroup") as? String

        // Custom logic based on property name
        switch propName {
        case "hasAdminAccess":
            // Check if featureAccessLevel is high enough
            return NSNumber(value: (featureLevel?.intValue ?? 0) >= 3)

        case "showExperimentalFeatures":
            // Return true only for experiment group A
            return NSNumber(value: experimentGroup == "variantA")

        case "customSegment":
            // Complex logic
            if let level = featureLevel?.intValue, level > 5 {
                return "premium" as NSString
            }
            return "standard" as NSString

        default:
            return nil
        }
    }

    // Set global context with values that dynamicPropertiesRule will use
    let globalContext = ROXDynamicPropertyContext(values: [
        "featureAccessLevel": NSNumber(value: 5),
        "experimentGroup": "variantA" as NSString
    ])
    ROX.setGlobalContext(context: globalContext)

    ROX.register(Flags1.INSTANCE)
    ROX.setup(withKey: "your-sdk-key", options: options)
}
```

**Use Case:** Complex property resolution logic that needs context

---

## Combining Global and Local Context

You can use both global and local context together. Local context takes priority:

```swift
// Set global context
let globalContext = ROXDynamicPropertyContext(values: [
    "userRole": "user" as NSString,
    "sessionType": "regular" as NSString
])
ROX.setGlobalContext(context: globalContext)

// Later, pass local context for specific evaluation
let localContext = ROXDynamicPropertyContext(values: [
    "userRole": "admin" as NSString  // Overrides global value
])

// This evaluation uses:
// - userRole: "admin" (from local context)
// - sessionType: "regular" (from global context)
if Flags1.INSTANCE.showtitle.isEnabled(localContext) {
    print("Local context overrides global")
}
```

---

## Real-World Examples

### Example 1: A/B Testing with Context

```swift
class ABTestManager {

    static func setupABTest() {
        // Randomly assign user to A/B test variant
        let variant = Bool.random() ? "variantA" : "variantB"

        let context = ROXDynamicPropertyContext(values: [
            "testVariant": variant as NSString,
            "testId": "checkout_flow_test" as NSString
        ])

        ROX.setGlobalContext(context: context)
    }

    static func evaluateCheckoutFlow() {
        // Global context with testVariant is automatically used
        let checkoutVersion = Flags1.INSTANCE.title.value
        print("Using checkout version: \(checkoutVersion)")
    }
}
```

**CloudBees Console Configuration:**
- Create dynamic property rule that reads `testVariant` from context
- Use it in flag rules: `testVariant == "variantA"`

---

### Example 2: Feature-Specific Context

```swift
class FeatureController {

    func showPaymentOptions() {
        // Create context specific to this feature
        let context = ROXDynamicPropertyContext(values: [
            "paymentMethod": "creditCard" as NSString,
            "transactionAmount": NSNumber(value: 299.99),
            "userTrustScore": NSNumber(value: 85)
        ])

        // Use dynamic API with context
        let dynamicAPI = ROX.dynamicAPI()
        let showAdvancedPayment = dynamicAPI.isEnabled(
            "advancedPaymentOptions",
            withDefault: false,
            context: context
        )

        if showAdvancedPayment {
            displayAdvancedPaymentUI()
        }
    }
}
```

---

### Example 3: Session-Based Context

```swift
class SessionManager {

    var currentSession: UserSession?

    func updateSessionContext() {
        guard let session = currentSession else { return }

        let context = ROXDynamicPropertyContext(values: [
            "sessionId": session.id as NSString,
            "sessionDuration": NSNumber(value: session.durationMinutes),
            "activityLevel": session.activityLevel as NSString,
            "isAuthenticated": NSNumber(booleanLiteral: session.isAuthenticated)
        ])

        // Update global context when session changes
        ROX.setGlobalContext(context: context)

        // Optional: Force config refresh to re-evaluate with new context
        ROX.fetch()
    }
}
```

---

### Example 4: Multi-Instance with Different Contexts

```swift
class MultiInstanceExample {

    func setupProductionAndStaging() {
        // Production instance with production context
        let prodInstance = ROX.instance(withKey: "prod-sdk-key")
        let prodContext = ROXDynamicPropertyContext(values: [
            "environment": "production" as NSString,
            "debugMode": NSNumber(booleanLiteral: false)
        ])

        let prodOptions = ROXOptions()
        prodOptions.dynamicPropertiesRule = { (propName, context) -> NSObject? in
            // Production-specific property resolution
            if propName == "isProduction" {
                return NSNumber(booleanLiteral: true)
            }
            return context.get(propName)
        }

        prodInstance.setup(withOptions: prodOptions)

        // Staging instance with staging context
        let stagingInstance = ROX.instance(withKey: "staging-sdk-key")
        let stagingContext = ROXDynamicPropertyContext(values: [
            "environment": "staging" as NSString,
            "debugMode": NSNumber(booleanLiteral: true)
        ])

        let stagingOptions = ROXOptions()
        stagingOptions.dynamicPropertiesRule = { (propName, context) -> NSObject? in
            // Staging-specific property resolution
            if propName == "isProduction" {
                return NSNumber(booleanLiteral: false)
            }
            return context.get(propName)
        }

        stagingInstance.setup(withOptions: stagingOptions)
    }
}
```

---

## Working with Dynamic Properties Rule

### Complete Example

```swift
import UIKit
import ROX

class AppDelegate: UIApplicationDelegate {

    func application(_ application: UIApplication,
                    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let options = ROXOptions()

        // Setup dynamic properties rule
        options.dynamicPropertiesRule = { (propName: String, context: ROXDynamicPropertyContext) -> NSObject? in

            print("Resolving property: \(propName)")

            // Get values from context
            let userId = context.get("userId") as? String
            let userTier = context.get("userTier") as? String
            let featureLevel = context.get("featureAccessLevel") as? NSNumber

            // Custom property resolution logic
            switch propName {
            case "isPremiumUser":
                return NSNumber(value: userTier == "premium")

            case "hasHighAccess":
                return NSNumber(value: (featureLevel?.intValue ?? 0) >= 5)

            case "userSegment":
                if let tier = userTier {
                    switch tier {
                    case "premium": return "segment_A" as NSString
                    case "basic": return "segment_B" as NSString
                    default: return "segment_C" as NSString
                    }
                }
                return "unknown" as NSString

            case "showBetaFeatures":
                // Combine multiple context values
                let isHighAccess = (featureLevel?.intValue ?? 0) >= 5
                let isPremium = userTier == "premium"
                return NSNumber(value: isHighAccess && isPremium)

            default:
                // Return nil to let SDK use custom properties instead
                return nil
            }
        }

        // Set global context with values
        let globalContext = ROXDynamicPropertyContext(values: [
            "userId": "user_12345" as NSString,
            "userTier": "premium" as NSString,
            "featureAccessLevel": NSNumber(value: 7),
            "sessionType": "mobile" as NSString
        ])
        ROX.setGlobalContext(context: globalContext)

        // Register and setup
        ROX.register(Flags1.INSTANCE)
        ROX.setup(withKey: "your-sdk-key", options: options)

        return true
    }
}
```

**CloudBees Console:**
Now you can use these dynamic properties in target groups:
- `isPremiumUser == true`
- `hasHighAccess == true`
- `userSegment == "segment_A"`
- `showBetaFeatures == true`

---

## Context Merging Behavior

When both global and local contexts are present:

```swift
// Global context
let globalContext = ROXDynamicPropertyContext(values: [
    "userId": "user_123" as NSString,
    "environment": "production" as NSString,
    "featureLevel": NSNumber(value: 3)
])
ROX.setGlobalContext(context: globalContext)

// Local context (passed to flag evaluation)
let localContext = ROXDynamicPropertyContext(values: [
    "featureLevel": NSNumber(value: 5),  // Overrides global
    "tempFlag": "enabled" as NSString     // New property
])

// Merged context will have:
// - userId: "user_123" (from global)
// - environment: "production" (from global)
// - featureLevel: 5 (from local, overrides global)
// - tempFlag: "enabled" (from local)
```

**Priority:** Local Context > Global Context

---

## Key Differences: Context vs Custom Properties

| Feature | `ROXDynamicPropertyContext` | `setCustomProperty()` |
|---------|----------------------------|----------------------|
| **Purpose** | Pass evaluation-time context | Define user/device properties |
| **Scope** | Per-evaluation or global | Always global |
| **Use with Target Groups** | Via `dynamicPropertiesRule` | ✅ Direct usage |
| **Complexity** | More complex | Simple and declarative |
| **Best For** | A/B test variants, experiments | User attributes, device info |
| **Governance** | Harder to audit | Easy to audit |

---

## Recommended Usage Pattern

### Use `setCustomProperty()` for Target Groups (Primary)

```swift
// Simple, declarative, governance-friendly
ROX.setCustomProperty(key: "userId", value: "user_123")
ROX.setCustomProperty(key: "userTier", value: "premium")
ROX.setCustomProperty(key: "region", value: "us-east")
```

**CloudBees Console:** Directly use in target groups
```
userTier == "premium" AND region == "us-east"
```

---

### Use `ROXDynamicPropertyContext` for Special Cases (Secondary)

```swift
// For per-evaluation context or A/B testing
let context = ROXDynamicPropertyContext(values: [
    "testVariant": "variantA" as NSString,
    "experimentId": "exp_001" as NSString
])

if flag.isEnabled(context) {
    // Special behavior for this context
}
```

**CloudBees Console:** Requires `dynamicPropertiesRule` to use in target groups

---

## Summary

### ✅ When to Use ROXDynamicPropertyContext:

1. **A/B Testing** - Different variants need different context
2. **Per-Evaluation Context** - Context changes for each flag check
3. **Experiment Groups** - Temporary test-specific data
4. **Feature-Specific Logic** - Context varies by feature

### ✅ When to Use setCustomProperty():

1. **Target Groups** - User/device properties ← **Recommended**
2. **User Attributes** - userId, userTier, region
3. **Device Info** - platform, osVersion, appVersion
4. **Governance Requirements** - Simple, auditable approach

### ✅ Best Practice:

Use **both together**:
- `setCustomProperty()` for stable user/device properties
- `ROXDynamicPropertyContext` for dynamic experiment/test data

```swift
// Set stable properties
ROX.setCustomProperty(key: "userId", value: "user_123")
ROX.setCustomProperty(key: "userTier", value: "premium")

// Set dynamic context for experiments
let context = ROXDynamicPropertyContext(values: [
    "experimentVariant": "variantA" as NSString
])
ROX.setGlobalContext(context: context)
```

This gives you the best of both worlds! 🎯
