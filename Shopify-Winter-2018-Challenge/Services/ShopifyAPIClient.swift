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
    
    // MARK: -- Summarizes order for 2017 year
    public func generateOrderSummaryFor2017(completion: @escaping (_ total2017Orders: Int) -> Void) {
        grabShopifyStoreData() { response in
            guard let total2017Orders = self.countTotal2017Orders(for: response) as? Int,
                total2017Orders > 0 else {
                    print("Error grabbing total orders for 2017")
                    completion(-1)
                    return
            }
            
            print("Finished analysing store data and generates order summary")
            completion(total2017Orders)
        }
    }
    
    // Returns total count of orders in 2017
    fileprivate func countTotal2017Orders(for dataJSON: JSON) -> Int {
        guard !dataJSON.isEmpty else {
            return -1
        }
        
        var orderCount = 0
        
        
        
        return -1
    }
    
}
