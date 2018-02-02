//
//  ProfileViewModel.swift
//  PickupRide
//
//  Created by Niko Mikulicic on 02/02/2018.
//  Copyright © 2018 Niko Mikulicic. All rights reserved.
//

import Foundation
import RxSwift

struct UserInfo {
    let name: String
    let age: Int
    let plateNumber: String
    let profileImage: BundleImage
}

enum ProfileOption {
    case previousRides
    case locationSettings
    
    var title: String {
        switch self {
        case .previousRides:
            return "Previous rides"
        case .locationSettings:
            return "Location settings"
        }
    }
    
    var image: BundleImage {
        switch self {
        case .previousRides:
            return .list
        case .locationSettings:
            return .pin
        }
    }
}

class ProfileViewModel {
    
    let userInfo: UserInfo
    let options: [ProfileOption] = [.previousRides, .locationSettings]
    let optionTapped = PublishSubject<ProfileOption>()
    
    init(userInfo: UserInfo) {
        self.userInfo = userInfo
    }
    
    func tappedOption(at index: Int) {
        let option = options[index]
        optionTapped.onNext(option)        
    }
}
