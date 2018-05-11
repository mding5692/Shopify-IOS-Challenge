//
//  ProvinceViewController.swift
//  Shopify-Winter-2018-Challenge
//
//  Created by Michael Ding on 2018-05-11.
//  Copyright © 2018 MDing. All rights reserved.
//

import UIKit

// Stores order associated with province and order
struct ProvinceOrderData {
    var province = ""
    var provinceOrders = [OrderInfo]()
}

// Struct storing order info
struct OrderInfo {
    var province = ""
    var orderID = ""
    var totalPrice = ""
}

// For showing orders to each province

class ProvinceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // UI Items
    @IBOutlet weak var provincesTableView: UITableView!
    
    // Data
    var provinceSections = [ProvinceOrderData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sets up tableView delegate and data sources
        provincesTableView.delegate = self
        provincesTableView.dataSource = self
    }
    
}

// MARK: -- Handles UITableViewDelegate and Datasource
extension ProvinceViewController {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return provinceSections[section].province
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return provinceSections[section].provinceOrders.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return provinceSections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "provinceCell") as! UITableViewCell
        cell.textLabel?.text = ""
        return cell
    }
}
