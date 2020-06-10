//
//  CardsViewController.swift
//  CeliklerMarket
//
//  Created by Ahmet Yusuf TOĞTAY on 5.06.2020.
//  Copyright © 2020 OzguRND. All rights reserved.
//

import UIKit
import CoreData
import SDWebImage

class CardsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, productCell {
    
    func onClickCell(index: Int, unit: String, indexPath: IndexPath) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        if "\(unit)" != "0" {
            let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Cards")
            fetchRequest.predicate = NSPredicate(format: "id = %@", cards1.cards1[index].product_id)
            do {
                let test = try context.fetch(fetchRequest)
                if test.count != 0 {
                    let objectUpdate = test[0] as! NSManagedObject
                    objectUpdate.setValue(cards1.cards1[index].product_id, forKeyPath: "id")
                    objectUpdate.setValue(cards1.cards1[index].price, forKeyPath: "price")
                    objectUpdate.setValue(unit, forKeyPath: "qty")
                    objectUpdate.setValue(cards1.cards1[index].unit, forKeyPath: "unit")
                    objectUpdate.setValue(cards1.cards1[index].unit_value, forKeyPath: "unit_value")
                    objectUpdate.setValue(cards1.cards1[index].image, forKeyPath: "image")
                    objectUpdate.setValue(cards1.cards1[index].name, forKeyPath: "name")
                    do {
                        try context.save()
                    } catch {
                        print(error)
                    }
                } else {
                    let newCard = NSEntityDescription.insertNewObject(forEntityName: "Cards", into: context)
                    newCard.setValue(cards1.cards1[index].product_id, forKeyPath: "id")
                    newCard.setValue(cards1.cards1[index].price, forKeyPath: "price")
                    newCard.setValue(unit, forKeyPath: "qty")
                    newCard.setValue(cards1.cards1[index].unit, forKeyPath: "unit")
                    newCard.setValue(cards1.cards1[index].unit_value, forKeyPath: "unit_value")
                    newCard.setValue(cards1.cards1[index].image, forKeyPath: "image")
                    newCard.setValue(cards1.cards1[index].name, forKeyPath: "name")
                    do {
                        try context.save()
                    } catch {
                        print(error)
                    }
                }
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cards")
                do {
                    let result = try context.fetch(fetchRequest)
                        unitInt = "Ürün Sayısı: \(result.count)"
                        total.text = "Toplam: 0₺"
                        totalInt = 0
                        for data in result as! [NSManagedObject] {
                            let price = Double(data.value(forKey: "price") as! String)
                            let qty = Double(data.value(forKey: "qty") as! String)
                            totalInt += price! * qty!
                        }
                        total.text = "Toplam: \(Double(round(100*totalInt)/100))₺"
                } catch {
                    print("Failed")
                }
            } catch  {
                print(error)
            }
        }
    }

    @IBOutlet weak var unit: UILabel!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var cardsImage: UIImageView!
    @IBOutlet weak var cardsBack: UIButton!
    @IBOutlet weak var cardsInfo: UILabel!
    @IBOutlet weak var cardTable: UITableView!
    @IBOutlet weak var infoStack: UIStackView!
    @IBOutlet weak var cardClear: UIButton!
    @IBOutlet weak var payDone: UIButton!
    var unitInt: String = "0"
    var totalInt: Double = 0
    var cards: [card] = []
    var minLimit = String()
    var maxLimit = String()
    
    var cards1 = cardProduct(cards: [shoppingCards]())
    
    
    let placeHolderImage = UIImage(named: "V1")
    

    @IBAction func payDone(_ sender: Any) {
        if totalInt < Double(minLimit)! {
            let alert = UIAlertController(title: "Minimum Sipariş Limiti", message: "Minimum Sipariş Tutarı \(minLimit)₺ dir.", preferredStyle: .alert)

            let action = UIAlertAction(title: "Tamam", style: .default, handler: nil)
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
        } else if totalInt > Double(maxLimit)! {
            let alert = UIAlertController(title: "Maximum Sipariş Limiti", message: "Maximum Sipariş Tutarı \(maxLimit)₺ dir.", preferredStyle: .alert)

            let action = UIAlertAction(title: "Tamam", style: .default, handler: nil)
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "goPay", sender: nil)
        }
    }
    
    @IBAction func deleteAllItems(_ sender: Any) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cards")
        if let result = try? managedContext.fetch(fetchRequest) {
            for object in result {
                managedContext.delete(object as! NSManagedObject)
            }
            do {
                try managedContext.save()
            } catch {
                print(error)
            }
        }
        cards1.cards1.removeAll()
        cardTable.reloadData()
        cardsImage.isHidden = false
        cardsInfo.isHidden = false
        cardClear.isHidden = true
        cardTable.isHidden = true
        infoStack.isHidden = true
        payDone.isHidden = true
    }
    
    override func viewDidLoad() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .darkGray
        payDone.layer.cornerRadius = 6.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cards")
        do {
            let result = try managedContext.fetch(fetchRequest)
            if result.count != 0 {
                cardsImage.isHidden = true
                cardsInfo.isHidden = true
                cardClear.isHidden = false
                cardTable.isHidden = false
                infoStack.isHidden = false
                payDone.isHidden = false
                unitInt = "Ürün Sayısı: \(result.count)"
                unit.text = unitInt
                total.text = "Toplam: 0₺"
                totalInt = 0
                cards1.cards1.removeAll()
                for data in result as! [NSManagedObject] {
                    cards1.cards1.append(shoppingCards(name: data.value(forKey: "name") as! String,
                                                product_id: data.value(forKey: "id") as! String,
                                                price: data.value(forKey: "price") as! String,
                                                qty: data.value(forKey: "qty") as! String,
                                                unit: data.value(forKey: "unit") as! String,
                                                unit_value: data.value(forKey: "unit_value") as! String,
                                                image: data.value(forKey: "image") as! String))
                    let price = Double(data.value(forKey: "price") as! String)
                    let qty = Double(data.value(forKey: "qty") as! String)
                    totalInt += price! * qty!
                }
                total.text = "Toplam: \(Double(round(100*totalInt)/100))₺"
                self.cardTable.reloadData()
            } else {
                cardsImage.isHidden = false
                cardsInfo.isHidden = false
                cardClear.isHidden = true
                cardTable.isHidden = true
                infoStack.isHidden = true
                payDone.isHidden = true
            }
        } catch {
            print("Failed")
        }
        let url = URL(string: "https://amasyaceliklermarket.com/api/get_limit_settings")
        ApiService.callGet(url: url!, finish: limitResponse)
    }
    
    func limitResponse(message:String, data:Data?) -> Void {
        do {
            if let jsonData = data {
                let parseData = try JSONDecoder().decode([limit].self, from: jsonData)
                minLimit = parseData[0].value
                maxLimit = parseData[1].value
            }
        } catch {
            print("Parse Error: \(error)")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards1.cards1.count
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete  {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
             let managedContext = appDelegate.persistentContainer.viewContext
             
             let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cards")
            fetchRequest.predicate = NSPredicate(format: "id = %@", cards1.cards1[indexPath.row].product_id)
             do {
                 let test = try managedContext.fetch(fetchRequest)
                 let objectToDelete = test[0] as! NSManagedObject
                 managedContext.delete(objectToDelete)
                 do {
                     try managedContext.save()
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cards")
                    do {
                        let result = try managedContext.fetch(fetchRequest)
                            unitInt = "Ürün Sayısı: \(result.count)"
                            total.text = "Toplam: 0₺"
                            totalInt = 0
                            for data in result as! [NSManagedObject] {
                                let price = Double(data.value(forKey: "price") as! String)
                                let qty = Double(data.value(forKey: "qty") as! String)
                                totalInt += price! * qty!
                            }
                            total.text = "Toplam: \(Double(round(100*totalInt)/100))₺"
                    } catch {
                        print("Failed")
                    }
                 } catch {
                     print(error)
                 }
             } catch {
                 print(error)
             }
            cards1.cards1.remove(at: indexPath.row)
            cardTable.deleteRows(at: [indexPath], with: .left)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = cardTable.dequeueReusableCell(withIdentifier: "card", for: indexPath) as? productsTableViewCell
        tableCell?.cellDelegate = self
        tableCell?.index = indexPath
        tableCell?.layer.cornerRadius = 6.0
        tableCell?.layer.borderWidth = 0.5
        let myColor = UIColor.lightGray.cgColor
        tableCell?.layer.borderColor = myColor
        if let productName = tableCell?.viewWithTag(502) as? UILabel {
            productName.text = cards1.cards1[indexPath.row].name
        }
        if let productName = tableCell?.viewWithTag(600) as? UILabel {
            productName.text = String(cards1.cards1[indexPath.row].price) + "₺"
        }
        if let productName = tableCell?.viewWithTag(500) as? UILabel {
            productName.text = cards1.cards1[indexPath.row].qty
            productName.layer.cornerRadius = 8.0
        }
        if let productName = tableCell?.viewWithTag(503) as? UILabel {
            let q = Double(cards1.cards1[indexPath.row].qty)
            let p = Double(cards1.cards1[indexPath.row].price)
            let t = p! * q!
            productName.text = "Toplam: \(Double(round(100*t)/100))₺"
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
        let imageUrl = URL(string: "https://amasyaceliklermarket.com" + String(cards1.cards1[indexPath.row].image))
        if let productImage = tableCell?.viewWithTag(501) as? UIImageView {
            productImage.sd_setImage(with: imageUrl, placeholderImage: placeHolderImage, options: SDWebImageOptions.highPriority, context: nil)
        }
        return (tableCell)!
    }
}

struct shoppingCards: Codable {
    var name: String
    var product_id: String
    var price: String
    var qty: String
    var unit: String
    var unit_value: String
    var image: String
}

struct card: Codable {
    var product_id: String
    var price: String
    var qty: String
    var unit: String
    var unit_value: String
}

class cardProduct {
    var cards1: [shoppingCards]
    
    init(cards: [shoppingCards]) {
        cards1 = cards
    }
}
