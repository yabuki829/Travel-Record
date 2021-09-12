//
//  DataSets.swift
//  map
//
//  Created by Yabuki Shodai on 2021/05/29.
//

import Foundation
//会員登録
struct DataSetDocuments {
    let userID:String
    let userName:String
    let userProfileImage:String
    let place:String
    let comment:String
    let postDate:Double
    let contentImage:String
}
struct  DataSetCoordinate {
   //投稿
    let title:String
    let content:String
    let postDate:Double
    let latitudeDouble:Double
    let longitudeDouble:Double
    let image:String
}
