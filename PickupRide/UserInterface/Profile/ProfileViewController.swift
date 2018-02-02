//
//  ProfileViewController.swift
//  PickupRide
//
//  Created by Niko Mikulicic on 02/02/2018.
//  Copyright © 2018 Niko Mikulicic. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var plateNumberLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var optionsTableView: UITableView!

    private var viewModel: ProfileViewModel!
    
    convenience init(viewModel: ProfileViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpAppearance()
        connectToViewModel()
    }
    
    private func connectToViewModel() {
        nameLabel.text = viewModel.userInfo.name
        ageLabel.text = "Age: \(viewModel.userInfo.age)"
        plateNumberLabel.text = viewModel.userInfo.plateNumber
        profileImageView.image = UIImage(from: viewModel.userInfo.profileImage)
    }
    
    private func setUpAppearance() {
        view.backgroundColor = UIColor.prBackgroundGray
        title = "Profile"
    }
}
