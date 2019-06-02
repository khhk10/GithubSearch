class UserSearchResult: Codable {
    var items: [UserItem] = [UserItem]()
    
    // デコード処理
    /*
     required init(from decoder: Decoder) throws {
     }
     */
    
    // エンコード処理
    func encode(to encoder: Encoder) throws {
    }
}

// ユーザ一件分
class UserItem: Codable {
    var name = ""
    var avatarUrl: String?
    var htmlUrl: String?
    
    private enum CodingKeys: String, CodingKey {
        case name = "login"
        case avatarUrl = "avatar_url"
        case htmlUrl = "html_url"
    }
}


