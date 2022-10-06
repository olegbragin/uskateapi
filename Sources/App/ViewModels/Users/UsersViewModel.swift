import Vapor

struct UsersViewModel: Content {
  let users: [UserViewModel]

  init(_ users: [UserViewModel]) {
    self.users = users
  }
}