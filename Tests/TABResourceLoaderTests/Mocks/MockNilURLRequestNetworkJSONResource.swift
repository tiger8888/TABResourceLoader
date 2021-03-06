//
//  MockNilURLRequestNetworkJSONResource.swift
//  TABResourceLoaderTests
//
//  Created by Luciano Marisi on 10/09/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation
@testable import TABResourceLoader

struct MockNilURLRequestNetworkJSONResource: NetworkDataResourceType {
  typealias Model = String
  let url: URL = URL(string: "www.test.com")!

  func urlRequest() -> URLRequest? {
    return nil
  }
  
  func result(from data: Data) -> Result<String> {
    return .success("")
  }

}
