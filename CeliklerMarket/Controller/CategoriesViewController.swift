//
//  mainViewController.swift
//  CeliklerMarket
//
//  Created by Ahmet Yusuf TOĞTAY on 13.05.2020.
//  Copyright © 2020 OzguRND. All rights reserved.
//

import UIKit
import CoreData
import SDWebImage

class categoriesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, productCell{
    func onClickImage(indexPath: IndexPath) {
        print("indexpath")
    }
    
    func onClickCell(index: Int, unit: String, indexPath: IndexPath) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        var id = ""
        var price = ""
        var unitt = ""
        var unit_value = ""
        var image = ""
        var name = ""
        if searching {
            let searchData = searchBarText[index]
            for i in searchProductData {
                if i.product_name == searchData {
                    id = i.product_id
                    price = i.price
                    unitt = i.unit
                    unit_value = i.unit_value
                    image = i.product_image
                    name = i.product_name
                }
            }
            if "\(unit)" != "0" {
                let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Cards")
                fetchRequest.predicate = NSPredicate(format: "id = %@", searchProductData[index].product_id)
                do {
                    let test = try context.fetch(fetchRequest)
                    if test.count != 0 {
                        let objectUpdate = test[0] as! NSManagedObject
                        objectUpdate.setValue(id, forKeyPath: "id")
                        objectUpdate.setValue(price, forKeyPath: "price")
                        objectUpdate.setValue(unit, forKeyPath: "qty")
                        objectUpdate.setValue(unitt, forKeyPath: "unit")
                        objectUpdate.setValue(unit_value, forKeyPath: "unit_value")
                        objectUpdate.setValue(image, forKeyPath: "image")
                        objectUpdate.setValue(name, forKeyPath: "name")
                        do {
                            try context.save()
                            
                        } catch {
                            print(error)
                        }
                    } else {
                        let newCard = NSEntityDescription.insertNewObject(forEntityName: "Cards", into: context)
                        newCard.setValue(id, forKeyPath: "id")
                        newCard.setValue(price, forKeyPath: "price")
                        newCard.setValue(unit, forKeyPath: "qty")
                        newCard.setValue(unitt, forKeyPath: "unit")
                        newCard.setValue(unit_value, forKeyPath: "unit_value")
                        newCard.setValue(image, forKeyPath: "image")
                        newCard.setValue(name, forKeyPath: "name")
                        do {
                            try context.save()
                        } catch {
                            print(error)
                        }
                    }
                } catch  {
                    print(error)
                }
            }
        } else {
            if "\(unit)" != "0" {
                let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Cards")
                fetchRequest.predicate = NSPredicate(format: "id = %@", searchProductData[index].product_id)
                do {
                    let test = try context.fetch(fetchRequest)
                    if test.count != 0 {
                        let objectUpdate = test[0] as! NSManagedObject
                        objectUpdate.setValue((searchProductData[index].product_id), forKeyPath: "id")
                        objectUpdate.setValue(searchProductData[index].price, forKeyPath: "price")
                        objectUpdate.setValue(unit, forKeyPath: "qty")
                        objectUpdate.setValue(searchProductData[index].unit, forKeyPath: "unit")
                        objectUpdate.setValue(searchProductData[index].unit_value, forKeyPath: "unit_value")
                        objectUpdate.setValue(searchProductData[index].product_image, forKeyPath: "image")
                        objectUpdate.setValue(searchProductData[index].product_name, forKeyPath: "name")
                        do {
                            try context.save()
                            
                        } catch {
                            print(error)
                        }
                    } else {
                        let newCard = NSEntityDescription.insertNewObject(forEntityName: "Cards", into: context)
                        newCard.setValue((searchProductData[index].product_id), forKeyPath: "id")
                        newCard.setValue(searchProductData[index].price, forKeyPath: "price")
                        newCard.setValue(unit, forKeyPath: "qty")
                        newCard.setValue(searchProductData[index].unit, forKeyPath: "unit")
                        newCard.setValue(searchProductData[index].unit_value, forKeyPath: "unit_value")
                        newCard.setValue(searchProductData[index].product_image, forKeyPath: "image")
                        newCard.setValue(searchProductData[index].product_name, forKeyPath: "name")
                        do {
                            try context.save()
                        } catch {
                            print(error)
                        }
                    }
                } catch  {
                    print(error)
                }
            }
        }
        
    }
  
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewCell2: UICollectionView!
    @IBOutlet weak var searchTable: UITableView!
    
    let placeHolderImage = UIImage(named: "V1")
    var sliderImageArray = [UIImage?]()
    var categoriesImage = [UIImage?]()
    var categoriesLabel = [String?]()
    var categoriesID = [String?]()
    var timer = Timer()
    var counter = 0
    var subCategoryID = 0
    var searchProductData: [searchProduct] = []
    var searchBarText = [String]()
    var productName = [String]()
    var searching = false
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        super.viewDidLoad()
        self.collectionViewCell2.delegate = self
        seprcialButton.layer.cornerRadius = 6.0
        searchTable.isHidden = true
        sliderViewDidLoad()
        categories()
        search()
        if let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton {
            cancelButton.setTitle("İptal Et", for: .normal)
        }
    }
    
    
    @IBAction func specialOrderButton(_ sender: Any) {
        performSegue(withIdentifier: "goSpecialOrder", sender: nil)
    }
    
    @objc func doSomething(refreshControl: UIRefreshControl) {
        categories()
        refreshControl.endRefreshing()
    }
    
    /*func selectCategory()   {
        let selectItem = collectionViewCell2.indexPathsForSelectedItems?.last ?? IndexPath(item: 0, section: 0)
    }*/
    
    @objc func hideKeyboard()   {
        view.endEditing(true)
    }
    
    @IBOutlet weak var seprcialButton: UIButton!
    
    func sliderViewDidLoad()    {
        sliderImageArray.removeAll()
        if let url = URL(string: "https://amasyaceliklermarket.com/api/slider") {
           URLSession.shared.dataTask(with: url) { data, response, error in
              if let data = data {
                  do {
                    let res = try JSONDecoder().decode([sliderImage].self, from: data)
                    for re in res {
                        let baseurl = "https://amasyaceliklermarket.com"
                        let url = URL(string: (baseurl + re.slider_url))
                        URLSession.shared.dataTask(with: url!) { data, response, error in
                            if error != nil {
                                print(error!)
                            }
                            DispatchQueue.main.async{
                                self.sliderImageArray.append(UIImage(data: data!)!)
                                self.collectionView.reloadData()
                            }
                        }.resume()
                    }
                  } catch let error {
                     print(error)
                  }
               }
           }.resume()
        }
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        }
    }
    
    func categories()   {
        categoriesImage.removeAll()
        categoriesLabel.removeAll()
        categoriesID.removeAll()
        collectionViewCell2.reloadData()
        if let url = URL(string: "https://amasyaceliklermarket.com/api/category_all") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                   do {
                    let res = try JSONDecoder().decode([category].self, from: data)
                    for r in res   {
                        if r.status != "0"  {
                            let baseurl = "https://amasyaceliklermarket.com"
                            let url = URL(string: (baseurl + r.image))
                            URLSession.shared.dataTask(with: url!) { data, response, error in
                                if error != nil {
                                    print(error!)
                                }
                                DispatchQueue.main.async{
                                    self.categoriesImage.append(UIImage(data: data!)!)
                                    self.categoriesLabel.append(r.title)
                                    self.categoriesID.append(r.id)
                                    self.collectionViewCell2.reloadData()
                                }
                            }.resume()
                        }
                    }
                   } catch let error {
                      print(error)
                   }
                }
            }.resume()
        }
    }
    
    func search() {
        if let url = URL(string: "https://amasyaceliklermarket.com/api/product_all") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                   do {
                    self.searchProductData.removeAll()
                    self.searchProductData = try JSONDecoder().decode([searchProduct].self, from: data)
                    for i in self.searchProductData  {
                        self.productName.append(i.product_name)
                    }
                    DispatchQueue.main.async {
                        self.searchTable.reloadData()
                    }
                   } catch let error {
                      print(error)
                   }
                }
            }.resume()
        }
    }
    
    @objc func changeImage() {
        if counter < sliderImageArray.count {
            let index = IndexPath.init(item: counter, section: 0)
            self.collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            counter += 1
        } else {
            counter = 0
            let index = IndexPath.init(item: counter, section: 0)
            self.collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
            counter = 1
        }
    }
    
    func downloadSliderImage(with url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                print(error!)
            }
            DispatchQueue.main.async{
                self.sliderImageArray.append(UIImage(data: data!)!)
            }
        }.resume()
    }
    
    @IBAction func cellTapped(deneme: Int)   {
        subCategoryID = Int(categoriesID[deneme]!)!
        performSegue(withIdentifier: "go", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "go" {
            let destination = segue.destination as! subCategoryViewController
            destination.subCategoryID = categoriesID
            destination.subCategoryIndex = subCategoryID
        }
        if segue.identifier == "geSearchDetail" {
            let destination = segue.destination as! productDetailsViewController
            destination.image = image
            destination.details = details
            destination.productid = productid
            destination.name = name
            destination.product_unit = product_unit
            destination.unit_value = unit_value
            destination.price = price
            destination.qtyy = qty
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionViewCell2    {
            cellTapped(deneme: indexPath.row)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           if collectionView == collectionViewCell2    {
               return categoriesLabel.count
           }
           return sliderImageArray.count
    }
       
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewCell2    {
            let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath)
            if let vcImage = cell2.viewWithTag(453) as? UIImageView {
                vcImage.image = categoriesImage[indexPath.row]
            }
            if let vcLabel = cell2.viewWithTag(456) as? UILabel {
                vcLabel.text = categoriesLabel[indexPath.row]
            }
            let myColor = UIColor.lightGray.cgColor
            cell2.layer.borderColor = myColor
            cell2.layer.cornerRadius = 6.0
            cell2.layer.borderWidth = 1.0
            
            return cell2
        }
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
           if let vc = cell.viewWithTag(111) as? UIImageView {
               vc.image = sliderImageArray[indexPath.row]
           }
           return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionViewCell2 == collectionView    {
            return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        }
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionViewCell2 == collectionView    {
            let screenWidth = UIScreen.main.bounds.width
            let size = (screenWidth-40)/3
            return CGSize.init(width: size, height: size)
        }
        let size = collectionView.frame.size
        return CGSize(width: size.width, height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionViewCell2 == collectionView    {
            return 0.0
        }
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionViewCell2 == collectionView    {
            return 0.0
        }
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchBarText.count
        } else {
            return searchProductData.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searching {
            let searchData = searchBarText[indexPath.row]
            for i in searchProductData {
                if i.product_name == searchData {
                    image = i.product_image
                    name = i.product_name
                    productid = i.product_id
                    details = i.product_description
                    product_unit = i.unit
                    unit_value = i.unit_value
                    price = i.price
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
                                    if i.unit == "kg" {
                                        qty = "0.0"
                                    } else {
                                        qty = "0"
                                    }
                                }
                            }
                        } else {
                            if i.unit == "kg" {
                                qty = "0.0"
                            } else {
                                qty = "0"
                            }
                        }
                    } catch {
                        print("Failed")
                    }
                    performSegue(withIdentifier: "geSearchDetail", sender: nil)
                } else {
                    print("deneme")
                }
            }
        } else {
            image = searchProductData[indexPath.row].product_image
            name = searchProductData[indexPath.row].product_name
            productid = searchProductData[indexPath.row].product_id
            details = searchProductData[indexPath.row].product_description
            product_unit = searchProductData[indexPath.row].unit
            unit_value = searchProductData[indexPath.row].unit_value
            price = searchProductData[indexPath.row].price
            if searchProductData[indexPath.row].unit == "kg" {
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
                            if searchProductData[indexPath.row].unit == "kg" {
                                qty = "0.0"
                            } else {
                                qty = "0"
                            }
                        }
                    }
                } else {
                    print(searchProductData[indexPath.row].unit)
                    if searchProductData[indexPath.row].unit == "kg" {
                        qty = "0.0"
                    } else {
                        qty = "0"
                    }
                }
            } catch {
                print("Failed")
            }
            performSegue(withIdentifier: "geSearchDetail", sender: nil)
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = searchTable.dequeueReusableCell(withIdentifier: "searchTable", for: indexPath) as? productsTableViewCell
        tableCell?.layer.cornerRadius = 6.0
        tableCell?.layer.borderWidth = 0.5
        let myColor = UIColor.lightGray.cgColor
        tableCell!.layer.borderColor = myColor
        tableCell?.cellDelegate = self
        tableCell?.index = indexPath
        if searching {
            let searchData = searchBarText[indexPath.row]
            if let productImage = tableCell?.viewWithTag(501) as? UIImageView {
                for i in searchProductData {
                    if i.product_name == searchData {
                        let uri = URL(string: "https://amasyaceliklermarket.com" + String(i.product_image))
                        productImage.sd_setImage(with: uri, placeholderImage: placeHolderImage, options: SDWebImageOptions.highPriority, context: nil)
                    }
                }
            }
            if let productName = tableCell?.viewWithTag(600) as? UILabel {
                productName.text = searchBarText[indexPath.row]
            }
            
            if let productName = tableCell?.viewWithTag(502) as? UILabel {
                for i in searchProductData {
                    if i.product_name == searchData {
                        productName.text = String(i.price) + "₺"
                    }
                }
            }
            if let productName = tableCell?.viewWithTag(508) as? UILabel {
                for i in searchProductData {
                    if i.product_name == searchData {
                        if i.unit == "kg" {
                            productName.text = "0.0"
                        } else {
                            productName.text = "0"
                        }
                    }
                }
            }
        } else {
            if let productName = tableCell?.viewWithTag(600) as? UILabel {
                productName.text = searchProductData[indexPath.row].product_name
            }
            if let productName = tableCell?.viewWithTag(502) as? UILabel {
                productName.text = String(searchProductData[indexPath.row].price) + "₺"
            }
            if let productName = tableCell?.viewWithTag(508) as? UILabel {
                if searchProductData[indexPath.row].unit == "kg" {
                    productName.text = "0.0"
                } else {
                    productName.text = "0"
                }
            }
            let imageUrl = URL(string: "https://amasyaceliklermarket.com" + String(searchProductData[indexPath.row].product_image))
            if let productImage = tableCell?.viewWithTag(501) as? UIImageView {
                productImage.sd_setImage(with: imageUrl, placeholderImage: placeHolderImage, options: SDWebImageOptions.highPriority, context: nil)
                productImage.isUserInteractionEnabled = true
            }
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
        return tableCell!
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchTable.isHidden = false
        seprcialButton.isHidden = true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.resignFirstResponder()
        return true
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchTextLower = searchText.lowercased()
        searchBarText = productName.filter({$0.lowercased().prefix(searchText.count) == searchTextLower})
        searching = true
        searchTable.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchTable.isHidden = true
        seprcialButton.isHidden = false
        self.searchBar.endEditing(true)
    }
    struct searchProduct: Codable {
        let product_id, product_name, product_description, product_image: String
        let category_id, in_stock, price, unit_value: String
        let unit, rewards, tax: String
    }
}
