import Foundation

/// Environment configuration for the app
enum Environment {
    /// The current environment the app is running in
    static var current: EnvironmentType {
        #if DEBUG
            UnifiedLogger.info("Running in development environment", context: "App")
            return .development
        #else
            UnifiedLogger.info("Running in production environment", context: "App")
            return .production
        #endif
    }

    /// Available environment types
    enum EnvironmentType {
        case development
        case production

        /// Firebase project ID for the current environment
        var firebaseProjectId: String {
            switch self {
            case .development:
                return "aiaio-dev"
            case .production:
                return "aiaio-prod"
            }
        }

        /// Whether to use Firebase local emulator
        var useFirebaseEmulator: Bool {
            switch self {
            case .development:
                return true
            case .production:
                return false
            }
        }
    }
}
