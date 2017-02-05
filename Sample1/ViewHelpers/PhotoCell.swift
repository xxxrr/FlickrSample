//
//  PhotoCell.swift
//  Sample1
//
//  Created by Roopa Raman on 2/2/17.
//  Copyright © 2017  . All rights reserved.
//


import UIKit

class AnnotatedPhotoCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var imageViewHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet private weak var captionLabel: UILabel!
    @IBOutlet private weak var commentLabel: UILabel!
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if let attributes = layoutAttributes as? AdaptiveLayoutAtributes {
            imageViewHeightLayoutConstraint.constant = attributes.photoHeight
        }
    }
    func configure(_ photoData:Photo){
        imageView.image = photoData.photo
        captionLabel.text = photoData.title
        
    }
    
}
