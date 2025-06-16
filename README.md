
# Example Swift iOS application for CloudBees platform Feature management
Use this example application to integrate with the CloudBees platform and test feature management. After integrating, watch the application display change in response to any updates you make to flag values in the platform.

In the example Swift application, the ROX SDK is already set up, and feature flags are already coded in.

## Running This Project
To get started with the swift-fm-example project, follow these steps:

1. **Get the SDK key:** 
    - Create a CloudBees Feature management account. See [Signup Page](https://app.rollout.io/signup) to create an account.
 - Locate and copy your SDK key:
          -- Navigate to Feature management > Flags.
          -- Select an application.
          -- Select the copy button next to the SDK key on the page.
      -- If the SDK has not been installed: 
         -- Navigate to Feature management > Flags.
         -- Select the Installation instruction buttons on the top right-hand side of the page.
         -- The UI guides you through creating an environment, linking the environment to an application, and installing the SDK.

2. **Clone the Repository:** 
Clone the swift-fm-example repository to your local machine using Git:

```shell
git@github.com:cloudbees-io/swift-fm-example.git
```
3. **Install ROX dependency via pod:**
   - Install CocoaPods as described in [CocoaPods Getting Started](https://guides.cocoapods.org/using/getting-started.html#getting-started).
   - In a Terminal window, `cd` to your project directory and type `pod install`.

4. **Open the Project:**
 
    - Reopen your project in Xcode using the new `.xcworkspace` file.

5. **Setup the SDK key:** 

    - In the ConfigurationManager.swift file, replace the `<Your Cloudbees Environment API Key>` with your corresponding SDK key:
   
    ```
        ROX.setup(withKey: "<Your Cloudbees Environment API Key>", options: options)
    ```

6. **Run the swift-fm-example App:** 

    - Use Xcode to run the swift-fm-example app by selecting Product > Run or pressing `Cmd + R`. This will launch the app.

## Use the platform to update flag values

Now that your application is running, go to your environment in Feature management to display the flags available in the example application:

Table 1. Feature flags in the example application.

| Flag name           | Flag type  | Description                    |
|---------------------|------------|--------------------------------|
| `showMessage`| Boolean | Turns the message show or hide |
| `message`| String | Sets the Message string.|
| `fontColor`| String | Sets the font color. The flag value has the following variations: red, green, yellow, or blue.|
| `fontSize` | Int32   | Sets the font size in pixels. The flag value has the following variations: 12, 14, or 18.|
| `specialNumber` | Double   | Sets the number with double. The flag value has the following variations: 2.72, 0.577, 3.14|

**To update flags in the platform UI:** 

1. Select **Feature management** from the left pane.
2. Select the application.
3. Select the vertical ellipsis next to the flag you want to configure.
4. Select **Configure**.
5. Select the **Environment** for the SDK key.
6. Update a flag value and save your changes.
7. Set the **Configuration status** to **On**.

## Video Preview

[![Video Preview](assets/fm-ios-thumb.jpg)](assets/fm-screen-rec.mov)
