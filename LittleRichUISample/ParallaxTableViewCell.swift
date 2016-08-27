//
//  ParallaxTableViewCell.swift
//  LittleRichUISample
//
//  Created by 酒井文也 on 2016/08/27.
//  Copyright © 2016年 just1factory. All rights reserved.
//

import UIKit

class ParallaxTableViewCell: UITableViewCell {

    @IBOutlet weak var backgroundCellImage: UIImageView!
    @IBOutlet weak var titleCellLabel: UILabel!
    @IBOutlet weak var descriptionCellLabel: UILabel!

    @IBOutlet weak var imgTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgBottomConstraint: NSLayoutConstraint!

    let imageParallaxFactor: CGFloat = 80
    
    var imgBackTopInitial: CGFloat!
    var imgBackBottomInitial: CGFloat!

    var model: CellModel! {
        didSet {
            updateView()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        clipsToBounds = true
        imgBottomConstraint.constant -= 2 * imageParallaxFactor
        imgBackTopInitial = imgTopConstraint.constant
        imgBackBottomInitial = imgBottomConstraint.constant
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func updateView() {
        backgroundCellImage.image = UIImage(named: model.imageName)
        descriptionCellLabel.text = model.desc
        titleCellLabel.text = model.title
    }

    func setBackgroundOffset(offset: CGFloat) {
        let boundOffset = max(0, min(1, offset))
        let pixelOffset = (1 - boundOffset) * 2 * imageParallaxFactor
        imgTopConstraint.constant = imgBackTopInitial - pixelOffset
        imgBottomConstraint.constant = imgBackBottomInitial + pixelOffset
    }

}
