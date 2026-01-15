# CloudBees iOS SDK - Target Groups Support

The CloudBees iOS SDK **fully supports target groups** using `setCustomProperty()` methods. You do **NOT** need to use `ROXDynamicPropertyContext` for target groups.

---

## Recommended Solution: `setCustomProperty()`

### Method 1: Static Properties (Best for Target Groups)

```swift
// Set custom properties BEFORE calling setup()
// These properties will be available in CloudBees console target group conditions

// String properties
ROX.setCustomProperty(key: "userId", value: "user_12345")
ROX.setCustomProperty(key: "userTier", value: "premium")
ROX.setCustomProperty(key: "region", value: "us-east")

// Boolean properties
ROX.setCustomProperty(key: "isPremiumUser", value: true)

// Numeric properties
ROX.setCustomProperty(key: "accountAge", value: Int32(90))
ROX.setCustomProperty(key: "accountBalance", value: 5000.50)

// Setup SDK
ROX.setup(withKey: "your-sdk-key")
```

**In CloudBees Console**, create target groups using these properties:
- `userTier == "premium"`
- `isPremiumUser == true`
- `accountAge > 30`
- `accountBalance > 1000`
- `region IN ["us-east", "us-west"]`

---

### Method 2: Dynamic Properties (For Changing Values)

```swift
// For values that change during app lifecycle
// These closures are evaluated every time a flag is checked

ROX.setCustomProperty(key: "currentUserId") {
    return UserSession.currentUserId ?? "anonymous"
}

ROX.setCustomProperty(key: "currentUserRole") {
    return UserSession.currentRole ?? "guest"
}

ROX.setCustomProperty(key: "hasActiveSubscription") {
    return UserSession.hasSubscription
}

ROX.setCustomProperty(key: "cartTotal") {
    return CartManager.shared.totalValue
}

ROX.setup(withKey: "your-sdk-key")
```

**Benefits:**
- No need to manually update properties when user state changes
- Properties are re-evaluated automatically on each flag check
- Clean separation of concerns

---

### Method 3: Instance-Specific Properties (Multi-SDK)

```swift
// For managing multiple SDK instances with different properties

let prodInstance = ROX.instance(withKey: "prod-sdk-key")
prodInstance.setCustomProperty(key: "environment", value: "production")
prodInstance.setCustomProperty(key: "userId", value: "user_123")
prodInstance.setCustomProperty(key: "userTier", value: "premium")

let stagingInstance = ROX.instance(withKey: "staging-sdk-key")
stagingInstance.setCustomProperty(key: "environment", value: "staging")
stagingInstance.setCustomProperty(key: "userId", value: "user_123")
stagingInstance.setCustomProperty(key: "userTier", value: "basic")

prodInstance.setup(withOptions: options)
stagingInstance.setup(withOptions: options)
```


## CloudBees Console Target Group Examples

Once you set custom properties in your app, create target groups in the CloudBees console:

### Example 1: Premium Users
```
userTier == "premium" AND accountBalance > 1000
```

### Example 2: Regional Targeting
```
region IN ["us-east", "us-west", "eu-west"]
```

### Example 3: Version-Based Rollout
```
appVersion >= "2.0.0" AND platform == "iOS"
```

### Example 4: User Segmentation
```
accountBalance > 5000 OR userTier == "enterprise"
```

### Example 5: New User Onboarding
```
accountAge < 30 AND userId != "anonymous"
```

The SDK automatically evaluates these conditions using the properties you set via `setCustomProperty()`.

---

## Key Differences: setCustomProperty vs setGlobalContext

| Feature | `setCustomProperty()` | `setGlobalContext()` |
|---------|----------------------|---------------------|
| **Purpose** | Define properties for target groups | Pass flag-specific context |
| **Target Groups** | ✅ Works directly in console | ❌ Requires additional setup |
| **Governance** | ✅ Simple, auditable | ⚠️ More complex |
| **Use Case** | User/device attributes | A/B test variants, experiments |
| **Recommendation** | ✅ **USE THIS** | Use only for advanced scenarios |

---

