//
//  Home.swift
//  SouqApp
//
//  Created by Ahmed.
//  Copyright © 2019 Ahmed. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class Home: UIViewController {
    
    @IBOutlet weak var scrollCollection: UICollectionView!
    @IBOutlet weak var collectionLst: UICollectionView!
    
    var menu_vc : Menu!
    var cnames = [String]()
    var cids = [Int]()
    var cfav = [Int]()
    var cpics = [String]()
    var imgArray = [UIImage(named:"C1"),
                    UIImage(named:"C2"),
                    UIImage(named:"C3"),
                    UIImage(named:"C4"),
                    UIImage(named:"C5"),
                    UIImage(named:"C6"),
                    UIImage(named:"C7"),
                    UIImage(named:"C8"),
                    UIImage(named:"C9")]
    var timer = Timer()
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menu_vc = self.storyboard?.instantiateViewController(withIdentifier: "Menu") as? Menu
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToGsture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
        NotificationCenter.default.addObserver(self, selector: #selector(close_on_swipe), name: NSNotification.Name("CloseMenu"), object: nil)
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        }
        getCats()
        collectionLst.transform = CGAffineTransform(scaleX: -1, y: 1)
    }
    
    @objc func respondToGsture(gesture : UISwipeGestureRecognizer) {
        switch gesture.direction {
        case UISwipeGestureRecognizer.Direction.left:
            close_on_swipe()
        default:
            break
        }
    }
    
    @IBAction func btnMenu(_ sender: Any) {
        show_menu()
    }
    
    @objc func close_on_swipe() {
        close_menu()
    }
    
    func show_menu() {
        UIView.animate(withDuration: 0.5) { () -> Void in
            self.menu_vc.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            self.menu_vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            self.addChild(self.menu_vc)
            self.view.addSubview(self.menu_vc.view)
            AppDelegate.menu_bool = false
        }
    }
    
    @objc func close_menu() {
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.menu_vc.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height:
            UIScreen.main.bounds.size.height)}) { (finished) in
            self.menu_vc.view.removeFromSuperview()}
        AppDelegate.menu_bool = true
    }
    
    @objc func changeImage() {
        if counter < imgArray.count {
            let index = IndexPath.init(item: counter, section: 0)
            self.scrollCollection.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            counter += 1
        } else {
            counter = 0
            let index = IndexPath.init(item: counter, section: 0)
            self.scrollCollection.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
            counter = 1
        }
    }
    
    func getCats() {
        cnames.removeAll()
        cpics.removeAll()
        cfav.removeAll()
        cids.removeAll()
        Alamofire.request("\(Constants.api_link)home", method: .post, parameters: ["lang":"en","user_id":User.id], encoding: JSONEncoding.default)
            .responseJSON { (response) in
                print(response)
                if let res = response.result.value {
                    if let arr = res as? NSArray {
                        for d in arr {
                            if let d2 = d as? NSDictionary {
                                self.cnames.append(d2["name"] as! String)
                                self.cids.append(d2["id"] as! Int)
                                self.cfav.append(d2["star"] as! Int)
                                self.cpics.append(d2["img"] as! String)
                            }
                        }
                    }
                }
                
                self.collectionLst.reloadData()
        }
    }
    
    func goVC(_ id: String) {
        let story = UIStoryboard(name: "Main", bundle: nil)
        let vc = story.instantiateViewController(withIdentifier: id)
        present(vc, animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension Home: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionLst {
            let inx = indexPath.row
            User.cat_id = cids[inx]
            User.cat_name = cnames[inx]
            goVC("NextCats")
        } else {
            print("Scroll Collection View")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.scrollCollection {
            return imgArray.count
        } else {
            return cids.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.scrollCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            if let vc = cell.viewWithTag(111) as? UIImageView {
                vc.image = imgArray[indexPath.row]
            }
            return cell
        } else {
            let cell = collectionLst.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! catCell
            let inx = indexPath.row
            cell.cname.text = cnames[inx]
            let url = URL(string: "\(Constants.baseUrl)\(cpics[inx])")
            cell.cpic.kf.indicatorType = .activity
            cell.cpic.kf.setImage(with: url)
            if cfav[inx] == 1{
                cell.cfav.image = UIImage(named: "favourite_filled")
            } else {
                cell.cfav.image = UIImage(named: "favourite_outline")
            }
            cell.btn.tag = cids[inx]
            cell.btn.addTarget(self, action: #selector(add_to_fav), for: .touchUpInside)
            cell.transform = CGAffineTransform(scaleX: -1, y: 1)
            return cell
        }
    }
    
    @objc func add_to_fav(_ sender:UIButton){
        let id = sender.tag
        Alamofire.request("\(Constants.api_link)add_fav_cat", method: .post, parameters: ["lang":"en","user_id":User.id,"cat_id":id], encoding: JSONEncoding.default)
            .responseJSON { (response) in
                print(response)
                if let res = response.result.value {
                    if let d = res as? NSDictionary {
                        //self.alert(d["msg"] as! String)
                        self.getCats()
                }
            }
        }
    }
}

extension Home: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.scrollCollection {
            let size = scrollCollection.frame.size
            return CGSize(width: size.width, height: size.height)
        } else {
            return CGSize(width: (collectionLst.frame.width - 10)/3, height: 150)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.scrollCollection {
            return 0.0
        } else {
            return 4.0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.scrollCollection {
            return 0.0
        } else {
            return 4.0
        }
    }
}

extension UIView {
    @IBInspectable var corner:CGFloat {
        set {
            layer.cornerRadius = newValue
        } get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var border_width:CGFloat {
        set {
            layer.borderWidth = newValue
        } get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var border_color:UIColor? {
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        } get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
    }
}
