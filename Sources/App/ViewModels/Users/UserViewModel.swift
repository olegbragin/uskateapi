import Vapor

struct UserViewModel: Content {
  let name: String

  init(_ user: User) {
    self.name = [user.id?.uuidString, user.firstname, user.lastname].compactMap({ $0 }).joined(separator: ", ")
  }
}