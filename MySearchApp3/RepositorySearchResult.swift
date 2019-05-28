class RepositorySearchResult: Codable {
    var items: [RepoItem] = [RepoItem]()
    
    // デコード処理
    /*
    required init(from decoder: Decoder) throws {
    }
    */
    
    // エンコード処理
    func encode(to encoder: Encoder) throws {
    }
}

// アイテム一件分
class RepoItem: Codable {
    var fullName = ""
    var description = ""
    var htmlUrl: String?
    var stargazersCount: Int = 0
    var language = ""
    
    var owner: Owner = Owner()
    
    class Owner: Codable {
        var avatarUrl: String?
        
        private enum CodingKeys: String, CodingKey {
            case avatarUrl = "avatar_url"
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
        case description
        case htmlUrl = "html_url"
        case stargazersCount = "stargazers_count"
        case language
        case owner
    }
}