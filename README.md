
# Example Swift iOS application for CloudBees platform Feature management
Use this example application to integrate with the CloudBees platform and test feature management. After integrating, observe the application display change in response to any updates you make to flag values in the platform.

In the example swift application, the ROX SDK is already set up, and feature flags are already coded in.

## Get started with this project
To get started with the swift-fm-example project, follow these steps:

1. **Clone the Repository:**   
Clone the swift-fm-example repository to your local machine using Git:  

```shell
git@github.com:cloudbees-io/swift-fm-example.git
```
2. **Open the Project:**

    - Reopen your project in Android Studio.  

3. **Get the SDK key:**  
    - Create a CloudBees feature management account. Refer to [Signup Page](https://cloudbees.io/signup) to create an account.  
    - Locate and copy your SDK key:    
          -- Navigate to **Feature management > Flags**.      
          -- Select an application.      
          -- Select the **copy** button next to the SDK key on the page.    
    - If you do not see an SDK key:      
          -- Navigate to **Feature management > Flags**.    
          -- Select **Installation instructions** in the upper right corner.    
          -- Follow the installation instructions.    
          -- Close the installation instructions, you may now copy the SDK Key.    

4. **Add the SDK key:** 

    - In the ConfigurationManager.swift file, replace the `<Your Cloudbees SDK Key>` with your corresponding SDK key:
   
    ```
        ROX.setup(withKey: "<Your Cloudbees SDK Key>", options: options)
    ```

5. **Run the swift-fm-example App:** 

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

## Documentation reference  

Refer to the CloudBees cloud-native platform documentation, link:https://docs.cloudbees.com/docs/cloudbees-platform/latest/install-sdk/[install the Feature management SDK] for more information.  



