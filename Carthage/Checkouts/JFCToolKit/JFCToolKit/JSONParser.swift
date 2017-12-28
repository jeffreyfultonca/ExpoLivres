import Foundation

// MARK: - JSONParserError

public enum JSONParserError: Error {
    case failedToParseRootObject(String)
    case failedToParse(key: String, asType: String, fromDictionary: String)
}

// MARK: - JSONParser

public struct JSONParser {
    /**
     Returns root level object from JSON data as inferred type.
     
     Throws error if type mismatch occurs.
     */
    public static func parseRootObject<T>(from data: Data) throws -> T {
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        
        guard let rootObject = json as? T else {
            throw JSONParserError.failedToParseRootObject("\(json) as \(T.self)")
        }
        
        return rootObject
    }
    
    /**
     Returns value for key in dictionary as inferred type.
     
     Throws error is type mismatch occurs.
     */
    public static func parse<T>(key: String, from dictionary: [String: Any]) throws -> T {
        guard let value = dictionary[key] as? T else {
            throw JSONParserError.failedToParse(
                key: key,
                asType: "\(T.self)",
                fromDictionary:  "\(dictionary)"
            )
        }
        return value
    }
}
