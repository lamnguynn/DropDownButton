//
//  Button.swift
//  DropDownButton
//
//  Created by Lam Nguyen on 8/12/21.
//

import Foundation
import UIKit

extension UIButton{
    
    /*
        @bottomCornersOnly
        Apply corner radius to the bottom right and left corners
     */
    func bottomCornersOnly(){
        self.layer.cornerRadius = 12
        self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    
    /*
        @topCornersOnly
        Apply corner radius to the top right and left corners.
     */
    func topCornersOnly(){
        self.layer.cornerRadius = 12
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    /*
        @allCornersOnly
        Apply corner radius to all corners
     */
    func allCornersOnly(){
        self.layer.cornerRadius = 12
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
}


