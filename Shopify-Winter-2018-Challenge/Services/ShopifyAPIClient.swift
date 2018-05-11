//
//  ShopifyAPIClient.swift
//  Shopify-Winter-2018-Challenge
//
//  Created by Michael Ding on 2018-05-10.
//  Copyright © 2018 MDing. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

// Handles grabbing data from Shopify Store and accessing Shopify API

class ShopifyAPIClient {
    // Singleton reference
    static let main = ShopifyAPIClient()
    
    // MARK: -- Properties
    let shopifyAPILink = "https://shopicruit.myshopify.com/admin/orders.json?page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"
    var shopifyDataGrabbedAlready = false
    var shopifyDataCache = JSON()
    
    // MARK: -- Summarizes order for 2017 year
    public func generateOrderSummaryFor2017(completion: @escaping (_ total2017Orders: Int) -> Void) {
        grabShopifyStoreData() { response in
            guard let total2017Orders = self.countTotal2017Orders(for: response) as? Int,
                total2017Orders > 0 else {
                    print("Error grabbing total orders for 2017")
                    completion(-1)
                    return
            }
            
            print("Generates number of orders in 2017")
            completion(total2017Orders)
        }
    }
    
    // MARK: -- Summarizes order numbers by province
    public func generateOrderSummaryByProvince(completion: @escaping (_ provinceDataDict: [String: Int]) -> Void) {
        grabShopifyStoreData() { response in
            guard let provinceDataDict = self.countOrdersByProvince(for: response) as? [String: Int],
                !provinceDataDict.isEmpty else {
                    print("Error grabbing total orders for each province")
                    completion([String: Int]())
                    return
            }
            
            print("Generates number of orders by province")
            completion(provinceDataDict)
        }
    }
    
    // MARK: -- Grabs the store data for Shopify Store using link
    fileprivate func grabShopifyStoreData(completion: @escaping (_ storeDataJSON: JSON) -> Void) {
        // Grabs from cache if already grabbed shopify data
        guard !shopifyDataGrabbedAlready else {
            completion(shopifyDataCache)
            return
        }
        
        // Grabs store data using Alamofire request
        Alamofire.request(shopifyAPILink).validate().responseJSON { response in
                            
            switch response.result {
            case .success:
                
                // Error handling
                guard let data = response.data,
                    let jsonValue = try! JSON(data: data) as? JSON else {
                        print("Unable to convert to json value")
                        completion(JSON())
                        return
                }
                print("Grabbed store data and passed in completionhandler")
                
                // Stores it in data cache and indicated data is grabbed
                self.shopifyDataCache = jsonValue
                self.shopifyDataGrabbedAlready = true
                
                completion(jsonValue)
                return
                
            case .failure(let error):
                print("Can't grab store data due to: \(error)")
                completion(JSON())
                return
            }
        }
    }
    
    // MARK: -- Returns total count of orders in 2017
    fileprivate func countTotal2017Orders(for dataJSON: JSON) -> Int {
        guard !dataJSON.isEmpty else {
            return -1
        }
        
        // Iterates through the orders and counts the ones in 2017
        var orderCount = 0
        for order in dataJSON["orders"].arrayValue {
            guard let orderCreatedDateStr: String = order["created_at"].stringValue,
                let orderCreatedYear: String = String(orderCreatedDateStr.prefix(4)),
                orderCreatedYear == "2017" else {
                continue
            }
            
            orderCount += 1
        }

        return orderCount
    }
    
    // MARK: -- Returns dictionary containing province and orders associated with province
    fileprivate func countOrdersByProvince(for dataJSON: JSON) -> [String: Int] {
        guard !dataJSON.isEmpty else {
            return [String: Int]()
        }
        
        var provinceDict = [String: Int]()
        
        // Iterates and keep tracks of order by province
        for order in dataJSON["orders"].arrayValue {
            guard let province: String = order["customer"]["default_address"]["province"].stringValue else {
                continue
            }
            
            if let numProvinceOrders = provinceDict[province] {
                provinceDict[province] = numProvinceOrders + 1
            } else {
                provinceDict[province] = 1
            }
        }
        
        return provinceDict
    }
}
