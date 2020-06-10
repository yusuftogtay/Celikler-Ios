//
//  Models.swift
//  CeliklerMarket
//
//  Created by Ahmet Yusuf TOĞTAY on 3.06.2020.
//  Copyright © 2020 OzguRND. All rights reserved.
//

import UIKit

struct myOrders: Codable {
    let sale_id, user_id, on_date, delivery_time_from: String
    let delivery_time_to, status, is_paid: String
    let total_amount, total_rewards, total_kg, total_items: String
    let socity_id: String
    let delivery_address: String
    let delivery_charge: String
    let payment_method: String
    let location_id: String
}

struct myOrderDetails: Codable {
    let sale_item_id, sale_id, product_id, product_name: String
    let qty, unit, unit_value, price: String
    let qty_in_kg, rewards, product_description, product_image: String
    let category_id, in_stock, tax: String
}

struct cancelOrders: Codable {
    let response: Bool
    let message: String
}

struct subCategoryStruct: Codable {
    let id, title, slug, parent: String
    let level, description, image, image2: String
    let image2_status, status: String
}

struct product: Codable {
    let product_id, product_name, product_description, product_image: String
    let category_id, in_stock, price, unit_value: String
    let unit, rewards, tax: String
}

struct socity: Codable {
    let socity_id, socity_name, delivery_charge, delivery_time: String
}

struct address: Codable {
    let response: Bool
    let data: [addressData]
}

struct addressData: Codable {
    let location_id, user_id, T_adres, socity_id: String
    let adress, receiver_name, receiver_mobile, socity_name: String
    let delivery_charge: String
}

struct getAddress: Codable {
    let response: Bool
    let data: addressData
}

struct editAddress: Codable {
    let response: Bool
    let data: String
}

struct limit: Codable {
    let id, title, value: String
}

struct dateResponse: Codable {
    let response: Bool
    let times: [String]
}

struct dateStruct: Codable {
    let date: String
}

struct send: Codable {
    var product_id: String
    var qty: String
    var unit_value: String
    var unit: String
    var price: String
}

struct sendSpecial: Codable {
    var product_id: String
    var qty: String
    var unit_value: String
    var unit: String
    var price: String
    var note: String
}

struct sendOrder: Codable {
    let response: Bool
    let data: String
}

struct deleteAddress: Codable {
    let response: Bool
    let message: String
}

struct shopingCards: Codable {
    private(set) public var user_id: String
    private(set) public var image: Data?
    private(set) public var product_id, product_unit, product_name: String
    private(set) public var category_id, price, unit_value: String
    private(set) public var unit: String
    
    init(withImage image: UIImage,
         withUserId user: String,
         withProductID productId: String,
         withProductName productName: String,
         withCategoryId categoryID: String,
         withPrice price: String,
         withUnitValue unitValue: String,
         withPeoductUnit producunit: String,
         withUnit unit: String) {
        self.image = image.pngData()
        self.user_id = user
        self.product_id = productId
        self.product_name = productName
        self.category_id = categoryID
        self.price = price
        self.unit_value = unitValue
        self.unit = unit
        self.product_unit = producunit
    }

    func getImage() -> UIImage? {
        guard let imageData = self.image else {
            return nil
        }
        let image = UIImage(data: imageData)
        
        return image
    }
}

struct sliderImage: Codable {
    let slider_image: String
    let slider_url: String
}

struct category: Codable {
    let id, title, slug, parent: String
    let level, description, image, image2: String
    let status: String
}
