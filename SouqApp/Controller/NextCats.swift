//
//  NextCats.swift
//  SouqApp
//
//  Created by Ahmed.
//  Copyright © 2019 Ahmed. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class NextCats: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionLst: UICollectionView!
    
    var cnames = [String]()
    var cids = [Int]()
    var cpics = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCats()
        collectionLst.transform = CGAffineTransform(scaleX: -1, y: 1)
    }
    
    @IBAction func btnBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func getCats() {
        Alamofire.request("\(Constants.api_link)serv-id", method: .post, parameters: ["lang":"en","user_id":User.id,"cat_id":User.cat_id], encoding: JSONEncoding.default)
            .responseJSON { (response) in
                print(response)
                if let res = response.result.value {
                    if let arr = res as? NSArray {
                        for d in arr {
                            if let d2 = d as? NSDictionary {
                                self.cnames.append(d2["name"] as! String)
                                self.cids.append(d2["id"] as! Int)
                                self.cpics.append(d2["img"] as! String)
                            }
                        }
                    }
                }
                
                self.collectionLst.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cids.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionLst.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! catCell
        let inx = indexPath.row
        cell.cname.text = cnames[inx]
        let url = URL(string: "\(Constants.baseUrl)\(cpics[inx])")
        cell.cpic.kf.indicatorType = .activity
        cell.cpic.kf.setImage(with: url)
        cell.transform = CGAffineTransform(scaleX: -1, y: 1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionLst.frame.width - 10)/3, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let inx = indexPath.row
        let p = product()
        p.name = cnames[inx]
        p.pic = cpics[inx]
        cart.products.append(p)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
