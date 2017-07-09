//
//  AppRequestType.swift
//  kumar_p
//
//  Created by 兵藤允彦 on 2017/07/09.
//  Copyright © 2017年 Takuya Kudo. All rights reserved.
//

import APIKit

protocol AppRequest: Request {}

extension AppRequest {
    var baseURL: URL {
        return URL(string: "https://version1.xyz/spajam2017/")!
    }
}
