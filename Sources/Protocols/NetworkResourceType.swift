//
//  NetworkResourceType.swift
//  TABResourceLoader
//
//  Created by Luciano Marisi on 10/09/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation

public enum HTTPMethod: String {
  case GET
  case POST
  case PATCH
  case DELETE
  case HEAD
  case PUT
}

public protocol NetworkResourceType {
  /// The URL of the resource
  var url: NSURL { get }

  /// The HTTP method used to fetch this resource
  var HTTPRequestMethod: HTTPMethod { get }

  /// The HTTP header fields used to fetch this resource
  var HTTPHeaderFields: [String: String]? { get }

  /// The HTTP body as JSON used to fetch this resource
  var JSONBody: AnyObject? { get }

  /// The query items to be added to the url to fetch this resource
  var queryItems: [NSURLQueryItem]? { get }

  /**
   Convenience function that builds a URLRequest for this resource

   - returns: A URLRequest or nil if the construction of the request failed
   */
  func urlRequest() -> NSURLRequest?
}

// MARK: - NetworkJSONResource defaults
public extension NetworkResourceType {

  public var HTTPRequestMethod: HTTPMethod { return .GET }
  public var HTTPHeaderFields: [String: String]? { return [:] }
  public var JSONBody: AnyObject? { return nil }
  public var queryItems: [NSURLQueryItem]? { return nil }

  public func urlRequest() -> NSURLRequest? {
    let urlComponents = NSURLComponents(URL: url, resolvingAgainstBaseURL: true)
    urlComponents?.queryItems = queryItems

    guard let urlFromComponents = urlComponents?.URL else { return nil }

    let request = NSMutableURLRequest(URL: urlFromComponents)
    request.allHTTPHeaderFields = HTTPHeaderFields
    request.HTTPMethod = HTTPRequestMethod.rawValue
    
    if let body = JSONBody {
      request.HTTPBody = try? NSJSONSerialization.dataWithJSONObject(body, options: NSJSONWritingOptions.PrettyPrinted)
    }

    return request
  }
}

public protocol NetworkDataTransformableResourceType: NetworkResourceType, DataTransformableResourceType {}
public protocol NetworkJSONResourceType: NetworkDataTransformableResourceType, JSONResourceType {}
public protocol NetworkImageResourceType: NetworkDataTransformableResourceType, ImageResourceType {}


public extension NetworkJSONResourceType {
  var HTTPHeaderFields: [String: String]? {
    return ["Content-Type": "application/json"]
  }
}