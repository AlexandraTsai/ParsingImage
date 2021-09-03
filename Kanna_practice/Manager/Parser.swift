//
//  Parser.swift
//  Kanna_practice
//
//  Created by AlexandraTsai on 2021/9/3.
//

import Alamofire
import Foundation
import PromiseKit

class Parser {
    static func fetchHtmlData(from url: String) -> Promise<String> {
        return Promise { seal in
            AF.request(url).responseString { response in
                guard let html = response.value else {
                    seal.reject(AFError.responseValidationFailed(reason: .dataFileNil))
                    return
                }
                seal.fulfill(html)
            }
        }
    }
}
