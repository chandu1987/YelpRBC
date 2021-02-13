//
//  DishCell.swift
//  YelpRBC
//
//  Created by Chandra Sekhar Ravi on 12/02/21.
//

import UIKit

class DishCell: UICollectionViewCell {
    
    @IBOutlet weak var dishImage:UIImageView!
    
    var dishImageUrl: String? {
        didSet{
            
            if  dishImageUrl != nil{
                dishImage.load(url: URL(string: dishImageUrl!)!)
            }
        
       
        }
    }

    
}
