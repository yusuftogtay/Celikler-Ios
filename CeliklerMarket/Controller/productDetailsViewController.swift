//
//  productDetailsViewController.swift
//  CeliklerMarket
//
//  Created by Ahmet Yusuf TOĞTAY on 10.06.2020.
//  Copyright © 2020 OzguRND. All rights reserved.
//

import UIKit
import SDWebImage
import CoreData

class productDetailsViewController: UIViewController {

    var image = ""
    var details = ""
    var name = ""
    var productid = ""
    var product_unit = ""
    var unit = ""
    var price = ""
    var unit_value = ""
    var qtyy = ""

    
    @IBOutlet weak var qty: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageLabel: UIImageView!
    @IBOutlet weak var detail: UILabel!
    let placeHolderImage = UIImage(named: "V1")

    override func viewDidLoad() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        super.viewDidLoad()
    }
    @IBAction func minus(_ sender: Any) {
        if (qty.text?.contains("."))! {
            let u = "\(Double(qty.text!) ?? 0)"
                       if Double(u)! == 0.0 {
                           qty.text = "0.0"
                       } else if Double(u)! == 0.5 {
                           qty.text = "0.5"
                       } else {
                           qty.text = "\( Double(round(10*(Double(u)! - 0.1))/10))"
                       }
        } else {
            if Int(qty.text!)! > 0 {
                let u = "\(Int(qty.text!) ?? 0)"
                qty.text = "\(Int(u)! - 1)"
            }
        }
    }
    @IBAction func plus(_ sender: Any) {
        if (qty.text?.contains("."))! {
            let u = "\(Double(qty.text!) ?? 0)"
            if Double(u)! < 1.0 {
                qty.text = "1.0"
            } else {
                qty.text = "\(Double(round(10*(Double(u)! + 0.1))/10))"
            }
        } else {
            let u = "\(Int(qty.text!) ?? 0)"
            qty.text = "\(Int(u)! + 1)"
        }
    }
    
    @IBAction func add(_ sender: Any) {
        let a = qty.text!
        let sayi = Double(a)!
        if sayi > 0  {
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            let context = appDelegate!.persistentContainer.viewContext
            if "\(unit)" != "0" {
                let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Cards")
                fetchRequest.predicate = NSPredicate(format: "id = %@", productid)
                do {
                    let test = try context.fetch(fetchRequest)
                    if test.count != 0 {
                        let objectUpdate = test[0] as! NSManagedObject
                        objectUpdate.setValue(productid, forKeyPath: "id")
                        objectUpdate.setValue(price, forKeyPath: "price")
                        objectUpdate.setValue(qty.text!, forKeyPath: "qty")
                        objectUpdate.setValue(product_unit, forKeyPath: "unit")
                        objectUpdate.setValue(unit_value, forKeyPath: "unit_value")
                        objectUpdate.setValue(image, forKeyPath: "image")
                        objectUpdate.setValue(name, forKeyPath: "name")
                        do {
                            try context.save()
                            print("Güncelledi")
                            
                        } catch {
                            print(error)
                        }
                    } else {
                        let newCard = NSEntityDescription.insertNewObject(forEntityName: "Cards", into: context)
                        newCard.setValue(productid, forKeyPath: "id")
                        newCard.setValue(price, forKeyPath: "price")
                        newCard.setValue(qty.text, forKeyPath: "qty")
                        newCard.setValue(product_unit, forKeyPath: "unit")
                        newCard.setValue(unit_value, forKeyPath: "unit_value")
                        newCard.setValue(image, forKeyPath: "image")
                        newCard.setValue(name, forKeyPath: "name")
                        do {
                            try context.save()
                            print("burada")
                        } catch {
                            print(error)
                        }
                    }
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cards")
                    if let result = try? context.fetch(fetchRequest) {
                        if let tabItems = tabBarController?.tabBar.items {
                            // In this case we want to modify the badge number of the third tab:
                            let tabItem = tabItems[1]
                            let badege = String(result.count)
                            tabItem.badgeValue = badege
                        }
                    }
                } catch  {
                    print(error)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let imageUrl = URL(string: "https://amasyaceliklermarket.com" + image)
        imageLabel.sd_setImage(with: imageUrl, placeholderImage: placeHolderImage, options: SDWebImageOptions.highPriority, context: nil)
        nameLabel.text = name
        detail.text = details
        qty.text = qtyy
    }
}
