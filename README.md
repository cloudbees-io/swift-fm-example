
# swift-fm-example
Welcome to the cloudbees swift Feature Management example project! This README will guide you on how to setup our ROX (swift sdk for FM) to any swift project.


## Running This Project
To get started with the swift-fm-example project, follow these steps:

1. **Get key from Cloudbees account:** 

    - Create a CloudBees Feature Management account. See [Signup Page](https://app.rollout.io/signup) to create an account.
    - Get your environment key. Copy your environment key from App settings > Environments > Key.

2. **Clone the Repository:** Clone the swift-fm-example repository to your local machine using Git:

```shell
git@github.com:cloudbees-io/swift-fm-example.git
```
3. **Open the Project:** Navigate to the cloned directory and open the swift-fm-example.xcodeproj file using Xcode. This will allow you to view the full project source code.

4. **Setup key from Cloudbees account:** 

    - Open the swift-fm-example
    - Select a AppDelegate.swift file and setup key here: 
    ```
        ROX.setup(withKey: "<your Environment Key>", options: options)
    ```


4. **Run the swift-fm-example App:** 

    - Run the swift-fm-example app by selecting Product > Run or by pressing Cmd + R. This will launch the app.



