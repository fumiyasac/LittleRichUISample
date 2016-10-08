//
//  SecondViewController.swift
//  LittleRichUISample
//
//  Created by 酒井文也 on 2016/08/27.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit

enum ContentsChoice: Int {
    case archive1 = 0
    case archive2
}

//画面の縦横サイズを取得
struct DeviceSize {

    static func screenWidth() -> CGFloat {
        return CGFloat(UIScreen.main.bounds.size.width);
    }

    static func screenHeight() -> CGFloat {
        return CGFloat(UIScreen.main.bounds.size.height);
    }
}

class SecondViewController: UIViewController, UITextViewDelegate {

    //HMSegmentedControlの状態
    fileprivate var contentsType: ContentsChoice = .archive1

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var backSecondButton: UIButton!
    @IBOutlet weak var messageText: UITextView!

    //HMSegmentedControlを利用するSegmentedControl
    var tabberSegmentedControl: HMSegmentedControl!

    //背景のUIImageViewを傾きによってずらす処理を実行
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        backGroundMotion()
    }

    //メッセージ
    let messageArray = [
        "<span style=\"color:#ffffff;\">・ Happy wedded life.<br>幸せな結婚生活を・・<br><br>・ I'm very happy for you!<br>心から祝福します！<br><br>・ Wishing you a future filled with happiness.<br>これからの人生が幸せであふれますように。<br><br>・ Warmest wishes on your wedding.<br>ご結婚日に温かな 気持ちを込めて。<br><br>・ Best Of Luck In Your New Home.<br>ご新居の生活が幸せでありますように。<br><br>・ May your days be good, and long upon the earth.<br>（2人の）人生が長く、素晴らしいものでありますように。<br><br>・ Congratulations to both of you！Wishing you much love to fill your journey.<br>お二人とも、おめでとう！これからの旅が愛にあふれたものでありますように。<br><br>・ Congratulations! I hope you have a long and loving life together.<br>おめでとう！二人が愛にあふれた生活を末永く送れますように。<br><br>・ Happy Wedding to a great couple!! Best of luck in married life and Sweets are forever!!<br>素敵なお二人へ結婚おめでとう！！幸せにあふれた結婚生活を送って下さい。そしていつまでもお幸せに！！</span>",
        "<span style=\"color:#ffffff;\">・ Sweets Are Forever<br>いつまでもお幸せに<br><br>・ Best of luck in married life<br>幸せいっぱいの結婚生活を送ってください<br><br>・ Best Wishes on Your Wedding<br>お二人に心からお祝いを申しあげます<br><br>・ Congratulations on Your Wedding<br>ご結婚おめでとうございます<br><br>・ On Your Wedding With Best Wishes\nご結婚おめでとう<br><br>・ I wish you both happiness forever<br>お二人のお幸せが永遠に続きますように<br><br>・ Keep this Happy Feeling Forever<br>今の気持ちを忘れず末永くお幸せに<br><br>・ My Heartiest Congratulations To You Both<br>心からお祝い申し上げます<br><br>・ Congratulations And Best Wishes For Your Wedding<br>おめでとう　そしてお幸せをお祈りしています<br><br>・ Wedding wishes for your special day<br>祝ご結婚</span>"
    ]

    //レイアウト処理が完了した際の処理
    override func viewDidLayoutSubviews() {

        //背景のUIImageViewをプログラムで再配置する
        backgroundImageView.frame = CGRect(
            x: CGFloat(-40),
            y: CGFloat(-40),
            width: CGFloat(DeviceSize.screenWidth()+80),
            height: CGFloat(DeviceSize.screenHeight()+80)
        )

        //UITextViewの初期位置を戻す
        messageText.setContentOffset(CGPoint.zero, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Objective-CのライブラリであるHMSegmentedControlの設定と配置
        tabberSegmentedControl = HMSegmentedControl(sectionTitles: ["First Messages", "Second Messages"])
        tabberSegmentedControl.addTarget(self, action: #selector(SecondViewController.segmentControlTapped), for: .valueChanged)
        tabberSegmentedControl.frame = CGRect(x: 0, y: 60, width: view.frame.width, height: 50)
        tabberSegmentedControl.backgroundColor = UIColor.clear
        tabberSegmentedControl.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "Optima", size: 14)!
        ]
        tabberSegmentedControl.selectionIndicatorHeight = 2.0
        tabberSegmentedControl.selectionIndicatorColor = UIColor.white
        tabberSegmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown
        self.view.addSubview(tabberSegmentedControl)

        //戻るボタンを正円にする
        backSecondButton.layer.cornerRadius = CGFloat(30)

        //メッセージ表示部分の初期化
        messageText.delegate = self
        messageText.isSelectable = false
        messageText.isEditable = false
        segmentControlTapped()
    }

    //セグメントコントロールを切り替えた際のアクション
    func segmentControlTapped() {

        let htmlText: String

        if contentsType == .archive1 {
            htmlText = messageArray[ContentsChoice.archive1.rawValue]
            contentsType = .archive2
        } else {
            htmlText = messageArray[ContentsChoice.archive2.rawValue]
            contentsType = .archive1
        }

        //テキストフィールドのHTML化設定を行う
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineHeightMultiple = 1.5

        let encodedData = htmlText.data(using: String.Encoding.utf8)!
        let attributedOptions : [String : AnyObject] = [
            NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType as AnyObject,
            NSCharacterEncodingDocumentAttribute: NSNumber(value: String.Encoding.utf8.rawValue) as AnyObject,
            NSParagraphStyleAttributeName : paragraph
        ]
        let attributedString = try! NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)

        messageText.attributedText = attributedString
    }

    /**
     * 背景のUIImageViewをデバイスの傾きに合わせて動かすメソッド
     * 引用：[iOS][Swift] パララックス(視差効果)を入れるサンプル
     * http://dev.classmethod.jp/smartphone/iphone/ios_ui_parallax/
     */
    fileprivate func backGroundMotion() {

        let min = -42.0
        let max = 42.0

        let xAxis = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        xAxis.minimumRelativeValue = min
        xAxis.maximumRelativeValue = max

        let yAxis = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        yAxis.minimumRelativeValue = min
        yAxis.maximumRelativeValue = max
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [xAxis, yAxis]

        backgroundImageView.addMotionEffect(group)
    }
    
    @IBAction func backSecondAction(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
