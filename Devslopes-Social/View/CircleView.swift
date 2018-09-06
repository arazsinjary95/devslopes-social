//
//  CircleView.swift
//  Devslopes-Social
//
//  Created by Araz Sinjary on 8/31/18.
//  Copyright © 2018 Araz Sinjary. All rights reserved.
//

import UIKit

class CircleView: UIImageView {

//    override func awakeFromNib() {
//        super.awakeFromNib()
//        
//        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
//        layer.shadowOpacity = 0.8
//        layer.shadowRadius = 0.5
//        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
//    }
    
    override func layoutSubviews() {
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
        
    }
//    override func draw(_ rect: CGRect) {
//        super.draw(rect)
//        layer.cornerRadius = self.frame.width / 2
//    }

}
