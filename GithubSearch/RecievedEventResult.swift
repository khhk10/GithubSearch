
// ユーザが受け取るイベント一件分
class RecievedEventItem: Codable {
    var type: String?
    var actor: Actor = Actor()
    var repository: Repository = Repository()
    //var payload: Payload = Payload()
    var time: String?
    
    class Actor: Codable {
        var name: String?
        var url: String?
        var avatarUrl: String?
        
        private enum CodingKeys: String, CodingKey {
            case name = "login"
            case url
            case avatarUrl = "avatar_url"
        }
    }
    
    class Repository: Codable {
        var name: String?
        var url: String?
    }
    /*
    class Payload: Codable {
        var action: String?
    }*/
    
    private enum CodingKeys: String, CodingKey {
        case type
        case actor
        case repository = "repo"
        //case payload
        case time = "created_at"
    }
}
