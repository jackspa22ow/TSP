//
//  BillerCategoryListCell.swift
//  TSP
//
//  Created by Ankur Kathiriya on 13/11/21.
//

import UIKit

class BillerCategoryListCell: UITableViewCell {

    class var identifier : String { return String(describing: self) }
    class var nib: UINib { return  UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var displayCategories = [GroupDisplayCategory]()
    var selectedCategory:((_ index : Int) -> ())?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Initialization code
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(HomeCategoryCell.nib, forCellWithReuseIdentifier: HomeCategoryCell.identifier)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension BillerCategoryListCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        let count = objGroupList?.displayCategories?.count
        return displayCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCategoryCell.identifier, for: indexPath) as? HomeCategoryCell else {
            fatalError("XIB doesn't exist.")
        }
        
        let obj = displayCategories[indexPath.item]

        if let str = obj.name{
            cell.lblItemName.text = str
        }

        if let str = obj.iconUrl{
            let fileUrl = URL(string: str)
            cell.imgItem.sd_setImage(with: fileUrl)
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedCategory?(indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 30) / 3, height: 60)
    }

}
