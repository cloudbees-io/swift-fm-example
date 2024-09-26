import ROX
import ROXCore

public class flags : RoxContainer {
  // Define the feature flags
  let enableTutorial = RoxFlag()
    // Using a simple singleton pattern
    // a single instance should be used and injected to using classes and unit tests
  let titleColors = RoxString(withDefault: "White", variations: ["White", "Blue", "Green", "Yellow"])
  static let INSTANCE = flags()
}