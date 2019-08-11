//
//  TextField.swift
//  Amoogye
//
//  Created by 임수현 on 04/08/2019.
//  Copyright © 2019 KookKook. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    var manager: CustomTextfieldManager?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        // cursor: NONE
        // radius: 6pt
        // font size: 20pt
        self.tintColor = UIColor.clear
        self.layer.cornerRadius = 6
        self.font = .systemFont(ofSize: 20)
        self.textAlignment = .center

        self.focusOut()
    }

    func focusOn() {
        // selected background: #white
        // selected border: #orangeyRed
        // selected font: #orangeyRed
        self.backgroundColor = UIColor.white
        self.layer.borderColor = UIColor.TextFieldColors.orangeyRed.cgColor
        self.layer.borderWidth = 1
        self.textColor = UIColor.TextFieldColors.orangeyRed
        self.text = ""
    }

    func focusOut() {
        // unselected background: #iceBlue
        // unselected border: NONE
        // unselected font: #darkBlueGrey
        self.backgroundColor = UIColor.TextFieldColors.iceBlue
        self.layer.borderColor = UIColor.clear.cgColor
        self.borderStyle = .none
        self.textColor = UIColor.TextFieldColors.darkBlueGrey
        if self.text == "" {
            self.text = "0"
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.focusOn()
        self.manager?.focusOutAll(except: self)
    }
}
