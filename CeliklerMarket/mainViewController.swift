//
//  mainViewController.swift
//  CeliklerMarket
//
//  Created by Ahmet Yusuf TOĞTAY on 13.05.2020.
//  Copyright © 2020 OzguRND. All rights reserved.
//

import UIKit
import Alamofire

class mainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var pageView: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewCell2: UICollectionView!
    
    var sliderImageArray = [UIImage?]()
    var categoriesImage = [UIImage?]()
    var categoriesLabel = [String?]()
    var categoriesID = [String?]()
    var timer = Timer()
    var counter = 0
    var subCategoryID = 0
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionViewCell2.delegate = self
        //let hideKayboard = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        //view.addGestureRecognizer(hideKayboard)
        sliderViewDidLoad()
        categories()
    }
    
    func selectCategory()   {
        let selectItem = collectionViewCell2.indexPathsForSelectedItems?.last ?? IndexPath(item: 0, section: 0)
        print(selectItem)
    }
    
    @objc func hideKeyboard()   {
        view.endEditing(true)
    }
    
    func sliderViewDidLoad()    {
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
                                self.pageView.numberOfPages = self.sliderImageArray.count
                                self.pageView.currentPage = 0
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
    
    @objc func changeImage() {
        if counter < sliderImageArray.count {
            let index = IndexPath.init(item: counter, section: 0)
            self.collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            pageView.currentPage = counter
            counter += 1
        } else {
            counter = 0
            let index = IndexPath.init(item: counter, section: 0)
            self.collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
            pageView.currentPage = counter
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
    
    struct sliderImage: Codable {
        let slider_image: String
        let slider_url: String
    }
    
    struct category: Codable {
        let id, title, slug, parent: String
        let level, description, image, image2: String
        let status: String
    }
    
    @IBAction func cellTapped(deneme: Int)   {
        subCategoryID = Int(categoriesID[deneme]!)!
        performSegue(withIdentifier: "go", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "go" {
            let destination = segue.destination as! SubViewController
            destination.subCategory = categoriesID
            destination.subCategoryIndex = subCategoryID
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           if collectionView == collectionViewCell2    {
               return categoriesLabel.count
           }
           return sliderImageArray.count
       }
       
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionViewCell2    {
            cellTapped(deneme: indexPath.row)
        }

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
    
}

/*
extension mainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewCell2    {
            return categoriesLabel.count
        }
        return sliderImageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionViewCell2    {
            print("deneme1")
            cellTapped(deneme: indexPath.row)
        }
        print(indexPath.row)
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
            return cell2
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        if let vc = cell.viewWithTag(111) as? UIImageView {
            vc.image = sliderImageArray[indexPath.row]
        }
        return cell
    }
}

extension mainViewController: UICollectionViewDelegateFlowLayout {
    
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
    
}
*/
