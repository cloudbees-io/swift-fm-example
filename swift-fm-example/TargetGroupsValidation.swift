//
//  TargetGroupsValidation.swift
//  swift-fm-example
//
//  Target Groups Validation Tests
//  This file tests different approaches to using target groups with Dynamic API
//

import Foundation
import ROX
import ROXCore

/**
 # Target Groups Validation Tests

 This file validates three different approaches the customer tried:

 1. setGlobalContext + getValue (customer said NOT working)
 2. getValue with context parameter (customer said NOT working)
 3. setCustomProperty + getValue (customer said WORKING)

 ## How to Test:

 1. Create a flag in CloudBees dashboard with target groups:
    - Flag name: "target_group_test_flag"
    - Default value: "default"
    - Create a target group with condition: platformVersion == "18.5"
    - Set value for that target group: "ios_18.5_value"

 2. Call the validation methods in AppDelegate after setup:
    ```swift
    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
        TargetGroupsValidation.validateAllApproaches(with: self.productionInstance)
    }
    ```

 3. Check console output to see which approaches work
 */
class TargetGroupsValidation {

    /**
     Test Scenario 1: Using setGlobalContext + getValue
     Customer reported: NOT WORKING (was using ROX.setGlobalContext instead of instance.setGlobalContext)

     Expected behavior: Should evaluate target groups using the global context

     IMPORTANT: When using multi-instance mode (ROX.instance(withKey:)), you MUST call
     setGlobalContext on the INSTANCE, not on the singleton ROX class!
     */
    static func testGlobalContext(with instance: ROXInstance?) -> String {
        print("\n========================================")
        print("TEST 1: setGlobalContext + getValue")
        print("========================================")

        guard let instance = instance else {
            print("❌ Instance not available")
            return "error"
        }

        // Create context with platformVersion
        guard let context = RoxDynamicPropertyContext(values: ["platformVersion": "18.5" as NSString]) else {
            print("❌ Failed to create context")
            return "error"
        }

        // Set global context ON THE INSTANCE (not ROX singleton!)
        instance.setGlobalContext(context: context)
        print("✅ Set global context with platformVersion: 18.5")

        // Get flag value using Dynamic API WITHOUT passing context
        let dynamicAPI = instance.dynamicAPI()
        let flagValue = dynamicAPI.getValue("target_group_test_flag", withDefault: "default", variations: ["default", "ios_18.5_value"])

        print("📊 Flag value: \(flagValue)")
        print("Expected: 'ios_18.5_value' if target group works")
        print("Actual: '\(flagValue)'")

        if flagValue == "ios_18.5_value" {
            print("✅ WORKING: Global context properly evaluated")
        } else {
            print("❌ NOT WORKING: Expected 'ios_18.5_value', got '\(flagValue)'")
        }

        return flagValue
    }

    /**
     Test Scenario 2: Using getValue with context parameter
     Customer reported: NOT WORKING

     Expected behavior: Should evaluate target groups using the passed context
     */
    static func testContextParameter(with instance: ROXInstance?) -> String {
        print("\n========================================")
        print("TEST 2: getValue with context parameter")
        print("========================================")

        guard let instance = instance else {
            print("❌ Instance not available")
            return "error"
        }

        // Create context with platformVersion
        guard let context = RoxDynamicPropertyContext(values: ["platformVersion": "18.5" as NSString]) else {
            print("❌ Failed to create context")
            return "error"
        }

        print("✅ Created context with platformVersion: 18.5")

        // Get flag value using Dynamic API WITH context parameter
        let dynamicAPI = instance.dynamicAPI()
        let flagValue = dynamicAPI.getValue("target_group_test_flag", withDefault: "default", variations: ["default", "ios_18.5_value"], context: context)

        print("📊 Flag value: \(flagValue)")
        print("Expected: 'ios_18.5_value' if target group works")
        print("Actual: '\(flagValue)'")

        if flagValue == "ios_18.5_value" {
            print("✅ WORKING: Context parameter properly evaluated")
        } else {
            print("❌ NOT WORKING: Expected 'ios_18.5_value', got '\(flagValue)'")
        }

        return flagValue
    }

    /**
     Test Scenario 3: Using setCustomProperty + getValue
     Customer reported: WORKING

     Expected behavior: Should evaluate target groups using the custom property
     */
    static func testCustomProperty(with instance: ROXInstance?) -> String {
        print("\n========================================")
        print("TEST 3: setCustomProperty + getValue")
        print("========================================")

        guard let instance = instance else {
            print("❌ Instance not available")
            return "error"
        }

        // Set custom property
        instance.setCustomProperty(key: "platformVersion", value: "18.5")
        print("✅ Set custom property platformVersion: 18.5")

        // Get flag value using Dynamic API WITHOUT context
        let dynamicAPI = instance.dynamicAPI()
        let flagValue = dynamicAPI.getValue("target_group_test_flag", withDefault: "default", variations: ["default", "ios_18.5_value"])

        print("📊 Flag value: \(flagValue)")
        print("Expected: 'ios_18.5_value' if target group works")
        print("Actual: '\(flagValue)'")

        if flagValue == "ios_18.5_value" {
            print("✅ WORKING: Custom property properly evaluated")
        } else {
            print("❌ NOT WORKING: Expected 'ios_18.5_value', got '\(flagValue)'")
        }

        return flagValue
    }

