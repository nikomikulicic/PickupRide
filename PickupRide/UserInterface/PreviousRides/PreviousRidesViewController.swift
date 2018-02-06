//
//  PreviousRidesViewController.swift
//  PickupRide
//
//  Created by Niko Mikulicic on 06/02/2018.
//  Copyright © 2018 Niko Mikulicic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PreviousRidesViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
   
    private let disposeBag = DisposeBag()
    private let cellName = String(describing: PreviousRideCell.self)
    private var viewModel: PreviousRidesViewModel!
    
    convenience init(viewModel: PreviousRidesViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpAppearance()
        configureTableView()
        connectToViewModel()
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.register(UINib(nibName: cellName, bundle: nil), forCellReuseIdentifier: cellName)
    }
    
    private func setUpAppearance() {
        title = "Previous rides"
        view.backgroundColor = UIColor.prBackgroundGray
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    private func connectToViewModel() {
        tableView.rx.itemSelected
            .map { $0.row }
            .bind(onNext: viewModel.itemTapped)
            .disposed(by: disposeBag)
    }
}

extension PreviousRidesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.previousRides.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellName) as! PreviousRideCell
        let data = viewModel.previousRides[indexPath.row]
        cell.setUp(for: data)
        
        return cell
    }
}
