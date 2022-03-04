//
//  NDLogin.swift
//  ONULHOI
//
//  Created by 김영민 on 2022/01/03.
//

import Foundation

final class NDLogin: JSONCodable {
    
    var id: String?
    var authorities: [Authorities]?
    var token: String?
    var refreshToken: String?
    var expireAt: String?
    var refreshTokenExpireAt: String?

    init() {
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = container.safeDecodeIfPresent(forKey: .id)
        authorities = container.safeDecodeIfPresent(forKey: .authorities)
        token = container.safeDecodeIfPresent(forKey: .token)
        refreshToken = container.safeDecodeIfPresent(forKey: .refreshToken)
        expireAt = container.safeDecodeIfPresent(forKey: .expireAt)
        refreshTokenExpireAt = container.safeDecodeIfPresent(forKey: .refreshTokenExpireAt)
    }
}

extension NDLogin {
    class Authorities: JSONCodable {
        var authority: String?
        
        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            authority = container.safeDecodeIfPresent(forKey: .authority)
        }
    }
}
