//
//  Themes.swift
//  EctoContacts
//
//  Created by Pavan Powani on 10/05/20.
//  Copyright © 2020 PavanPowani. All rights reserved.
//

import UIKit

class Themes {
    static let primaryColour = UIColor(red: 83/255, green: 227/255, blue: 191/255, alpha: 1)
    static let backgroundColour = UIColor(red: 233/255, green: 233/255, blue: 233/255, alpha: 1)
    static let separatorColour = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)
}

class SeparatorView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = Themes.separatorColour
    }
}
