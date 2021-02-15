//
//  RestaurantCell.swift
//  YelpRBC
//
//  Created by Chandra Sekhar Ravi on 10/02/21.
//

import UIKit

class RestaurantCell: UICollectionViewCell {
    //MARK:- Outlets
    @IBOutlet weak var restaurantImage:UIImageView!
    @IBOutlet weak var restaurantName:UILabel!
    @IBOutlet weak var rating:UILabel!
    
    //MARK:- properties

    var restaurant: Restaurant? {
        didSet{
            
            if let coverImage = restaurant?.imageURL{
                //Changed default Image sizes from yelp so that they fit well in the cell.
                let changedUrl = coverImage.replacingOccurrences(of: "o.jpg", with: "ls.jpg")
                restaurantImage.loadImage(at: URL(string: changedUrl)!)
            }
            
            restaurantName.text = restaurant?.name
            rating.text = "\(restaurant?.rating ?? 0)" + Constants.StringConstants.kStar
       
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        restaurantName.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        rating.layer.masksToBounds = true
        rating.layer.cornerRadius = rating.frame.size.width/2
    }
    

    
    override func prepareForReuse() {
        super.prepareForReuse()
        restaurantImage.image = nil
        restaurantImage.cancelImageLoad()
        restaurantName.text = ""
        rating.text = ""
    }
    
}


//extension UIImageView {
//    func load(url: URL) {
//        DispatchQueue.global().async { [weak self] in
//            if let data = try? Data(contentsOf: url) {
//                if let image = UIImage(data: data) {
//                    DispatchQueue.main.async {
//                        self?.image = image
//                    }
//                }
//            }
//        }
//    }
//}
