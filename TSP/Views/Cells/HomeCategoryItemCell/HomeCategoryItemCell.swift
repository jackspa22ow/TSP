//
//  HomeCategoryItemCell.swift
//  TSP
//
//  Created by Ankur Kathiriya on 26/07/21.
//

import UIKit

class HomeCategoryItemCell: UITableViewCell {
    
    class var identifier : String { return String(describing: self) }
    class var nib: UINib { return  UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnViewAll: UIButton!
    
    var selectedCategory:((_ category : String) -> ())?

    var objGroupList : Group?{
        didSet {
            cellDataSet()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(HomeCategoryCell.nib, forCellWithReuseIdentifier: HomeCategoryCell.identifier)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func cellDataSet() {
        lblTitle.text = objGroupList?.groupName
        collectionView.reloadData()
    }
}

extension HomeCategoryItemCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = objGroupList?.displayCategories?.count
        return count!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCategoryCell.identifier, for: indexPath) as? HomeCategoryCell else {
            fatalError("XIB doesn't exist.")
        }
        
        let obj = objGroupList?.displayCategories?[indexPath.item]
        
        if let str = obj?.name{
            cell.lblItemName.text = str
        }
        
        if let str = obj?.iconUrl{
            let fileUrl = URL(string: str)
            cell.imgItem.sd_setImage(with: fileUrl, placeholderImage: UIImage(named: "ic_logo"))
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        SelectedCategoryForBillerFromHomeVC = objGroupList?.displayCategories?[indexPath.item]
        
        if let str = SelectedCategoryForBillerFromHomeVC.name{
            selectedCategory?(str)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 60)
    }

}
