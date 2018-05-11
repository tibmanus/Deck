//
//  CardView.swift
//  Deck
//
//  Created by Tibor Beke on 05/05/2018.
//  Copyright © 2018 Tibor Beke. All rights reserved.
//

import UIKit

@IBDesignable
class CardView: UIView
{
    var associatedCard : Card!
    
    @IBInspectable
    var emoji: String = "❤️" { didSet { setNeedsDisplay(); setNeedsLayout() } }
    
    @IBInspectable
    var color: UIColor = UIColor.cyan { didSet { setNeedsDisplay(); setNeedsLayout() } }
    
    var rotation: CGFloat = 0 { didSet {
        self.transform = self.transform.rotated(by: self.rotation)
        }
    }
    
    private func drawEmoji()
    {
        let font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributedString = NSAttributedString(string: emoji, attributes: [.paragraphStyle:paragraphStyle,.font:font])
        
        var stringRect = bounds
        stringRect.origin.y = stringRect.size.height/2 - attributedString.size().height/2
        attributedString.draw(in: stringRect)
    }
    
    private func drawCorners() {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        roundedRect.addClip()
        self.color.setFill()
        roundedRect.fill()
    }
    
    override func draw(_ rect: CGRect) {
        drawCorners()
        drawEmoji()

        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowOpacity = 0.3
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
    }
}

extension CardView {
    private struct SizeRatio {
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
    }
    private var fontSize : CGFloat { return 108 }
    private var cornerRadius: CGFloat {
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }
}