    /**
     Run all validation tests and provide a summary
     */
    static func validateAllApproaches(with instance: ROXInstance?) {
        print("\n╔════════════════════════════════════════════════════════════════╗")
        print("║          TARGET GROUPS VALIDATION TEST SUITE                   ║")
        print("╚════════════════════════════════════════════════════════════════╝")

        // Run all tests
        let result1 = testGlobalContext(with: instance)
        let result2 = testContextParameter(with: instance)
        let result3 = testCustomProperty(with: instance)

        // Summary
        print("\n╔════════════════════════════════════════════════════════════════╗")
        print("║                      TEST SUMMARY                               ║")
        print("╚════════════════════════════════════════════════════════════════╝")
        print("Test 1 - setGlobalContext + getValue: \(result1 == "ios_18.5_value" ? "✅ PASS" : "❌ FAIL")")
        print("Test 2 - getValue with context param:  \(result2 == "ios_18.5_value" ? "✅ PASS" : "❌ FAIL")")
        print("Test 3 - setCustomProperty + getValue: \(result3 == "ios_18.5_value" ? "✅ PASS" : "❌ FAIL")")

        // Analysis
        print("\n╔════════════════════════════════════════════════════════════════╗")
        print("║                       ANALYSIS                                  ║")
        print("╚════════════════════════════════════════════════════════════════╝")

        if result1 == "ios_18.5_value" && result2 == "ios_18.5_value" && result3 == "ios_18.5_value" {
            print("✅ ALL METHODS WORKING - Target groups are properly evaluated")
            print("   All three approaches work correctly when using instance methods.")
        } else if result3 == "ios_18.5_value" && (result1 != "ios_18.5_value" || result2 != "ios_18.5_value") {
            print("⚠️  PARTIAL WORKING - Only setCustomProperty works")
            print("   This suggests you may be mixing singleton and multi-instance modes.")
            print("   Make sure to call setGlobalContext on the INSTANCE, not ROX class!")
        } else {
            print("❌ NONE WORKING - Target groups evaluation may have issues")
            print("   Check your dashboard configuration and SDK setup.")
        }

        print("\n╔════════════════════════════════════════════════════════════════╗")
        print("║                    DASHBOARD SETUP REMINDER                     ║")
        print("╚════════════════════════════════════════════════════════════════╝")
        print("Ensure you have created in CloudBees Dashboard:")
        print("1. Flag: 'target_group_test_flag'")
        print("2. Target Group condition: platformVersion == \"18.5\"")
        print("3. Value for target group: 'ios_18.5_value'")
        print("4. Default value: 'default'")
        print("\n")
    }

    /**
     Test with different property types
     */
    static func testDifferentPropertyTypes(with instance: ROXInstance?) {
        print("\n╔════════════════════════════════════════════════════════════════╗")
        print("║           TESTING DIFFERENT PROPERTY TYPES                      ║")
        print("╚════════════════════════════════════════════════════════════════╝")

        guard let instance = instance else {
            print("❌ Instance not available")
            return
        }

        // Test 1: String property with setCustomProperty
        print("\n--- Test: String property (setCustomProperty) ---")
        instance.setCustomProperty(key: "appVersion", value: "2.0.0")
        let dynamicAPI = instance.dynamicAPI()
        let result1 = dynamicAPI.getValue("version_test_flag", withDefault: "v1", variations: ["v1", "v2"])
        print("Result: \(result1)")

        // Test 2: String property with context
        print("\n--- Test: String property (context parameter) ---")
        if let context = RoxDynamicPropertyContext(values: ["appVersion": "2.0.0" as NSString]) {
            let result2 = dynamicAPI.getValue("version_test_flag", withDefault: "v1", variations: ["v1", "v2"], context: context)
            print("Result: \(result2)")
        }

        // Test 3: Boolean property with setCustomProperty
        print("\n--- Test: Boolean property (setCustomProperty) ---")
        instance.setCustomProperty(key: "isPremium", value: true)
        let result3 = dynamicAPI.isEnabled("premium_test_flag", withDefault: false)
        print("Result: \(result3)")

        // Test 4: Boolean property with context
        print("\n--- Test: Boolean property (context parameter) ---")
        if let context = RoxDynamicPropertyContext(values: ["isPremium": NSNumber(value: true)]) {
            let result4 = dynamicAPI.isEnabled("premium_test_flag", withDefault: false, context: context)
            print("Result: \(result4)")
        }

        // Test 5: Numeric property with setCustomProperty
        print("\n--- Test: Numeric property (setCustomProperty) ---")
        instance.setCustomProperty(key: "userAge", value: 25)
        let result5 = dynamicAPI.getValue("age_test_flag", withDefault: "young", variations: ["young", "adult", "senior"])
        print("Result: \(result5)")

        // Test 6: Numeric property with context
        print("\n--- Test: Numeric property (context parameter) ---")
        if let context = RoxDynamicPropertyContext(values: ["userAge": NSNumber(value: 25)]) {
            let result6 = dynamicAPI.getValue("age_test_flag", withDefault: "young", variations: ["young", "adult", "senior"], context: context)
            print("Result: \(result6)")
        }
    }
}
