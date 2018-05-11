//
//  OrderSummaryViewController.swift
//  Shopify-Winter-2018-Challenge
//
//  Created by Michael Ding on 2018-05-10.
//  Copyright © 2018 MDing. All rights reserved.
//

import UIKit

// Struct used to store province data
struct ProvinceOrder {
    var province = ""
    var orderCount = -1
}

// Struct used to store 2017 order data
struct OrderData {
    var email = ""
    var createdDate = ""
    var totalPrice = ""
}

// Shows the order summary for the store data gained from the Shopify Store

class OrderSummaryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // UI Items
    @IBOutlet weak var numOrdersLabel: UILabel!
    @IBOutlet weak var orderByProvinceTableView: UITableView!
    @IBOutlet weak var ordersByYearTableView: UITableView!
    
    // Data
    var provinceData = [ProvinceOrder]()
    var yearlyOrderData = [OrderData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Sets up tableView delegate and data sources
        orderByProvinceTableView.delegate = self
        orderByProvinceTableView.dataSource = self
        ordersByYearTableView.delegate = self
        ordersByYearTableView.dataSource = self
        
        generateOrderSummary()
    }

    // MARK: -- Generates Shopify order summary for province, year, etc using completionHandlers
    fileprivate func generateOrderSummary() {
        // Grabs 2017 total order count
        shopifyClient.generateOrderSummaryFor2017() { total2017OrdersNum in
            self.numOrdersLabel.text = "\(total2017OrdersNum)"
        }
        
        // Grabs orders by province
        shopifyClient.generateOrderSummaryByProvince() { provinceDataDict in
            for (province, numOrders) in provinceDataDict {
                guard !province.isEmpty else {
                    continue
                }
                
                let provinceStruct = ProvinceOrder(province: province, orderCount: numOrders)
                self.provinceData.append(provinceStruct)
            }
            self.orderByProvinceTableView.reloadData()
        }
        
        // Grabs order by year
        shopifyClient.generateFirstTenOrdersOf2017() { orderData in
            self.yearlyOrderData = orderData
            self.ordersByYearTableView.reloadData()
        }
        
    }
    
}

// MARK: -- Handles UITableViewDelegate and Datasource
extension OrderSummaryViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == ordersByYearTableView {
            return yearlyOrderData.count
        }
        
        return provinceData.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == ordersByYearTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "yearCell")
            
            
            cell?.textLabel?.text = "email: \(yearlyOrderData[indexPath.row].email), date: \(yearlyOrderData[indexPath.row].createdDate), total price: \(yearlyOrderData[indexPath.row].totalPrice)"
            return cell!
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = "\(provinceData[indexPath.row].orderCount) orders from \(provinceData[indexPath.row].province)"
        return cell!
    }
}
