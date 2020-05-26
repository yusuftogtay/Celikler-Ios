//
//  subViewController.swift
//  CeliklerMarket
//
//  Created by Ahmet Yusuf TOĞTAY on 15.05.2020.
//  Copyright © 2020 OzguRND. All rights reserved.
//

import UIKit

class SubViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,
ProductCollectionView, UICollectionViewDelegateFlowLayout {
     

    var subCategory = [String?]()
    var subCategoryIndex = 0
    @IBOutlet weak var cell: UICollectionViewCell!
    
    var subCategoryImage = [UIImage?]()
    var subCategoryID = [String]()
    var subCategoryTitle = [String?]()
    var subCategoryStatus = [String?]()
    
    var productID = [String?]()
    var productName = [String?]()
    var productDescription = [String?]()
    var productImage = [UIImage?]()
    var productCategoryID = [String?]()
    var productInStock = [String?]()
    var productPrice = [String?]()
    var productUnitValue = [String?]()
    var productUnit = [String?]()
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryCollection: UICollectionView!
    
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeLeft = UISwipeGestureRecognizer()
        let swipeRight = UISwipeGestureRecognizer()
        
        swipeLeft.direction = .left
        swipeRight.direction = .right
        
        categoryCollection.addGestureRecognizer(swipeRight)
        categoryCollection.addGestureRecognizer(swipeLeft)
        
        swipeRight.addTarget(self, action: #selector(self.swipe(sender:)))
        swipeLeft.addTarget(self, action: #selector(self.swipe(sender:)))
        getSubCategory(with: subCategoryIndex)
        
        var swipe : Bool? = UserDefaults.standard.bool(forKey: "swipeControl")
        if swipe == nil {
            UserDefaults.standard.set(true, forKey: "swipeControl")
            UserDefaults.standard.synchronize()
            swipe = UserDefaults.standard.bool(forKey: "swipeControl")
            if swipe != false{
                swipeAlert()
                UserDefaults.standard.set(false, forKey: "swipeControl")
            }
        }
        
    }
    func swipeAlert()   {
        let alert = UIAlertController(title: "", message: "Kategoriler Arasında Gezmek İçin Sağa veya Sola Kaydırın", preferredStyle: .alert)
        
        let image = UIImage(named: "swipeGif")
        

        let action = UIAlertAction(title: "Tamam", style: .default, handler: nil)
        action.setValue(image, forKey: "image")
        alert.addAction(action)
        
        let backButton = UIBarButtonItem(title: "Custom", style: .plain, target: self, action: nil)
        navigationItem.setLeftBarButton(backButton, animated: false)
        
        
        self.present(alert, animated: true, completion: nil)
        UserDefaults.standard.removeObject(forKey: "firstLog")
    }
    @IBOutlet weak var navigation: UINavigationBar!
    @IBOutlet weak var navigationTitle: UINavigationItem!
    
    @objc func backAction(){
        //print("Back Button Clicked")
        dismiss(animated: true, completion: nil)
    }
    func getSubCategory(with id : Int)   {
        if let url = URL(string: "https://amasyaceliklermarket.com/api/category_alt/" + String(id)) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                let urlResponse = response as? HTTPURLResponse
                if urlResponse?.statusCode == 200   {
                    if let data = data {
                        do {
                            let res = try JSONDecoder().decode([subCategoryStruct].self, from: data)
                            for i in res    {
                                if i.status == "1"  {
                                        DispatchQueue.main.async{
                                            self.subCategoryID.append(i.id)
                                            self.subCategoryTitle.append(i.title)
                                            self.categoryCollection.reloadData()
                                            self.navigationTitle?.title = i.title
                                        }
                                }
                            }
                            DispatchQueue.main.sync {
                                self.getProduct(with: Int(self.subCategoryID[0])!)
                                self.categoryLabel.text! = self.subCategoryTitle[0]!
                            }
                        } catch let error {
                            print(error)
                        }
                    }
                }
            }.resume()
        }
    }
    
    func getProduct(with id: Int)   {
        self.productID.removeAll()
        self.productName.removeAll()
        self.productInStock.removeAll()
        self.productPrice.removeAll()
        self.productUnitValue.removeAll()
        self.productUnit.removeAll()
        self.productImage.removeAll()
        self.categoryCollection.reloadData()
        if let url = URL(string: "https://amasyaceliklermarket.com/api/product/" + String(id)) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                    if let data = data {
                        do {
                            let res = try JSONDecoder().decode([product].self, from: data)
                                for i in res    {
                                    let baseurl = "https://amasyaceliklermarket.com"
                                    let url = URL(string: (baseurl + i.product_image))
                                    print(url as Any)
                                    URLSession.shared.dataTask(with: url!) { data, response, error in
                                        if error != nil {
                                            print(error!)
                                        }
                                        DispatchQueue.main.async{
                                            self.productID.append(i.product_id)
                                            self.productName.append(i.product_name)
                                            self.productInStock.append(i.in_stock)
                                            self.productPrice.append(i.price)
                                            self.productUnitValue.append(i.unit_value)
                                            self.productUnit.append(i.unit)
                                            self.productImage.append(UIImage(data: data!)!)
                                            self.categoryCollection.reloadData()
                                        }
                                    }.resume()
                            }
                        } catch let error {
                            print(error)
                        }
                    }
            }.resume()
        }
    }
    
    func oneClickCell(index: Int, unit: String) {
        button.titleLabel?.text = "sdbvşdfsbşdkfb"
    }
    
    @objc func swipe(sender: UISwipeGestureRecognizer)  {
        switch sender.direction {
        case .left:
            if subCategoryTitle.count > 0   {
                counter = (counter + 1) % subCategoryTitle.count
                categoryLabel.text! = subCategoryTitle[counter]!
                getProduct(with: Int(subCategoryID[counter])!)
            }
        case .right:
            if subCategoryTitle.count > 0   {
                counter = (counter + 1) % (subCategoryTitle.count)
                categoryLabel.text! = subCategoryTitle[((subCategoryTitle.count - counter) % subCategoryTitle.count)]!
                getProduct(with: Int(subCategoryID[((subCategoryTitle.count - counter) % subCategoryTitle.count)])!)
            }
        default:
            categoryLabel.text = ""
        }
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productID.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ProductCollectionViewCell
        if let vcImage = cell?.viewWithTag(123) as? UIImageView {
            vcImage.image = productImage[indexPath.row]
        }
        if let vcTitle = cell?.viewWithTag(124) as? UILabel    {
            vcTitle.text = productName[indexPath.row]
        }
        if let vcTotal = cell?.viewWithTag(125) as? UILabel      {
            vcTotal.text = "Toplam: 0.0₺"
        }
        if let vcPrice = cell?.viewWithTag(156) as? UILabel      {
            vcPrice.text = (productPrice[indexPath.row]! + "₺")
        }
        cell?.cellDelegate = self
        cell?.index = indexPath
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
