//
//  OrderSummaryViewController.swift
//  Shopify-Winter-2018-Challenge
//
//  Created by Michael Ding on 2018-05-10.
//  Copyright © 2018 MDing. All rights reserved.
//

import UIKit

// Shows the order summary for the store data gained from the Shopify Store

class OrderSummaryViewController: UIViewController {

    // UI Items
    @IBOutlet weak var numOrdersLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
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
            print(provinceDataDict)
        }
        
    }
    
}

