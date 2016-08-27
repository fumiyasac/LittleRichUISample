//
//  ParallaxTableViewCell.swift
//  LittleRichUISample
//
//  Created by 酒井文也 on 2016/08/27.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit

class ParallaxTableViewCell: UITableViewCell {

    //セルに配置されたUI部品
    @IBOutlet weak var backgroundCellImage: UIImageView!
    @IBOutlet weak var titleCellLabel: UILabel!
    @IBOutlet weak var descriptionCellLabel: UILabel!

    //画像の上の制約（backgroundCellImageの上の制約を「Ctrl+ドラッグ」でOutlet接続をする）
    @IBOutlet weak var imgTopConstraint: NSLayoutConstraint!

    //画像の下の制約（backgroundCellImageの下の制約を「Ctrl+ドラッグ」でOutlet接続をする）
    @IBOutlet weak var imgBottomConstraint: NSLayoutConstraint!

    //視差効果のズレを生むための定数（大きいほど視差効果が大きい）
    let imageParallaxFactor: CGFloat = 100

    //視差効果の計算用の変数
    var imgBackTopInitial: CGFloat!
    var imgBackBottomInitial: CGFloat!

    //CellModelに値がセットされたら各部品にその値を格納する
    var model: CellModel! {
        didSet {
            updateView()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        //意図的にずらした値を視差効果の計算用の変数にそれぞれ格納する
        clipsToBounds = true
        imgBottomConstraint.constant -= 2 * imageParallaxFactor
        imgBackTopInitial = imgTopConstraint.constant
        imgBackBottomInitial = imgBottomConstraint.constant
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    //セルに配置した部品の中に値を入れる
    func updateView() {
        backgroundCellImage.image = UIImage(named: model.imageName)
        descriptionCellLabel.text = model.desc
        titleCellLabel.text = model.title
    }

    //backgroundCellImageにかけられているAutoLayoutの制約を再計算して制約をかけ直す
    func setBackgroundOffset(offset: CGFloat) {
        let boundOffset = max(0, min(1, offset))
        let pixelOffset = (1 - boundOffset) * 2 * imageParallaxFactor
        imgTopConstraint.constant = imgBackTopInitial - pixelOffset
        imgBottomConstraint.constant = imgBackBottomInitial + pixelOffset
    }

}
