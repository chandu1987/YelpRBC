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
                restaurantImage.loadImage(at: URL(string: coverImage)!)
            }
            
            restaurantName.text = restaurant?.name
            rating.text = "\(restaurant?.rating ?? 0)" + "*"
       
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        restaurantName.backgroundColor = UIColor.black.withAlphaComponent(0.5)

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
