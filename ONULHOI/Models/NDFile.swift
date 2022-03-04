//
//  NDFile.swift
//  Lulla
//
//  Created by 김영민 on 2021/01/19.
//

import Foundation

extension NDFile {
    enum FileType: String, JSONCodable {
        case image
        case video
        case application
    }
}

extension NDFile: Equatable {
    static func == (lhs: NDFile, rhs: NDFile) -> Bool {
        return (lhs.id == rhs.id)
    }
}

final class NDFile: JSONCodable {
    
    var id: String?
    var address: String?
    var thumbnail_address: String?
    var name: String?
    var type: FileType?
    var size: Int?
    var author_id: String?
    var height: Int?
    var width: Int?
    var index: Int?
    var fileData: Data?
    var duration: TimeInterval?
    
    init() {
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = container.safeDecodeIfPresent(forKey: .id)
        address = container.safeDecodeIfPresent(forKey: .address)
        thumbnail_address = container.safeDecodeIfPresent(forKey: .thumbnail_address)
        name = container.safeDecodeIfPresent(forKey: .name)
        type = container.safeDecodeIfPresent(forKey: .type)
        size = container.safeDecodeIfPresent(forKey: .size)
        author_id = container.safeDecodeIfPresent(forKey: .author_id)
        height = container.safeDecodeIfPresent(forKey: .height)
        width = container.safeDecodeIfPresent(forKey: .width)
        index = container.safeDecodeIfPresent(forKey: .index)
        fileData = container.safeDecodeIfPresent(forKey: .fileData)
        duration = container.safeDecodeIfPresent(forKey: .duration)
    }
}
