//
//  NewinfoViewController.swift
//  LittleRichUISample
//
//  Created by 酒井文也 on 2016/08/27.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit
import Gecco
import LTMorphingLabel

class NewinfoViewController: SpotlightViewController, LTMorphingLabelDelegate {

    private var stepIndex: Int = 0
    
    //タイトル部分のラベル（Storyboard上では初期値を空にしておく）
    @IBOutlet weak var titleLabel: LTMorphingLabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        //ラベルの値とLTMorphingLabelのモーションを設定する
        titleLabel.text = "What's New"
        titleLabel.morphingEffect = .Evaporate

        //ライブラリ「Gecco」のSpotlightViewControllerのデリゲートを設定
        delegate = self
    }

    //ライブラリ「Gecco」で表示されるコントローラーがタップ回数をカウントして値に応じてアクションを変える
    func next(labelAnimated: Bool) {

        //コントローラーのアルファ値を変更
        updateAnnotationView(labelAnimated)
        
        let screenSize = UIScreen.mainScreen().bounds.size
        switch stepIndex {
            case 0:
                //このコントローラーを表示させて押したボタンのところにマスク表示をする
                spotlightView.appear(Spotlight.Oval(center: CGPointMake(screenSize.width - 128, 42), diameter: 36))
            case 1:
                //このコントローラーを閉じる
                dismissViewControllerAnimated(true, completion: nil)
            default:
                break
        }
        
        //タップ回数を1加算
        stepIndex += 1
    }

    //Geccoで表示されるコントローラーのアルファ値を変更する
    func updateAnnotationView(animated: Bool) {
        UIView.animateWithDuration(animated ? 0.55 : 0) {
            self.view.alpha = self.stepIndex == self.stepIndex ? 1 : 0
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension NewinfoViewController: SpotlightViewControllerDelegate {

    //Geccoで表示されている途中の場合
    func spotlightViewControllerWillPresent(viewController: SpotlightViewController, animated: Bool) {
        next(false)
    }

    //Geccoで表示されるコントローラーをタップした場合
    func spotlightViewControllerTapped(viewController: SpotlightViewController, isInsideSpotlight: Bool) {
        next(true)
    }

    //Geccoで表示されるコントローラーが閉じられる場合
    func spotlightViewControllerWillDismiss(viewController: SpotlightViewController, animated: Bool) {
        spotlightView.disappear()
    }
}
