//
//  ViewAllCategoryVC.swift
//  TSP
//
//  Created by Ankur Kathiriya on 23/07/21.
//

import UIKit

class ViewAllCategoryVC: UIViewController {
    
    @IBOutlet weak var lblCategoryTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var categoryList : [GroupDisplayCategory]!
    var categoryName = String()
    var selectedCategory:((_ category : String) -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(HomeCategoryCell.nib, forCellWithReuseIdentifier: HomeCategoryCell.identifier)
        
        self.setData()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonHandlerBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setData(){
        
        self.lblCategoryTitle.text = self.categoryName
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.reloadData()
    }
    
}



extension ViewAllCategoryVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCategoryCell.identifier, for: indexPath) as? HomeCategoryCell else {
            fatalError("XIB doesn't exist.")
        }
        
        let obj = categoryList[indexPath.item]
        cell.lblItemName.text = obj.name
        
        let fileUrl = URL(string: (obj.iconUrl ?? ""))
        cell.imgItem.sd_setImage(with: fileUrl, placeholderImage: UIImage(named: "ic_logo"))

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
        SelectedCategoryForBillerFromHomeVC = categoryList[indexPath.item]
                
        if let str = SelectedCategoryForBillerFromHomeVC.name{
            selectedCategory?(str)
        }
        self.navigationController?.popViewController(animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 60)
    }

}
