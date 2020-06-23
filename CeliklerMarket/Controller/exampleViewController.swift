//
//  exampleViewController.swift
//  CeliklerMarket
//
//  Created by Ahmet Yusuf TOĞTAY on 20.06.2020.
//  Copyright © 2020 OzguRND. All rights reserved.
//

import UIKit

class exampleViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    var _selectedIndexPath : IndexPath? = nil
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        if ((_selectedIndexPath) != nil){
            if indexPath.compare(_selectedIndexPath!) == ComparisonResult.orderedSame {
                _selectedIndexPath = nil;
            } else {
                _selectedIndexPath = indexPath
            }
        } else {
            _selectedIndexPath = indexPath;
        }
        collectionView.reloadItems(at: collectionView.indexPathsForVisibleItems)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "cat", for: indexPath)
        if let productName = cell2.viewWithTag(88) as? UILabel {
            productName.text = items[indexPath.row]
        }
        if _selectedIndexPath == indexPath{
            cell2.isSelected = true
            cell2.backgroundColor = UIColor.white
        } else {
            cell2.isSelected=false
            cell2.backgroundColor = UIColor.clear
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let url = URL(string: "https://amasyaceliklermarket.com/api/category_alt/" + "87")
        ApiService.callGet(url: url!, finish: subCategoryFunc)
    }
    
    func subCategoryFunc(message:String, data:Data?) -> Void
    {
        do
        {
            if let jsonData = data
            {
                items.removeAll()
                subCategory = try JSONDecoder().decode([subCategoryStruct].self, from: jsonData)
                for i in subCategory {
                    if i.status != "0"  {
                        items.append(i.title)
                    }
                }
                DispatchQueue.main.async {
                    self.cat.reloadData()
                }
            }
        }
        catch
        {
            print("Parse Error: \(error)")
        }
    }
    
    @IBOutlet weak var cat: UICollectionView!
       

       override func viewDidLoad() {
           super.viewDidLoad()
           self.cat.delegate = self
           self.cat.dataSource = self
           self.cat.layer.cornerRadius = 6.0
           // Do any additional setup after loading the view.
       }
       var subCategory: [subCategoryStruct] = []
       var items: [String] = []

}
