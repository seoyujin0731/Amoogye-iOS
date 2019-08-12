//
//  TimerViewController.swift
//  Amoogye
//
//  Created by 임수현 on 25/07/2019.
//  Copyright © 2019 KookKook. All rights reserved.
//

import UIKit
import UserNotifications

class TimerSettingViewController: UIViewController {

    var numericKeyboardButtonTitles = [String]()

    var timerModel = TimerModel.shared
    let colorGreen = UIColor(displayP3Red: 109/255, green: 212/255, blue: 0, alpha: 1)

    @IBOutlet weak var startButton: UIButton!

    @IBOutlet weak var settingView: UIView!
    @IBOutlet weak var hourTextfield: CustomTextField!
    @IBOutlet weak var minTextfield: CustomTextField!
    @IBOutlet weak var secTextfield: CustomTextField!
    @IBOutlet weak var secLabel: UILabel!
    @IBOutlet weak var alertLabel: UILabel!

    @IBOutlet weak var numericKeyboardView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNumericKeyboard()
        setUpTextfield()
        setupButtonStyle(startButton)
    }

    override func viewWillAppear(_ animated: Bool) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound], completionHandler: {didAllow, _ in
            if !didAllow {
                self.alertPermissionDenied()
            }
        })

        if timerModel.getState() == .Finish { // 타이머가 종료된 상황
            showTimerFinish()
        } else { // 타이머가 시작하기 전, 또는 취소된 상황
            showTimerReady()
        }
    }

    // 화면 터치 시 textfield focusOut
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        focusOutAllTextfield()
    }

    @IBAction func clickStart(_ sender: Any) {
        focusOutAllTextfield()

        if timerModel.getState() == .Finish {  // 종료 버튼 클릭
            timerModel.resetTimer()
            showTimerReady()

        } else if getSecond() > 0 { // 시작 버튼 클릭
            let timerDeadLine = Date(timeIntervalSinceNow: Double(getSecond()))
            timerModel.setDeadLine(deadLine: timerDeadLine)
            timerModel.setTotalTime(total: Double(getSecond()))

            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "TimerProgressViewController") else { return }
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }

    func alertPermissionDenied() {
        self.tabBarController?.selectedIndex = 0
        let alert = UIAlertController(title: "권한 필요", message: "타이머 기능을 사용하려면 알림 권한 허용이 필요합니다.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "설정으로 이동", style: .default) { _ in
            if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                }
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)

        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}

extension TimerSettingViewController {

    // MARK: - Setup 관련 함수
//    func setupMaxTimeLimit() {
//
//    }

    func setupButtonStyle(_ buttons: UIButton...) {
        for button in buttons {
            button.layer.cornerRadius = 6
        }
    }

    func setUpTextfield() {
        let textfieldManager = CustomTextfieldManager(hourTextfield, minTextfield, secTextfield)
        hourTextfield.manager = textfieldManager
        minTextfield.manager = textfieldManager
        secTextfield.manager = textfieldManager
    }

    func setTimerTextfieldsEnable(booltype: Bool) {
        hourTextfield.isEnabled = booltype
        minTextfield.isEnabled = booltype
        secTextfield.isEnabled = booltype
        focusOutAllTextfield()
    }

    func focusOutAllTextfield() {
        hourTextfield.focusOut()
        minTextfield.focusOut()
        secTextfield.focusOut()
    }

    // 준비 상태
    func showTimerReady() {
        secLabel.text = "초 뒤에"
        alertLabel.text = "알려드릴게요!"
        startButton.setTitle("시작하기", for: .normal)
        setTimerTextfieldsEnable(booltype: true)
        numericKeyboardView.isHidden = false
    }

    // 시간 종료 상태
    func showTimerFinish() {
        secLabel.text = "초가"
        alertLabel.text = "끝났습니다!"
        startButton.setTitle("종료", for: .normal)
        setTimerTextfieldsEnable(booltype: false)
        numericKeyboardView.isHidden = true
    }

    // MARK: - 변환 관련 함수
    func getSecond() -> Int {
        let hour: Int = textfieldToInt(tf: hourTextfield)
        let min: Int = textfieldToInt(tf: minTextfield)
        let sec: Int = textfieldToInt(tf: secTextfield)
        return hour * 3600 + min * 60 + sec
    }

    func textfieldToInt(tf: UITextField) -> Int {
        guard let text = tf.text else {
            return 0
        }
        return Int(text) ?? 0
    }
}

// MARK: - numeric keyboard
extension TimerSettingViewController {

    private func hideKeyboards() {
        numericKeyboardView.isHidden = true
    }

    private func setupNumericKeyboard() {
        numericKeyboardButtonTitles = makeNumericKeyboardButtonTitles()

        let nibCell = UINib(nibName: "NumericKeyboardCollectionViewCell", bundle: nil)
        self.numericKeyboardView.register(nibCell, forCellWithReuseIdentifier: "NumericKeyboardCollectionViewCell")

        self.numericKeyboardView.delegate = self
        self.numericKeyboardView.dataSource = self
    }

    private func makeNumericKeyboardButtonTitles() -> [String] {
        var contents: [String] = []

        for i in 1..<10 {
            contents.append(String(i))
        }
        contents.append("0")
        contents.append(".")
        contents.append("del")

        return contents
    }

    private func cellWithNumericKeyboardButtonTitle(_ cell: NumericKeyboardCollectionViewCell, with buttonTitle: String) -> NumericKeyboardCollectionViewCell {
        if buttonTitle == "del" {
            cell.keyboardButton.setImage(UIImage(named: "keyboardBackspace"), for: .normal)
            cell.keyboardButton.setTitle("", for: .normal)
            return cell
        }

        cell.keyboardButton.setTitle(buttonTitle, for: .normal)
        return cell
    }
}

extension TimerSettingViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numericKeyboardButtonTitles.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NumericKeyboardCollectionViewCell", for: indexPath) as! NumericKeyboardCollectionViewCell
        let buttonTitle = numericKeyboardButtonTitles[indexPath.item]

        return cellWithNumericKeyboardButtonTitle(cell, with: buttonTitle)
    }
}

extension TimerSettingViewController: UICollectionViewDelegate {

}

extension TimerSettingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.width / 3 - 1
        let cellHeight = collectionView.frame.height / 4 - 1

        return CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
}
