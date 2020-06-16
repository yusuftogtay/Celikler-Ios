//
//  notificationPageViewController.swift
//  CeliklerMarket
//
//  Created by Ahmet Yusuf TOĞTAY on 10.06.2020.
//  Copyright © 2020 OzguRND. All rights reserved.
//

import UIKit
import CoreData
import SDWebImage

class notificationPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    var not: [noti] = []
    let placeHolderImage = UIImage(named: "V1")
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return not.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = table.dequeueReusableCell(withIdentifier: "noti", for: indexPath)
        if let productName = tableCell.viewWithTag(502) as? UILabel {
            productName.text = not[indexPath.row].title
        }
        if let productName = tableCell.viewWithTag(600) as? UILabel {
            productName.text = not[indexPath.row].body
        }
        let imageUrl = URL(string: not[indexPath.row].image!)
        if let productImage = tableCell.viewWithTag(501) as? UIImageView {
            productImage.sd_setImage(with: imageUrl, placeholderImage: placeHolderImage, options: SDWebImageOptions.highPriority, context: nil)
        }
        return tableCell
    }
    

    override func viewDidLoad() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Notifications")
        do {
            let result = try managedContext.fetch(fetchRequest)
            not.removeAll()
            for data in result as! [NSManagedObject] {
                let title = data.value(forKey: "title") as! String
                let image = data.value(forKey: "image") as! String
                let body = data.value(forKey: "body") as! String
                not.append(noti(title: title, body: body, image: image))
            }
            DispatchQueue.main.async {
                self.table.reloadData()
            }
        } catch {
            print("Failed")
        }
    }
}

struct noti: Codable {
    var title: String?
    var body: String?
    var image: String?
}
