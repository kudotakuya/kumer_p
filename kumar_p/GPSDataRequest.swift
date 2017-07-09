//
//  GPSDataRequest.swift
//  kumar_p
//
//  Created by 兵藤允彦 on 2017/07/09.
//  Copyright © 2017年 Takuya Kudo. All rights reserved.
//

import APIKit
import Himotoki

struct GPSDataRequest: AppRequest {
    typealias Response = [GPSData]
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        return "/gps.json"
    }
    
    public func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        return try decodeArray(object)
    }
}
