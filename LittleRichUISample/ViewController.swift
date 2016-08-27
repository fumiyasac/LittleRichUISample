//
//  ViewController.swift
//  LittleRichUISample
//
//  Created by 酒井文也 on 2016/08/26.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit
import BubbleTransition
import Gecco

class ViewController: UIViewController {

    @IBOutlet weak var goSecondButton: UIButton!
    @IBOutlet weak var parallaxTableView: UITableView!
    
    private let transition = BubbleTransition()
    private let sectionCount = 1
    
    var models: [CellModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        parallaxTableView.delegate = self
        parallaxTableView.dataSource = self
        parallaxTableView.rowHeight = 180

        models.append(CellModel(title: "Title 0", desc:  "DescriptionDetailDescriptionDetailDescriptionDetail", imageName: "cafe_cake"))
        models.append(CellModel(title: "Title 1", desc:  "DescriptionDetailDescriptionDetailDescriptionDetail",imageName: "cafe_cake"))
        models.append(CellModel(title: "Title 2", desc:  "DescriptionDetailDescriptionDetailDescriptionDetail",imageName: "cafe_cake"))
        models.append(CellModel(title: "Title 3", desc:  "DescriptionDetailDescriptionDetailDescriptionDetail",imageName: "cafe_cake"))
        models.append(CellModel(title: "Title 4", desc:  "DescriptionDetailDescriptionDetailDescriptionDetail",imageName: "cafe_cake"))
        
        //Xibのクラスを読み込む宣言を行う
        let nibDefault:UINib = UINib(nibName: "ParallaxTableViewCell", bundle: nil)
        parallaxTableView.registerNib(nibDefault, forCellReuseIdentifier: "ParallaxTableViewCell")
        
        //ボタンの丸さをつくる
        goSecondButton.layer.cornerRadius = CGFloat(30)
    }

    @IBAction func descriptionAlertAction(sender: AnyObject) {
        doDescriptionAlert()
    }
    
    @IBAction func newinfoAlertAction(sender: AnyObject) {
        doNewinfoAlert()
    }

    private func doDescriptionAlert() {

        let descriptionViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DescriptionAlert") as! DescriptionViewController
        descriptionViewController.alpha = 0.75
        presentViewController(descriptionViewController, animated: true, completion: nil)
    }

    private func doNewinfoAlert() {

        let newinfoViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("NewinfoAlert") as! NewinfoViewController
        newinfoViewController.alpha = 0.75
        presentViewController(newinfoViewController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        let controller = segue.destinationViewController
        controller.transitioningDelegate = self
        controller.modalPresentationStyle = .Custom
    }

}

extension ViewController: UIViewControllerTransitioningDelegate {

    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        transition.transitionMode = .Present
        transition.startingPoint = goSecondButton.center
        transition.bubbleColor = goSecondButton.backgroundColor!
        return transition
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        transition.transitionMode = .Dismiss
        transition.startingPoint = goSecondButton.center
        transition.bubbleColor = goSecondButton.backgroundColor!
        return transition
    }

}

extension ViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (scrollView == parallaxTableView) {
            for indexPath in parallaxTableView.indexPathsForVisibleRows! {
                setCellImageOffset(self.parallaxTableView.cellForRowAtIndexPath(indexPath) as! ParallaxTableViewCell, indexPath: indexPath)
            }
        }
    }
    
    func setCellImageOffset(cell: ParallaxTableViewCell, indexPath: NSIndexPath) {

        let cellFrame = parallaxTableView.rectForRowAtIndexPath(indexPath)
        let cellFrameInTable = parallaxTableView.convertRect(cellFrame, toView: parallaxTableView.superview)
        let cellOffset = cellFrameInTable.origin.y + cellFrameInTable.size.height
        let tableHeight = parallaxTableView.bounds.size.height + cellFrameInTable.size.height
        let cellOffsetFactor = cellOffset / tableHeight

        cell.setBackgroundOffset(cellOffsetFactor)
    }

    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let imageCell = cell as! ParallaxTableViewCell
        setCellImageOffset(imageCell, indexPath: indexPath)
    }
    
}

extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UITableViewDataSource {
    
    //テーブルの要素数を設定する ※必須
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionCount
    }
    
    //テーブルの行数を設定する ※必須
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if section == 0 {
            return self.models.count * 100
        }
        return 0
    }

    func modelAtIndexPath(indexPath: NSIndexPath) -> CellModel {
        return self.models[indexPath.row % self.models.count]
    }
    
    //表示するセルの中身を設定する ※必須
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ParallaxTableViewCell") as? ParallaxTableViewCell
        
        cell!.model = self.modelAtIndexPath(indexPath)
        
        //TODO: 読み込む静的なコンテンツの策定と
        cell!.accessoryType = UITableViewCellAccessoryType.None
        cell!.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell!
    }
    
}
