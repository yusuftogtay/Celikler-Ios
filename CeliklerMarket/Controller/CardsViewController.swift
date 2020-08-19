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
    
    func onClickImage(indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Çok ram yiyor")
    }
    
    final func onClickCell(index: Int, unit: String, indexPath: IndexPath) {
        let id = cards[index].product_id
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let context = appDelegate.persistentContainer.viewContext
            if unit != "0" {
                let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Cards")
                fetchRequest.predicate = NSPredicate(format: "id = %@", id)
                do {
                    let test = try context.fetch(fetchRequest)
                    if test.count != 0 {
                        let objectUpdate = test[0] as! NSManagedObject
                        objectUpdate.setValue(self.cards[index].product_id, forKeyPath: "id")
                        objectUpdate.setValue(self.cards[index].price, forKeyPath: "price")
                        objectUpdate.setValue(unit, forKeyPath: "qty")
                        objectUpdate.setValue(self.cards[index].unit, forKeyPath: "unit")
                        objectUpdate.setValue(self.cards[index].unit_value, forKeyPath: "unit_value")
                        objectUpdate.setValue(self.cards[index].image, forKeyPath: "image")
                        objectUpdate.setValue(self.cards[index].name, forKeyPath: "name")
                        do {
                            try context.save()
                        } catch {
                            print(error)
                        }
                    } else {
                        let newCard = NSEntityDescription.insertNewObject(forEntityName: "Cards", into: context)
                        newCard.setValue(self.cards[index].product_id, forKeyPath: "id")
                        newCard.setValue(self.cards[index].price, forKeyPath: "price")
                        newCard.setValue(unit, forKeyPath: "qty")
                        newCard.setValue(self.cards[index].unit, forKeyPath: "unit")
                        newCard.setValue(self.cards[index].unit_value, forKeyPath: "unit_value")
                        newCard.setValue(self.cards[index].image, forKeyPath: "image")
                        newCard.setValue(self.cards[index].name, forKeyPath: "name")
                        do {
                            try context.save()
                        } catch {
                            print(error)
                        }
                    }
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cards")
                    do {
                        let result = try context.fetch(fetchRequest)
                        self.unitInt = "Ürün Sayısı: \(result.count)"
                        self.total.text = "Toplam: 0₺"
                        self.totalInt = 0
                        for data in result as! [NSManagedObject] {
                            let price = Double(data.value(forKey: "price") as! String)
                            let qty = Double(data.value(forKey: "qty") as! String)
                            self.totalInt += price! * qty!
                        }
                        self.total.text = "Toplam: \(Double(round(100 * self.totalInt)/100))₺"
                    } catch {
                        #if DEBUG
                            print(error)
                        #endif
                    }
                } catch  {
                    #if DEBUG
                        print(error)
                    #endif
                }
            } else {
                print("ggg")
                self.editingStyleDelete(indexPath: indexPath)
                /*guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                let managedContext = appDelegate.persistentContainer.viewContext
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cards")
                fetchRequest.predicate = NSPredicate(format: "id = %@", self.cards1.cards1[index].product_id)
                 do {
                    let test = try managedContext.fetch(fetchRequest)
                    let objectToDelete = test[0] as! NSManagedObject
                    managedContext.delete(objectToDelete)
                    self.unit.text = self.unitInt
                    do {
                        try managedContext.save()
                        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cards")
                        do {
                                let result = try managedContext.fetch(fetchRequest)
                                self.unitInt = "Ürün Sayısı: \(result.count)"
                                self.total.text = "Toplam: 0₺"
                                self.totalInt = 0
                                if let tabItems = self.tabBarController?.tabBar.items {
                                    let tabItem = tabItems[1]
                                    let badege = String(result.count)
                                    tabItem.badgeValue = badege
                                }
                                for data in result as! [NSManagedObject] {
                                    let price = Double(data.value(forKey: "price") as! String)
                                    let qty = Double(data.value(forKey: "qty") as! String)
                                    self.totalInt += price! * qty!
                                }
                                self.total.text = "Toplam: \(Double(round(100 * self.totalInt)/100))₺"
                            } catch {
                                print("Failed")
                            }
                        }
                        catch {
                            print(error)
                        }
                 } catch {
                     print(error)
                 }
                self.cards1.cards1.remove(at: indexPath.row)
                self.cardTable.deleteRows(at: [indexPath], with: .left)
                self.cardTable.reloadData()*/
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
    var cards: [shoppingCards] = []
    var minLimit = "50"
    var maxLimit = "500"
    //var cards1 = cardProduct(cards: [shoppingCards]())
    var check = false
    
    
    let placeHolderImage = UIImage(named: "V1")
    

    @IBAction func payDone(_ sender: Any) {
        DispatchQueue.main.async {
            let user : String? =  UserDefaults.standard.string(forKey: "username")
            if user != nil  {
                if self.totalInt < Double(self.minLimit)! {
                    let alert = UIAlertController(title: "Minimum Sipariş Limiti", message: "Minimum Sipariş Tutarı \(self.minLimit)₺ dir.", preferredStyle: .alert)

                    let action = UIAlertAction(title: "Tamam", style: .default, handler: nil)
                    alert.addAction(action)
                    
                    self.present(alert, animated: true, completion: nil)
                } else if self.totalInt > Double(self.maxLimit)! {
                    let alert = UIAlertController(title: "Maximum Sipariş Limiti", message: "Maximum Sipariş Tutarı \(self.maxLimit)₺ dir.", preferredStyle: .alert)

                    let action = UIAlertAction(title: "Tamam", style: .default, handler: nil)
                    alert.addAction(action)
                    
                    self.present(alert, animated: true, completion: nil)
                } else {
                    self.performSegue(withIdentifier: "goPay", sender: nil)
                }
            } else {
                let alert = UIAlertController(title: "Oturum Aç", message: "Sipariş verbilmeniz için oturum açmanız gerekmektedir.", preferredStyle: .alert)

                let action = UIAlertAction(title: "Tamam", style: .default, handler: { (action: UIAlertAction!) in
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "gologin", sender: nil)
                    }
                })
                
                let cancel = UIAlertAction(title: "İptal Et", style: .cancel, handler: nil)
                alert.addAction(action)
                alert.addAction(cancel)
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func deleteAllItems(_ sender: Any) {
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cards")
            if let result = try? managedContext.fetch(fetchRequest) {
                for object in result {
                    managedContext.delete(object as! NSManagedObject)
                }
                do {
                    try managedContext.save()
                    if let tabItems = self.tabBarController?.tabBar.items {
                        let tabItem = tabItems[1]
                        tabItem.badgeValue = "0"
                    }
                } catch {
                    #if DEBUG
                        print(error)
                    #endif
                }
            }
        }
        //cards1.cards1.removeAll()
        cards.removeAll()
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
        getCards()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //cards1.cards1.removeAll()
        //cards.removeAll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getCards()
        let url = URL(string: "https://amasyaceliklermarket.com/api/get_limit_settings")
        ApiService.callGet(url: url!, finish: limitResponse)
    }
    
    func getCards() {
        //DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cards")
            do {
                let result = try managedContext.fetch(fetchRequest)
                if result.count != 0 {
                    self.cardsImage.isHidden = true
                    self.cardsInfo.isHidden = true
                    self.cardClear.isHidden = false
                    self.cardTable.isHidden = false
                    self.infoStack.isHidden = false
                    self.payDone.isHidden = false
                    self.unitInt = "Ürün Sayısı: \(result.count)"
                    self.unit.text = self.unitInt
                    self.total.text = "Toplam: 0₺"
                    self.totalInt = 0
                    //self.cards1.cards1.removeAll()
                    self.cards.removeAll()
                    for data in result as! [NSManagedObject] {
                        print(data.value(forKey: "id") as! String + "iddd")
                        self.cards.append(shoppingCards(name: data.value(forKey: "name") as! String,
                        product_id: data.value(forKey: "id") as! String,
                        price: data.value(forKey: "price") as! String,
                        qty: data.value(forKey: "qty") as! String,
                        unit: data.value(forKey: "unit") as! String,
                        unit_value: data.value(forKey: "unit_value") as! String,
                        image: data.value(forKey: "image") as! String))
                        /*self.cards1.cards1.append(shoppingCards(name: data.value(forKey: "name") as! String,
                                                    product_id: data.value(forKey: "id") as! String,
                                                    price: data.value(forKey: "price") as! String,
                                                    qty: data.value(forKey: "qty") as! String,
                                                    unit: data.value(forKey: "unit") as! String,
                                                    unit_value: data.value(forKey: "unit_value") as! String,
                                                    image: data.value(forKey: "image") as! String))*/
                        let price = Double(data.value(forKey: "price") as! String)
                        let qty = Double(data.value(forKey: "qty") as! String)
                        self.totalInt += price! * qty!
                    }
                    self.total.text = "Toplam: \(Double(round(100*self.totalInt)/100))₺"
                    self.cardTable.reloadData()
                    self.check = true
                } else {
                    self.cardsImage.isHidden = false
                    self.cardsInfo.isHidden = false
                    self.cardClear.isHidden = true
                    self.cardTable.isHidden = true
                    self.infoStack.isHidden = true
                    self.payDone.isHidden = true
                }
            } catch {
                #if DEBUG
                    print(error)
                #endif
            }
        //}
    }
    
    private func limitResponse(message:String, data:Data?) -> Void {
        do {
            if let jsonData = data {
                let parseData = try JSONDecoder().decode([limit].self, from: jsonData)
                minLimit = parseData[0].value
                maxLimit = parseData[1].value
            }
        } catch {
            #if DEBUG
                print(error)
            #endif
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return cards1.cards1.count
        return cards.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete  {
            editingStyleDelete(indexPath: indexPath)
            self.unit.text = unitInt
            
        }
    }
    
    func editingStyleDelete(indexPath: IndexPath)   {
        DispatchQueue.main.async {
             guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
             let managedContext = appDelegate.persistentContainer.viewContext
             let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cards")
            //fetchRequest.predicate = NSPredicate(format: "id = %@", self.cards1.cards1[indexPath.row].product_id)
            fetchRequest.predicate = NSPredicate(format: "id = %@", self.cards[indexPath.row].product_id)
             do {
                 let test = try managedContext.fetch(fetchRequest)
                 let objectToDelete = test[0] as! NSManagedObject
                 managedContext.delete(objectToDelete)
                 do {
                    try managedContext.save()
                 } catch {
                     #if DEBUG
                         print(error)
                     #endif
                 }
             } catch {
                 #if DEBUG
                     print(error)
                 #endif
             }
            do {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cards")
                let result = try managedContext.fetch(fetchRequest)
                self.unitInt = "Ürün Sayısı: \(result.count)"
                self.total.text = "Toplam: 0₺"
                self.totalInt = 0
                if let tabItems = self.tabBarController?.tabBar.items {
                    // In this case we want to modify the badge number of the third tab:
                    let tabItem = tabItems[1]
                    let badege = String(result.count)
                    tabItem.badgeValue = badege
                }
                    for data in result as! [NSManagedObject] {
                        let price = Double(data.value(forKey: "price") as! String)
                        let qty = Double(data.value(forKey: "qty") as! String)
                        self.totalInt += price! * qty!
                    }
                self.total.text = "Toplam: \(Double(round(100 * self.totalInt)/100))₺"
                //self.unitInt = "Ürün Sayısı: \(result.count - 1)"
                self.unit.text = "Ürün Sayısı: \(result.count)"
                //self.cards1.cards1.remove(at: indexPath.row)
                self.cards.remove(at: indexPath.row)
                self.cardTable.deleteRows(at: [indexPath], with: .left)
            } catch {
                #if DEBUG
                    print(error)
                #endif
            }
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
        if let productName = tableCell?.viewWithTag(600) as? UILabel {
            //productName.text = cards1.cards1[indexPath.row].name
            productName.text = cards[indexPath.row].name
        }
        if let productName = tableCell?.viewWithTag(502) as? UILabel {
            //productName.text = String(cards1.cards1[indexPath.row].price) + "₺"
            productName.text = String(cards[indexPath.row].price) + "₺"
        }
        if let productName = tableCell?.viewWithTag(508) as? UILabel {
            //productName.text = cards1.cards1[indexPath.row].qty
            productName.text = cards[indexPath.row].qty
            productName.layer.cornerRadius = 8.0
        }
        if let productName = tableCell?.viewWithTag(503) as? UILabel {
            //let q = Double(cards1.cards1[indexPath.row].qty)
            let q = Double(cards[indexPath.row].qty)
            //let p = Double(cards1.cards1[indexPath.row].price)
            let p = Double(cards[indexPath.row].price)
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
        //let imageUrl = URL(string: "https://amasyaceliklermarket.com" + String(cards1.cards1[indexPath.row].image))
        let imageUrl = URL(string: "https://amasyaceliklermarket.com" + String(cards[indexPath.row].image))
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
