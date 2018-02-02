//
//  ProfileViewModel.swift
//  PickupRide
//
//  Created by Niko Mikulicic on 02/02/2018.
//  Copyright © 2018 Niko Mikulicic. All rights reserved.
//

import Foundation

struct UserInfo {
    let name: String
    let age: Int
    let plateNumber: String
    let profileImage: BundleImage
}

class ProfileViewModel {
    
    let userInfo: UserInfo    
    
    init(userInfo: UserInfo) {
        self.userInfo = userInfo
    }
}
