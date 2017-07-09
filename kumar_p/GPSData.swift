//
//  GPSData.swift
//  kumar_p
//
//  Created by 兵藤允彦 on 2017/07/09.
//  Copyright © 2017年 Takuya Kudo. All rights reserved.
//

import Himotoki

struct GPSData {
    let lat: Double
    let lon: Double
    let time: String
}

extension GPSData: Decodable {
    static func decode(_ e: Extractor) throws -> GPSData {
        return try GPSData(lat: e <| "lat", lon: e <| "lon", time: e <| "time")
    }
}
