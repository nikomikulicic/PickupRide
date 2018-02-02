//
//  ProfileViewController.swift
//  PickupRide
//
//  Created by Niko Mikulicic on 02/02/2018.
//  Copyright © 2018 Niko Mikulicic. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    private var viewModel: ProfileViewModel!
    
    convenience init(viewModel: ProfileViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpAppearance()
    }
    
    private func setUpAppearance() {
        view.backgroundColor = UIColor.prBackgroundGray
        title = "Profile"
    }
}
