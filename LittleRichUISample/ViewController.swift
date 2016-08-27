//
//  ViewController.swift
//  LittleRichUISample
//
//  Created by 酒井文也 on 2016/08/26.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit
import BubbleTransition

class ViewController: UIViewController {

    @IBOutlet weak var goSecondButton: UIButton!
    @IBOutlet weak var parallaxTableView: UITableView!

    //ライブラリ「BubbleTransition」のインスタンスを作る
    private let transition = BubbleTransition()

    //セルのセクション数
    private let sectionCount = 1

    //セルに表示するデータモデルの変数 ※CellModel.swift参照
    var models: [CellModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //UITableViewに関する初期設定
        parallaxTableView.delegate = self
        parallaxTableView.dataSource = self
        parallaxTableView.rowHeight = 180

        //サンプルデータをCellModelに投入する
        models.append(
            CellModel(
                title: "Happy Faces",
                desc: "The feeling of a smile and thanks.",
                imageName: "image1"
            )
        )
        models.append(
            CellModel(
                title: "Wedding Dress",
                desc: "The fine weather figure which remains in the memory.",
                imageName: "image2"
            )
        )
        models.append(
            CellModel(
                title: "Beautiful Dinner",
                desc: "With a feeling of the hospitality.",
                imageName: "image3"
            )
        )
        models.append(
            CellModel(
                title: "Wedding Cake",
                desc: "Collaboration first in couples for the first time.",
                imageName: "image4"
            )
        )
        models.append(
            CellModel(
                title: "Pair Rings",
                desc: "As proof to promise everlasting love to.",
                imageName: "image5"
            )
        )

        //Xibのクラスを読み込む宣言を行う
        let nibDefault:UINib = UINib(nibName: "ParallaxTableViewCell", bundle: nil)
        parallaxTableView.registerNib(nibDefault, forCellReuseIdentifier: "ParallaxTableViewCell")
        
        //ボタンの丸さをつくる
        goSecondButton.layer.cornerRadius = CGFloat(30)
    }

    //ライブラリ「Gecco」を介して表示されるコントローラーを表示するアクション
    @IBAction func descriptionAlertAction(sender: AnyObject) {
        doDescriptionAlert()
    }
    
    @IBAction func newinfoAlertAction(sender: AnyObject) {
        doNewinfoAlert()
    }

    //ライブラリ「Gecco」を介して表示されるコントローラーを決める
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

    //BubbleTransitionを利用したセグエの設定
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        let controller = segue.destinationViewController
        controller.transitioningDelegate = self
        controller.modalPresentationStyle = .Custom
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

/**
 * BubbleTransitionのための設定をUIViewControllerTransitioningDelegateに記述
 * JFYI: https://github.com/andreamazz/BubbleTransition
 */
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

//UITableViewで発火するUIScrollViewDelegateを拡張する
extension ViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(scrollView: UIScrollView) {

        //パララックスをするテーブルビューの場合は画面に表示されているセルの画像のオフセット値を変更する
        if scrollView == parallaxTableView {
            for indexPath in parallaxTableView.indexPathsForVisibleRows! {
                setCellImageOffset(parallaxTableView.cellForRowAtIndexPath(indexPath) as! ParallaxTableViewCell, indexPath: indexPath)
            }
        }
    }

    //まだ表示されていないセルに対しても同様の効果をつける
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let imageCell = cell as! ParallaxTableViewCell
        setCellImageOffset(imageCell, indexPath: indexPath)
    }

    //UITableViewCell内のオフセット値を再計算して視差効果をつける
    private func setCellImageOffset(cell: ParallaxTableViewCell, indexPath: NSIndexPath) {
        
        let cellFrame = parallaxTableView.rectForRowAtIndexPath(indexPath)
        let cellFrameInTable = parallaxTableView.convertRect(cellFrame, toView: parallaxTableView.superview)
        let cellOffset = cellFrameInTable.origin.y + cellFrameInTable.size.height
        let tableHeight = parallaxTableView.bounds.size.height + cellFrameInTable.size.height
        let cellOffsetFactor = cellOffset / tableHeight
        
        cell.setBackgroundOffset(cellOffsetFactor)
    }
}

//UITableViewのDelegate/DataSourceを拡張する
extension ViewController: UITableViewDelegate {}
extension ViewController: UITableViewDataSource {
    
    //テーブルの要素数を設定する ※必須
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionCount
    }
    
    //テーブルの行数を設定する ※必須
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        //FIXME: 仮データ時の実装なので実データと連携する際は修正する
        if section == 0 {
            return models.count * 10
        }
        return 0
    }

    //表示するセルの中身を設定する ※必須
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ParallaxTableViewCell") as? ParallaxTableViewCell
        
        //CellModelの値を
        cell!.model = modelAtIndexPath(indexPath)

        //セルのアクセサリタイプの設定
        cell!.accessoryType = UITableViewCellAccessoryType.None
        cell!.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell!
    }

    //indexPath.rowの値に合致するCellModelの値を選択する
    func modelAtIndexPath(indexPath: NSIndexPath) -> CellModel {
        return self.models[indexPath.row % self.models.count]
    }
}
