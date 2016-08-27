//
//  CellModel.swift
//  LittleRichUISample
//
//  Created by 酒井文也 on 2016/08/27.
//  Copyright © 2016年 just1factory. All rights reserved.
//

//ParallaxTableViewCellに値を渡すモデル
class CellModel {

    //変数
    var title: String
    var desc: String
    var imageName: String

    //初期化
    init(title: String, desc: String, imageName: String) {
        self.title = title
        self.desc = desc
        self.imageName = imageName
    }
    
}
