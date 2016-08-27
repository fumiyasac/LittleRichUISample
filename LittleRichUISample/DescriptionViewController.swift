//
//  DescriptionViewController.swift
//  LittleRichUISample
//
//  Created by 酒井文也 on 2016/08/27.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit
import Gecco
import LTMorphingLabel

class DescriptionViewController: SpotlightViewController, LTMorphingLabelDelegate {

    private var stepIndex: Int = 0

    @IBOutlet weak var titleLabel: LTMorphingLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = "Description"
        titleLabel.morphingEffect = .Evaporate
        
        //ライブラリ「Gecco」のSpotlightViewControllerのデリゲートを設定
        delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func next(labelAnimated: Bool) {
        updateAnnotationView(labelAnimated)
        
        let screenSize = UIScreen.mainScreen().bounds.size
        switch stepIndex {
        case 0:
            spotlightView.appear(Spotlight.Oval(center: CGPointMake(screenSize.width - 38, 42), diameter: 36))
        case 1:
            dismissViewControllerAnimated(true, completion: nil)
        default:
            break
        }
        
        stepIndex += 1
    }
    
    func updateAnnotationView(animated: Bool) {
        UIView.animateWithDuration(animated ? 0.55 : 0) {
            self.view.alpha = self.stepIndex == self.stepIndex ? 1 : 0
        }
    }

}

extension DescriptionViewController: SpotlightViewControllerDelegate {

    func spotlightViewControllerWillPresent(viewController: SpotlightViewController, animated: Bool) {
        next(false)
    }
    
    func spotlightViewControllerTapped(viewController: SpotlightViewController, isInsideSpotlight: Bool) {
        next(true)
    }
    
    func spotlightViewControllerWillDismiss(viewController: SpotlightViewController, animated: Bool) {
        spotlightView.disappear()
    }
}
