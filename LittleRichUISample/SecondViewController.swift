//
//  SecondViewController.swift
//  LittleRichUISample
//
//  Created by 酒井文也 on 2016/08/27.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit

enum ContentsChoice: Int {
    case Archive1 = 0
    case Archive2
}

//画面の縦横サイズを取得
struct DeviceSize {

    static func screenWidth() -> CGFloat {
        return CGFloat(UIScreen.mainScreen().bounds.size.width);
    }

    static func screenHeight() -> CGFloat {
        return CGFloat(UIScreen.mainScreen().bounds.size.height);
    }
}

class SecondViewController: UIViewController {

    private var contentsType: ContentsChoice = .Archive1

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var backSecondButton: UIButton!
    
    var tabberSegmentedControl: HMSegmentedControl!

    //背景のUIImageViewを傾きによってずらす処理を実行
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        backGroundMotion()
    }

    //背景のUIImageViewをプログラムで再配置する
    override func viewDidLayoutSubviews() {

        backgroundImageView.frame = CGRectMake(
            CGFloat(-40),
            CGFloat(-40),
            CGFloat(DeviceSize.screenWidth()+80),
            CGFloat(DeviceSize.screenHeight()+80)
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Objective-CのライブラリであるHMSegmentedControlの設定と配置
        tabberSegmentedControl = HMSegmentedControl(sectionTitles: ["Archive of Cuisine", "Archive of Night View"])
        tabberSegmentedControl.addTarget(self, action: #selector(SecondViewController.segmentControlTapped), forControlEvents: .ValueChanged)
        tabberSegmentedControl.frame = CGRectMake(0, 60, view.frame.width, 50)
        tabberSegmentedControl.backgroundColor = UIColor.clearColor()
        tabberSegmentedControl.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "Optima", size: 14)!
        ]
        tabberSegmentedControl.selectionIndicatorHeight = 2.0
        tabberSegmentedControl.selectionIndicatorColor = UIColor.whiteColor()
        tabberSegmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown
        self.view.addSubview(tabberSegmentedControl)
        
        //戻るボタンを正円にする
        backSecondButton.layer.cornerRadius = CGFloat(30)
    }
    
    func segmentControlTapped() {
        
        if contentsType == .Archive1 {
            
        } else {
            
        }

    }

    /**
     * 背景のUIImageViewをデバイスの傾きに合わせて動かすメソッド
     * 引用：[iOS][Swift] パララックス(視差効果)を入れるサンプル
     * http://dev.classmethod.jp/smartphone/iphone/ios_ui_parallax/
     */
    private func backGroundMotion() {

        let min = -42.0
        let max = 42.0

        let xAxis = UIInterpolatingMotionEffect(keyPath: "center.x", type: .TiltAlongHorizontalAxis)
        xAxis.minimumRelativeValue = min
        xAxis.maximumRelativeValue = max

        let yAxis = UIInterpolatingMotionEffect(keyPath: "center.y", type: .TiltAlongVerticalAxis)
        yAxis.minimumRelativeValue = min
        yAxis.maximumRelativeValue = max
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [xAxis, yAxis]

        backgroundImageView.addMotionEffect(group)
    }
    
    @IBAction func backSecondAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
