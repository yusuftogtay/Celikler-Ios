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

class subCategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, productCell, UICollectionViewDataSource, UICollectionViewDelegate, catCell{
    
    var item = 0
    
    func catClick(index: IndexPath) {
        let url = URL(string: "https://amasyaceliklermarket.com/api/product/" + String(subCategory[index.row].id))
        ApiService.callGet(url: url!, finish: getProduct)
        item = index.row
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    var _selectedIndexPath : IndexPath? = nil
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let url = URL(string: "https://amasyaceliklermarket.com/api/product/" + String(subCategory[indexPath.row].id))
        ApiService.callGet(url: url!, finish: getProduct)
        subCategoryIndex = indexPath.row
        item = indexPath.row
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "cat", for: indexPath)
        if let productName = cell2.viewWithTag(88) as? UILabel {
            productName.text = items[indexPath.row]
        }
        if (indexPath.row == item){
            cat.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionView.ScrollPosition.centeredHorizontally)
            cell2.backgroundColor = UIColor.white
        }
        cell2.layer.cornerRadius = 6.0
        return cell2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = cat.frame.size
        return CGSize(width: (size.width / 4), height: (size.height / 1.9))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0.5, bottom: 0, right: 0.5)
    }
    
    func onClickImage(indexPath: IndexPath) {
        print("image \(indexPath.row)")
    }
    
    func onClickCell(index: Int, unit: String, indexPath: IndexPath) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        if unit != "0.0" || unit != "0"  {
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
    
    @IBOutlet weak var cat: UICollectionView!
    
    
    
    var subCategory: [subCategoryStruct] = []
    var productList: [product] = []
    var subCategoryIndex = 0
    var subCategoryID = [String?]()
    let id = UserDefaults.standard.value(forKey: "userID") as? String
    var items: [String] = []
    let placeHolderImage = UIImage(named: "V1")
    
    @IBOutlet weak var subCategoryTable: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print(subCategoryIndex)
        let indexPathForFirstRow = IndexPath(row: 0, section: 0)
        self.cat.selectItem(at: indexPathForFirstRow, animated: true, scrollPosition: .top)
        let url = URL(string: "https://amasyaceliklermarket.com/api/category_alt/" + String(subCategoryIndex))
        ApiService.callGet(url: url!, finish: subCategoryFunc)
        let indexPath = IndexPath(item: item, section: 0)
        self.cat.selectItem(at: indexPath, animated: false, scrollPosition: UICollectionView.ScrollPosition.centeredHorizontally)
    }
    
    func subCategoryFunc(message:String, data:Data?) -> Void
    {
        do
        {
            if let jsonData = data
            {
                subCategory = try JSONDecoder().decode([subCategoryStruct].self, from: jsonData)
                items.removeAll()
                for i in subCategory {
                    if i.status != "0"  {
                        items.append(i.title)
                    }
                }
                DispatchQueue.main.async {
                    self.cat.reloadData()
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
    
    var image = ""
    var details = ""
    var name = ""
    var productid = ""
    var product_unit = ""
    var unit_value = ""
    var price = ""
    var qty = ""
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goDetail" {
            let destination = segue.destination as! productDetailsViewController
            destination.image = image
            destination.details = details
            destination.productid = productid
            destination.name = name
            destination.unit_value = unit_value
            destination.product_unit = product_unit
            destination.price = price
            destination.qtyy = qty
        }
    }
    
    func getProduct(message:String, data:Data?) -> Void
    {
        do {
                if let jsonData = data
                {
                    productList.removeAll()
                    productList = try JSONDecoder().decode([product].self, from: jsonData)
                    DispatchQueue.main.async {
                        self.subCategoryTable.isHidden = false
                        self.subCategoryTable.reloadData()
                    }
                }
        } catch {
            DispatchQueue.main.async {
                self.subCategoryTable.isHidden = true
            }
        }
    }
    
    
    override func viewDidLoad() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        self.cat.layer.cornerRadius = 6.0
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        image = productList[indexPath.row].product_image
        name = productList[indexPath.row].product_name
        productid = productList[indexPath.row].product_id
        details = productList[indexPath.row].product_description
        product_unit = productList[indexPath.row].unit
        unit_value = productList[indexPath.row].unit_value
        price = productList[indexPath.row].price
        if productList[indexPath.row].unit == "kg" {
            qty = "0.0"
        } else {
            qty = "0"
        }
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cards")
        do {
            let result = try managedContext.fetch(fetchRequest)
            if result.count != 0 {
                for data in result as! [NSManagedObject] {
                    if data.value(forKey: "id") as! String == productid {
                        qty = (data.value(forKey: "qty") as! String)
                    } else {
                        if productList[indexPath.row].unit == "kg" {
                            qty = "0.0"
                        } else {
                            qty = "0"
                        }
                    }
                }
            } else {
                if productList[indexPath.row].unit == "kg" {
                    qty = "0.0"
                } else {
                    qty = "0"
                }
            }
        } catch {
            print("Failed")
        }
        performSegue(withIdentifier: "goDetail", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = subCategoryTable.dequeueReusableCell(withIdentifier: "sub", for: indexPath) as? productsTableViewCell
        tableCell?.cellDelegate = self
        tableCell?.index = indexPath
        tableCell?.layer.cornerRadius = 6.0
        tableCell?.layer.borderWidth = 0.5
        let myColor = UIColor.lightGray.cgColor
        tableCell!.layer.borderColor = myColor
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cards")
        do {
            let result = try managedContext.fetch(fetchRequest)
            if result.count != 0 {
                for data in result as! [NSManagedObject] {
                    if data.value(forKey: "id") as! String == productList[indexPath.row].product_id {
                        if let productName = tableCell?.viewWithTag(502) as? UILabel {
                            productName.text = "\(data.value(forKey: "price") as! String)₺"
                        }
                        if let productName = tableCell?.viewWithTag(508) as? UILabel {
                            productName.text = "\(data.value(forKey: "qty") as! String)"
                        }
                        if let productName = tableCell?.viewWithTag(503) as? UILabel {
                            let price = Double((data.value(forKey: "price") as! String))
                            let qty = Double((data.value(forKey: "qty") as! String))
                            productName.text = "Toplam: \(Double(round(100*(price! * qty!))/100))₺"
                        }
                    } else {
                        if let productName = tableCell?.viewWithTag(502) as? UILabel {
                            productName.text = String(productList[indexPath.row].price) + "₺"
                        }
                        if let productName = tableCell?.viewWithTag(508) as? UILabel {
                            if productList[indexPath.row].unit == "kg" {
                                productName.text = "0.0"
                            } else {
                                productName.text = "0"
                            }
                        }
                        if let productName = tableCell?.viewWithTag(503) as? UILabel {
                            productName.text = "Toplam:"
                        }
                    }
                }
            } else {
                if let productName = tableCell?.viewWithTag(502) as? UILabel {
                    productName.text = String(productList[indexPath.row].price) + "₺"
                }
                if let productName = tableCell?.viewWithTag(508) as? UILabel {
                    if productList[indexPath.row].unit == "kg" {
                        productName.text = "0.0"
                    } else {
                        productName.text = "0"
                    }
                }
            }
        } catch {
            print("Failed")
        }
        if let productName = tableCell?.viewWithTag(600) as? UILabel {
            productName.text = productList[indexPath.row].product_name
        }
        let imageUrl = URL(string: "https://amasyaceliklermarket.com" + String(productList[indexPath.row].product_image))
        if let productImage = tableCell?.viewWithTag(501) as? UIImageView {
            productImage.isUserInteractionEnabled = true
            productImage.indexPath(index: indexPath.row)
            productImage.sd_setImage(with: imageUrl, placeholderImage: placeHolderImage, options: SDWebImageOptions.progressiveLoad, context: nil)
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

struct denem {
    static var id: Int = 0
}

extension UIImageView {
    func indexPath(index: Int)  {
        denem.id = index
    }
}
