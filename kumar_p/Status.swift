//
//  Status.swift
//  kumar_p
//
//  Created by 兵藤允彦 on 2017/07/09.
//  Copyright © 2017年 Takuya Kudo. All rights reserved.
//

import Himotoki

struct Status {
    let status: Bool
}

extension Status: Decodable {
    static func decode(_ e: Extractor) throws -> Status {
        return try Status(status: e <| "status")
    }
}
