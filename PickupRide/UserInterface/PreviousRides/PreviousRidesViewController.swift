//
//  PreviousRidesViewController.swift
//  PickupRide
//
//  Created by Niko Mikulicic on 06/02/2018.
//  Copyright © 2018 Niko Mikulicic. All rights reserved.
//

import UIKit

class PreviousRidesViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
   
    private let cellName = String(describing: PreviousRideCell.self)
    private var viewModel: PreviousRidesViewModel!
    
    convenience init(viewModel: PreviousRidesViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        title = "Previous rides"
        tableView.dataSource = self
        tableView.register(UINib(nibName: cellName, bundle: nil), forCellReuseIdentifier: cellName)
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
