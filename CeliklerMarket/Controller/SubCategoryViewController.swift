//
//  subViewController.swift
//  CeliklerMarket
//
//  Created by Ahmet Yusuf TOĞTAY on 15.05.2020.
//  Copyright © 2020 OzguRND. All rights reserved.
//

import UIKit
import SDWebImage
import CoreData

class subCategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, productCell {
    
    var subCategory: [subCategoryStruct] = []
    var productList: [product] = []
    var subCategoryIndex = 0
    var subCategoryID = [String?]()
    let id = UserDefaults.standard.value(forKey: "userID") as? String
    var items: [String] = []
    
    let placeHolderImage = UIImage(named: "V1")
    
    @IBOutlet weak var segmentCOntol: UISegmentedControl!
    @IBOutlet weak var subCategoryTable: UITableView!
    
    func subCategoryFunc(message:String, data:Data?) -> Void
    {
        do
        {
            if let jsonData = data
            {
                subCategory = try JSONDecoder().decode([subCategoryStruct].self, from: jsonData)
                for i in subCategory {
                    items.append(i.title)
                }
                DispatchQueue.main.async {
                    self.segmentCOntol.updateTitle(array: self.items)
                }
                let url = URL(string: "https://amasyaceliklermarket.com/api/product/" + String(subCategory[0].id))
                ApiService.callGet(url: url!, finish: getProduct)
            }
        }
        catch
        {
            print("Parse Error: \(error)")
        }
    }
    
    func getProduct(message:String, data:Data?) -> Void
    {
        do
        {
            productList.removeAll()
                if let jsonData = data
                {
                    productList = try JSONDecoder().decode([product].self, from: jsonData)
                    DispatchQueue.main.async {
                        self.subCategoryTable.isHidden = false
                        print(self.productList[0].category_id)
                        self.subCategoryTable.reloadData()
                    }
                }
        }
        catch
        {
            DispatchQueue.main.async {
                self.subCategoryTable.isHidden = true
            }
        }
    }
    
    @IBAction func segmentControl(_ sender: Any) {
        print(segmentCOntol.selectedSegmentIndex)
        let productUrl = URL(string: "https://amasyaceliklermarket.com/api/product/" + subCategory[segmentCOntol.selectedSegmentIndex].id)
        ApiService.callGet(url: productUrl!, finish: getProduct)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentCOntol.selectedSegmentIndex = 0
        let url = URL(string: "https://amasyaceliklermarket.com/api/category_alt/" + String(subCategoryIndex))
        ApiService.callGet(url: url!, finish: subCategoryFunc)
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cards")
        do {
            let result = try context.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                print("id \(String(describing: data.value(forKey: "id")))")
                print("qty \(String(describing: data.value(forKey: "qty")))")
            }
        } catch {
            print("Failed")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productList.count
    }
    
    func onClickCell(index: Int, unit: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        if "\(unit)" != "0" {
            let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Cards")
            fetchRequest.predicate = NSPredicate(format: "id = %@", productList[index].product_id)
            do {
                let test = try context.fetch(fetchRequest)
                if test.count != 0 {
                    let objectUpdate = test[0] as! NSManagedObject
                    objectUpdate.setValue(productList[index].product_id, forKeyPath: "id")
                    objectUpdate.setValue(productList[index].price, forKeyPath: "price")
                    objectUpdate.setValue(unit, forKeyPath: "qty")
                    objectUpdate.setValue(productList[index].unit, forKeyPath: "unit")
                    objectUpdate.setValue(productList[index].unit_value, forKeyPath: "unit_value")
                    objectUpdate.setValue(productList[index].product_image, forKeyPath: "image")
                    objectUpdate.setValue(productList[index].product_name, forKeyPath: "name")
                    do {
                        try context.save()
                        print("Güncelledi")
                        
                    } catch {
                        print(error)
                    }
                } else {
                    let newCard = NSEntityDescription.insertNewObject(forEntityName: "Cards", into: context)
                    newCard.setValue((productList[index].product_id), forKeyPath: "id")
                    newCard.setValue(productList[index].price, forKeyPath: "price")
                    newCard.setValue(unit, forKeyPath: "qty")
                    newCard.setValue(productList[index].unit, forKeyPath: "unit")
                    newCard.setValue(productList[index].unit_value, forKeyPath: "unit_value")
                    newCard.setValue(productList[index].product_image, forKeyPath: "image")
                    newCard.setValue(productList[index].product_name, forKeyPath: "name")
                    do {
                        try context.save()
                        print("burada")
                    } catch {
                        print(error)
                    }
                }
            } catch  {
                print(error)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = subCategoryTable.dequeueReusableCell(withIdentifier: "sub", for: indexPath) as? productsTableViewCell
        tableCell?.cellDelegate = self
        tableCell?.index = indexPath
        tableCell?.layer.cornerRadius = 6.0
        tableCell?.layer.borderWidth = 0.5
        let myColor = UIColor.lightGray.cgColor
        tableCell!.layer.borderColor = myColor
        if let productName = tableCell?.viewWithTag(500) as? UILabel {
            productName.text = productList[indexPath.row].product_name
        }
        if let productName = tableCell?.viewWithTag(502) as? UILabel {
            productName.text = String(productList[indexPath.row].price) + "₺"
        }
        let imageUrl = URL(string: "https://amasyaceliklermarket.com" + String(productList[indexPath.row].product_image))
        if let productImage = tableCell?.viewWithTag(501) as? UIImageView {
            productImage.sd_setImage(with: imageUrl, placeholderImage: placeHolderImage, options: SDWebImageOptions.highPriority, context: nil)
        }
        if let productName = tableCell?.viewWithTag(503) as? UILabel {
            productName.layer.cornerRadius = 15.0
        }
        if let productName = tableCell?.viewWithTag(505) as? UIButton {
            productName.layer.cornerRadius = 6.0
        }
        if let productName = tableCell?.viewWithTag(506) as? UIButton {
            productName.layer.cornerRadius = 6.0
        }
        if let productName = tableCell?.viewWithTag(507) as? UIButton {
            productName.layer.cornerRadius = 6.0
        }
        return (tableCell)!
    }
}

extension UISegmentedControl {
    func updateTitle(array titles: [String]) {
     removeAllSegments()
        for t in titles {
            insertSegment(withTitle: t, at: numberOfSegments, animated: true)
        }

     }
}
