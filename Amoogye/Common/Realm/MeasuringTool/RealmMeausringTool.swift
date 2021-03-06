//
//  RealmMeasuringTool.swift
//  Amoogye
//
//  Created by JunHui Kim on 04/08/2019.
//  Copyright © 2019 KookKook. All rights reserved.
//

import Foundation
import RealmSwift

final class RealmMeasuringTool: Object {
    @objc dynamic var toolType = 0
    @objc dynamic var unitType = 0
    @objc dynamic var name = ""
    @objc dynamic var subname = ""
    @objc dynamic var quantity = ""
    @objc dynamic var isOn = true
    @objc dynamic var isEditable = true
    @objc dynamic var isNew = true
    @objc dynamic var recentUsed: Date = Date(timeIntervalSince1970: 1)
}
