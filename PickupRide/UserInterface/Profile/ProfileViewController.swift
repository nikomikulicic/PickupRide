//
//  ProfileViewController.swift
//  PickupRide
//
//  Created by Niko Mikulicic on 02/02/2018.
//  Copyright © 2018 Niko Mikulicic. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ProfileViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var plateNumberLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var optionsTableView: UITableView!

    private var viewModel: ProfileViewModel!
    private let disposeBag = DisposeBag()
    private let cellReuseIdentifier = String(describing: ProfileOptionCell.self)
    
    convenience init(viewModel: ProfileViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        setUpAppearance()
        connectToViewModel()
    }
    
    private func connectToViewModel() {
        nameLabel.text = viewModel.userInfo.name
        ageLabel.text = "Age: \(viewModel.userInfo.age)"
        plateNumberLabel.text = viewModel.userInfo.plateNumber
        profileImageView.image = UIImage(from: viewModel.userInfo.profileImage)
        
        optionsTableView.rx.itemSelected
            .map { $0.row }
            .bind(onNext: viewModel.tappedOption)
            .disposed(by: disposeBag)
    }
    
    private func configureTableView() {
        let nibName = cellReuseIdentifier
        optionsTableView.register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        optionsTableView.dataSource = self
    }
    
    private func setUpAppearance() {
        view.backgroundColor = UIColor.prBackgroundGray
        title = "Profile"
    }
}

extension ProfileViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.options.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! ProfileOptionCell
        let option = viewModel.options[indexPath.row]
        cell.setUp(for: option)
        
        return cell
    }
}
