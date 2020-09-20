//
//  cartC.swift
//  cart
//
//  Created by Ahmed.
//  Copyright © 2019 Ahmed. All rights reserved.
//
    
import UIKit
import Stripe
    
class cartC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, STPAddCardViewControllerDelegate {
        
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
            dismiss(animated: true, completion: nil)
    }
        
    var cnames = [String]()
    var cpics = [String]()
        
    @IBOutlet weak var lst: UICollectionView!
        
    func parseCart(){
        cnames.removeAll()
        cpics.removeAll()
        for p in cart.products {
            cnames.append(p.name)
            cpics.append(p.pic)
        }
        lst.reloadData()
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        parseCart()
    }
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cnames.count
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
        let cell = lst.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! catCell
        let inx = indexPath.row
        cell.cname.text = cnames[inx]
        let url = URL(string: "\(Constants.baseUrl)\(cpics[inx])")
        cell.cpic.kf.indicatorType = .activity
        cell.cpic.kf.setImage(with: url)
        return cell
    }
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let inx = indexPath.row
        cart.products.remove(at: inx)
        parseCart()
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (lst.frame.width - 10)/3, height: 150)
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4.0
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4.0
    }
    
    @IBAction func btnPay(_ sender: Any) {
        let config = STPPaymentConfiguration()
            config.requiredBillingAddressFields = .full
        let viewController = STPAddCardViewController(configuration: config, theme: .default())
            viewController.delegate = self
        let navigationController = UINavigationController(rootViewController: viewController)
            present(navigationController, animated: true, completion: nil)
    }
        
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
