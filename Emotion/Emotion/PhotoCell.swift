//
//  PhotoCell.swift
//  Emotion
//
//  Created by BumMo Koo on 2016. 11. 12..
//  Copyright © 2016년 BumMo Koo. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelBackgroundView: UIVisualEffectView!
    @IBOutlet weak var emotionLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        emotionLabel.text = ""
    }
}
