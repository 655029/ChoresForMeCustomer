//
//  AllUserDetailsModel.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 30/09/21.
//

import Foundation
struct UserDetailsModel : Codable {
    let status : Int?
    let data : JobDetailsData?
    let jobId : String?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case data = "data"
        case jobId = "jobId"
        case message = "message"
    }

}

import Foundation
struct JobDetailsData : Codable {
    let jobId : Int?
    let userId : String?
    let categoryId : String?
    let categoryName : String?
    let subcategoryId : [SubcategoryId3]?
    let image : String?
    let location : String?
    let price : String?
    let description : String?
    let lat : String?
    let lng : String?
    let day : String?
    let time : String?
    let jobStatus : String?
    let createdAt : String?
    let userDetails : UserDetails?
    let providerDetails : JobProviderDetails?

    enum CodingKeys: String, CodingKey {
        case jobId = "jobId"
        case userId = "UserId"
        case categoryId = "categoryId"
        case categoryName = "categoryName"
        case subcategoryId = "subcategoryId"
        case image = "image"
        case location = "location"
        case price = "price"
        case description = "description"
        case lat = "lat"
        case lng = "lng"
        case day = "day"
        case time = "time"
        case jobStatus = "jobStatus"
        case createdAt = "createdAt"
        case userDetails = "userDetails"
        case providerDetails = "providerDetails"
    }

}
struct JobProviderDetails : Codable {
    let userId : Int?
    let name : String?
    let email : String?
    let phone : String?
    let otp : String?
    let image : String?
    let user_verified : Int?
    let signupType : Int?
    let socialKey : String?
    let lat : String?
    let lng : String?
    let location_address : String?
    let radius : String?
    let availability_provider_days : String?
    let availability_provider_timing : String?
    let deviceID : String?
    let deviceType : String?
    let createdAt : String?

    enum CodingKeys: String, CodingKey {
        case userId = "UserId"
        case name = "name"
        case email = "email"
        case phone = "phone"
        case otp = "otp"
        case image = "image"
        case user_verified = "user_verified"
        case signupType = "signupType"
        case socialKey = "socialKey"
        case lat = "lat"
        case lng = "lng"
        case location_address = "location_address"
        case radius = "radius"
        case availability_provider_days = "availability_provider_days"
        case availability_provider_timing = "availability_provider_timing"
        case deviceID = "deviceID"
        case deviceType = "deviceType"
        case createdAt = "createdAt"
    }

}

struct SubcategoryId3 : Codable {
    let id : String?
    let name : String?
    let price : String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case price = "price"
    }

}

struct UserDetails : Codable {
    let userId : Int?
    let name : String?
    let email : String?
    let phone : String?
    let otp : String?
    let image : String?
    let user_verified : Int?
    let signupType : Int?
    let socialKey : String?
    let lat : String?
    let lng : String?
    let location_address : String?
    let radius : String?
    let availability_provider_days : String?
    let availability_provider_timing : String?
    let deviceID : String?
    let deviceType : String?
    let createdAt : String?

    enum CodingKeys: String, CodingKey {
        case userId = "UserId"
        case name = "name"
        case email = "email"
        case phone = "phone"
        case otp = "otp"
        case image = "image"
        case user_verified = "user_verified"
        case signupType = "signupType"
        case socialKey = "socialKey"
        case lat = "lat"
        case lng = "lng"
        case location_address = "location_address"
        case radius = "radius"
        case availability_provider_days = "availability_provider_days"
        case availability_provider_timing = "availability_provider_timing"
        case deviceID = "deviceID"
        case deviceType = "deviceType"
        case createdAt = "createdAt"
    }

}
