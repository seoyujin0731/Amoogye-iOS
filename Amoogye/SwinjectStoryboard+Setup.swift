//
//  SwinjectStoryboard+Setup.swift
//  Amoogye
//
//  Created by JunHui Kim on 09/08/2019.
//  Copyright © 2019 KookKook. All rights reserved.
//

import Swinject
import SwinjectStoryboard
import SwinjectAutoregistration

extension SwinjectStoryboard {
    @objc class func setup() {
        // RealmMeasuringToolManager
        defaultContainer.autoregister(RealmMeasuringToolManager.self, initializer: RealmMeasuringToolManager.init)

        defaultContainer.storyboardInitCompleted(MeasuringToolViewController.self) { r, c in
            c.measuringToolManager = r ~> RealmMeasuringToolManager.self
        }
        defaultContainer.storyboardInitCompleted(SetNameForNewToolViewController.self) { r, c in
            c.measuringToolManager = r ~> RealmMeasuringToolManager.self
        }
        defaultContainer.storyboardInitCompleted(MeasureNewToolViewController.self) { r, c in
            c.measuringToolManager = r ~> RealmMeasuringToolManager.self
        }
        defaultContainer.storyboardInitCompleted(CompleteNewToolViewController.self) { r, c in
            c.measuringToolManager = r ~> RealmMeasuringToolManager.self
        }

        // RealmMeterialManager
        defaultContainer.autoregister(RealmMeterialManager.self, initializer: RealmMeterialManager.init)

        // ApplicationSetting
        defaultContainer.autoregister(ApplicationSetting.self, initializer: ApplicationSetting.init)

        defaultContainer.storyboardInitCompleted(SettingViewController.self) {r, c in
            c.appSetting = r ~> ApplicationSetting.self
        }

        // TODO
                // Calculator
        //        defaultContainer.autoregister(Calculator.self, argument: RealmHistoryManager.self, initializer: Calculator.init)
        defaultContainer.autoregister(Calculator.self, initializer: Calculator.init)

        defaultContainer.storyboardInitCompleted(CalculatorViewController.self) { r, c in
            c.calculator = r ~> Calculator.self
        }
    }
}
