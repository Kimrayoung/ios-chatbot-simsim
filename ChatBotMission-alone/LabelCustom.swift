//
//  PaddingLabelCustom.swift
//  ChatBotMission-alone
//
//  Created by 김라영 on 2023/02/02.
//

import Foundation
import UIKit

class PadddingLabel: UILabel {
    @IBInspectable var topPadding: CGFloat = 10.0
    @IBInspectable var bottomPadding: CGFloat = 10.0
    @IBInspectable var leftPadding: CGFloat = 10.0
    @IBInspectable var rightPadding: CGFloat = 10.0
    
    //label의 text를 그려줄 때 사용한다
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topPadding, left: leftPadding, bottom: bottomPadding, right: rightPadding)
        //재정의
        super.drawText(in: rect.inset(by: insets))
    }
    
    //label은 instrinsicContentSize를 사용해서 텍스트의 높이와 길이에 따라서 가로 너비를 결정한다
    //즉, instrinsicContentSize 덕분에 따로 UILabel의 크기를 정해주지 않아도 ios가 자동으로 너비를 설정해준디
    //하지만 drawText로 text를 그려줄 때 padding을 그려줬으므로 뷰의 길이가 달라졌다
    //그걸 맞춰줘야 한다 -> padding의 사이즈만큼 크기를 더해주면 된다
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftPadding + rightPadding, height: size.height + topPadding + bottomPadding)
    }
    
    //패딩이 포함된 bounds를 설정해준다
    override var bounds: CGRect {
        didSet{ preferredMaxLayoutWidth = bounds.width - (leftPadding + rightPadding)}
    }
}

