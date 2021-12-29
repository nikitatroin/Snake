//
//  BackView.swift
//  Snake
//
//  Created by Никита Троян on 28.12.2021.
//  Copyright © 2021 Pinspb. All rights reserved.
//

import UIKit

protocol BackViewDelegate: AnyObject {
    func moveBack()
}

class BackView: UIView {
    
    weak var delegate: BackViewDelegate?

    @IBAction func backButton(_ sender: Any) {
        self.delegate?.moveBack()
    }
    
 
}
