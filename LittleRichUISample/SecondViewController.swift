//
//  SecondViewController.swift
//  LittleRichUISample
//
//  Created by 酒井文也 on 2016/08/27.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var backSecondButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        backSecondButton.layer.cornerRadius = CGFloat(30)
    }

    @IBAction func backSecondAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
