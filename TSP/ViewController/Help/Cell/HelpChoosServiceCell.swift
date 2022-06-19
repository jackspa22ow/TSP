//
//  HelpChoosServiceCell.swift
//  TSP
//
//  Created by Ankur Kathiriya on 25/11/21.
//

import UIKit

class HelpChoosServiceCell: UITableViewCell {
    class var identifier : String { return String(describing: self) }
    class var nib: UINib { return  UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet weak var collectionView
    : UICollectionView!
    @IBOutlet weak var lblNoData: UILabel!
    
    var aryOfServiceGroupList : [ServiceGroupModel] = []
    var selectedGroup:((_ groupName : String) -> ())?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.register(HelpServiceItemCell.nib, forCellWithReuseIdentifier: HelpServiceItemCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension HelpChoosServiceCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return aryOfServiceGroupList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HelpServiceItemCell.identifier, for: indexPath) as? HelpServiceItemCell else {
            fatalError("XIB doesn't exist.")
        }
        let obj = aryOfServiceGroupList[indexPath.row]
        
        cell.lblGroupName.text = obj.groupName
        cell.lblDescription.text = obj.description
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 16) / 2, height: 80)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let obj = aryOfServiceGroupList[indexPath.row]

        self.selectedGroup?(obj.groupName ?? "")
    }
}
