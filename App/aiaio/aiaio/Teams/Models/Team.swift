import Foundation
import FirebaseFirestore

/// Represents a team (e.g., a sports team or class) in the application.
/// This model maps directly to Firestore documents in the 'teams' collection.
struct Team: Identifiable, Codable {
    /// Unique identifier for the team (Firestore document ID)
    var id: String
    /// Display name of the team
    var name: String
    /// Detailed description of the team
    var description: String
    /// Firebase UID of the team owner
    var ownerUID: String
    /// Dictionary of member UIDs and their roles (true for inclusion)
    var memberUIDs: [String]
    /// Timestamp when the team was created
    var createdAt: Date
    /// Timestamp of the last update
    var updatedAt: Date
    
    /// Creates a new team with the specified owner.
    /// - Parameter ownerUID: The Firebase UID of the team creator.
    init(id: String = UUID().uuidString,
         name: String = "",
         description: String = "",
         ownerUID: String,
         memberUIDs: [String] = [],
         createdAt: Date = Date(),
         updatedAt: Date = Date()) {
        self.id = id
        self.name = name
        self.description = description
        self.ownerUID = ownerUID
        self.memberUIDs = memberUIDs
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

// MARK: - Firestore Conversions
extension Team {
    /// Returns a dictionary representation for Firestore storage.
    var asDictionary: [String: Any] {
        [
            "name": name,
            "description": description,
            "ownerUID": ownerUID,
            "memberUIDs": memberUIDs,
            "createdAt": Timestamp(date: createdAt),
            "updatedAt": Timestamp(date: updatedAt)
        ]
    }
    
    /// Creates a Team from a Firestore document.
    /// - Parameter document: The Firestore document.
    /// - Returns: A Team instance.
    static func from(_ document: DocumentSnapshot) throws -> Team {
        guard let data = document.data() else {
            throw GlobalError.invalidData
        }
        
        return Team(
            id: document.documentID,
            name: data["name"] as? String ?? "",
            description: data["description"] as? String ?? "",
            ownerUID: data["ownerUID"] as? String ?? "",
            memberUIDs: data["memberUIDs"] as? [String] ?? [],
            createdAt: (data["createdAt"] as? Timestamp)?.dateValue() ?? Date(),
            updatedAt: (data["updatedAt"] as? Timestamp)?.dateValue() ?? Date()
        )
    }
}

extension Team {
    /// Convenience method for creating a new team instance with default values.
    /// Note: The `ownerUID` remains empty here and should be set later from the authenticated session.
    static func new() -> Team {
        Team(id: UUID().uuidString,
             name: "",
             description: "",
             ownerUID: "",
             memberUIDs: [],
             createdAt: Date(),
             updatedAt: Date())
    }
}

extension Team: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id) // or combine(name) if ID might be empty
    }
    
    static func == (lhs: Team, rhs: Team) -> Bool {
        lhs.id == rhs.id
    }
}
