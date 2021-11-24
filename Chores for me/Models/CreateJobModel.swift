//
//  CreateJobModel.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 03/09/21.
//

import Foundation
struct CreateJobModel : Codable {
    let status : Int?
    let data : CreateJobData?
    let jobId : Int?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case data = "data"
        case jobId = "jobId"
        case message = "message"
    }

}

struct CreateJobData : Codable {

    }



