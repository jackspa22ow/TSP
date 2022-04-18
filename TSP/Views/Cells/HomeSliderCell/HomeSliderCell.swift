//
//  HomeSliderCell.swift
//  TSP
//
//  Created by Pratik Mavani on 09/07/21.
//

import UIKit
import SDWebImage
import FSPagerView

class HomeSliderCell: UITableViewCell {

    class var identifier : String { return String(describing: self) }
    class var nib: UINib { return  UINib(nibName: identifier, bundle: nil) }

    @IBOutlet weak var sliderView: FSPagerView!{
        didSet {
            self.sliderView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.sliderView.itemSize = FSPagerView.automaticSize
        }
    }

    var imageArray : [BannerList]?{
        didSet {
            // Create a pager view
            self.configurePagerView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    func configurePagerView(){
        self.sliderView.delegate = self
        self.sliderView.dataSource = self
        self.sliderView.automaticSlidingInterval = 3.0
        self.sliderView.isInfinite = true
        self.sliderView.decelerationDistance = 10
        self.sliderView.interitemSpacing = 15
        self.sliderView.itemSize = CGSize(width: UIScreen.main.bounds.width - 60, height: 150)
        self.sliderView.isUserInteractionEnabled = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension HomeSliderCell : FSPagerViewDataSource, FSPagerViewDelegate {
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return imageArray?.count ?? 0
    }
        
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
       
        let fileUrl = URL(string: self.imageArray?[index].logo ?? "")
        cell.imageView?.sd_setImage(with: fileUrl)
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        
        return cell
    }
    public func pagerView(_ pagerView: FSPagerView, shouldHighlightItemAt index: Int) -> Bool {
        return true
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        
        let redirectUrl = self.imageArray?[index].redirectUrl ?? ""
        
        guard let url = URL(string: redirectUrl) else {
          return //be safe
        }

        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}
