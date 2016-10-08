//
//  ViewController.swift
//  LittleRichUISample
//
//  Created by 酒井文也 on 2016/08/26.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit
import BubbleTransition

class ViewController: UIViewController, UIViewControllerTransitioningDelegate {

    @IBOutlet weak var goSecondButton: UIButton!
    @IBOutlet weak var parallaxTableView: UITableView!

    //ライブラリ「BubbleTransition」のインスタンスを作る
    fileprivate let transition = BubbleTransition()

    //セルのセクション数
    fileprivate let sectionCount = 1

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
        parallaxTableView.register(nibDefault, forCellReuseIdentifier: "ParallaxTableViewCell")
        
        //ボタンの丸さをつくる
        goSecondButton.layer.cornerRadius = CGFloat(30)
    }

    //ライブラリ「Gecco」を介して表示されるコントローラーを表示するアクション
    @IBAction func descriptionAlertAction(_ sender: AnyObject) {
        doDescriptionAlert()
    }
    
    @IBAction func newinfoAlertAction(_ sender: AnyObject) {
        doNewinfoAlert()
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        transition.transitionMode = .present
        transition.startingPoint = goSecondButton.center
        transition.bubbleColor = goSecondButton.backgroundColor!
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        transition.transitionMode = .dismiss
        transition.startingPoint = goSecondButton.center
        transition.bubbleColor = goSecondButton.backgroundColor!
        return transition
    }
    
    //ライブラリ「Gecco」を介して表示されるコントローラーを決める
    fileprivate func doDescriptionAlert() {

        let descriptionViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DescriptionAlert") as! DescriptionViewController
        descriptionViewController.alpha = 0.75
        present(descriptionViewController, animated: true, completion: nil)
    }

    fileprivate func doNewinfoAlert() {

        let newinfoViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewinfoAlert") as! NewinfoViewController
        newinfoViewController.alpha = 0.75
        present(newinfoViewController, animated: true, completion: nil)
    }

    //BubbleTransitionを利用したセグエの設定
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let controller = segue.destination
        controller.transitioningDelegate = self
        controller.modalPresentationStyle = .custom
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

/**
 * BubbleTransitionのための設定をUIViewControllerTransitioningDelegateに記述
 * JFYI: https://github.com/andreamazz/BubbleTransition
 */
/*
extension ViewController: UIViewControllerTransitioningDelegate {

}
*/

//UITableViewで発火するUIScrollViewDelegateを拡張する
extension ViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        //パララックスをするテーブルビューの場合は画面に表示されているセルの画像のオフセット値を変更する
        if scrollView == parallaxTableView {
            for indexPath in parallaxTableView.indexPathsForVisibleRows! {
                setCellImageOffset(parallaxTableView.cellForRow(at: indexPath) as! ParallaxTableViewCell, indexPath: indexPath)
            }
        }
    }

    //まだ表示されていないセルに対しても同様の効果をつける
    @objc(tableView:willDisplayCell:forRowAtIndexPath:) func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let imageCell = cell as! ParallaxTableViewCell
        setCellImageOffset(imageCell, indexPath: indexPath)
    }

    //UITableViewCell内のオフセット値を再計算して視差効果をつける
    fileprivate func setCellImageOffset(_ cell: ParallaxTableViewCell, indexPath: IndexPath) {
        
        let cellFrame = parallaxTableView.rectForRow(at: indexPath)
        let cellFrameInTable = parallaxTableView.convert(cellFrame, to: parallaxTableView.superview)
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionCount
    }
    
    //テーブルの行数を設定する ※必須
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        //FIXME: 仮データ時の実装なので実データと連携する際は修正する
        if section == 0 {
            return models.count * 10
        }
        return 0
    }

    //表示するセルの中身を設定する ※必須
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ParallaxTableViewCell") as? ParallaxTableViewCell
        
        //CellModelの値を
        cell!.model = modelAtIndexPath(indexPath)

        //セルのアクセサリタイプの設定
        cell!.accessoryType = UITableViewCellAccessoryType.none
        cell!.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell!
    }

    //indexPath.rowの値に合致するCellModelの値を選択する
    func modelAtIndexPath(_ indexPath: IndexPath) -> CellModel {
        return self.models[(indexPath as NSIndexPath).row % self.models.count]
    }
}
