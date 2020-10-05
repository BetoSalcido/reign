//
//  HomeModel.swift
//  reign
//
//  Created by Beto Salcido on 04/10/20.
//  Copyright © 2020 BetoSalcido. All rights reserved.
//

import Foundation

// MARK: - HackerNews
struct HackerNews: Codable {
    var hits: [Hit]?
    let nbHits, page, nbPages, hitsPerPage: Int?
    let exhaustiveNbHits: Bool?
    let query: Query?
    let params: String?
    let processingTimeMS: Int?
}

// MARK: - Hit
struct Hit: Codable {
    let createdAt: String?
    let title, url: String?
    let author: String?
    let points: Int?
    let commentText: String?
    let numComments: Int?
    let storyID: Int?
    var storyTitle: StoryTitle?
    var storyURL: StoryURL?
    let parentID, createdAtI: Int?
    let tags: [String]?
    let objectID: String?
    let highlightResult: HighlightResult?

    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case title, url, author, points
        case commentText = "comment_text"
        case numComments = "num_comments"
        case storyID = "story_id"
        case storyTitle = "story_title"
        case storyURL = "story_url"
        case parentID = "parent_id"
        case createdAtI = "created_at_i"
        case tags = "_tags"
        case objectID
        case highlightResult = "_highlightResult"
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        createdAt = try? container.decode(String.self, forKey: .createdAt)
        title = try? container.decode(String.self, forKey: .title)
        url = try? container.decode(String.self, forKey: .url)
        author = try? container.decode(String.self, forKey: .author)
        points = try? container.decode(Int.self, forKey: .points)
        commentText = try? container.decode(String.self, forKey: .commentText)
        numComments = try? container.decode(Int.self, forKey: .numComments)
        storyID = try? container.decode(Int.self, forKey: .storyID)
        storyTitle = try? container.decode(StoryTitle.self, forKey: .storyTitle)
        storyURL = try? container.decode(StoryURL.self, forKey: .storyURL)

        if let url = try? container.decode(String.self, forKey: .storyURL) {
            storyURL = StoryURL.init(value: url, matchLevel: "")
        }
        
        if let title = try? container.decode(String.self, forKey: .storyTitle) {
            storyTitle = StoryTitle.init(value: title, matchLevel: "")
        }
        
        parentID = try? container.decode(Int.self, forKey: .parentID)
        createdAtI = try? container.decode(Int.self, forKey: .createdAtI)
        tags = try? container.decode([String].self, forKey: .tags)
        objectID = try? container.decode(String.self, forKey: .objectID)
        highlightResult = try? container.decode(HighlightResult.self, forKey: .highlightResult)
        
        
    }
}

// MARK: - StoryURL
struct StoryURL: Codable {
    let value: String?
    let matchLevel: String?
}

// MARK: - StoryTitle
struct StoryTitle: Codable {
    let value, matchLevel: String?
}


// MARK: - HighlightResult
struct HighlightResult: Codable {
    let author, commentText, storyTitle: Author?
    let storyURL: Author??

    enum CodingKeys: String, CodingKey {
        case author
        case commentText = "comment_text"
        case storyTitle = "story_title"
        case storyURL = "story_url"
    }
}

// MARK: - Author
struct Author: Codable {
    let value: String?
    let matchLevel: MatchLevel?
    let matchedWords: [Query]?
    let fullyHighlighted: Bool?
}

enum MatchLevel: String, Codable {
    case full = "full"
    case none = "none"
}

enum Query: String, Codable {
    case ios = "ios"
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
