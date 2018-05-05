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
    @IBInspectable
    var emoji: String = "❤️" { didSet { setNeedsDisplay(); setNeedsLayout() } }
    
    @IBInspectable
    var color: UIColor = UIColor.cyan { didSet { setNeedsDisplay(); setNeedsLayout() } }
    
    var delegate : CardViewDelegate?
    
    var initialCenter = CGPoint()  // The initial center point of the view.
    var pinchEnded : Bool = true { didSet {
        self.interactionEnded()
        }
    }
    var dragEnded : Bool = true { didSet {
        self.interactionEnded()
        }
    }
    var rotateEnded : Bool = true { didSet {
        self.interactionEnded()
        }
    }
    
    private func interactionEnded() {
        if pinchEnded && dragEnded && rotateEnded {
            delegate?.interactionEnded(with: self)
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsDisplay()
        setNeedsLayout()
    }
    
    private func drawEmoji()
    {
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(54)
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let pipString = NSAttributedString(string: emoji, attributes: [.paragraphStyle:paragraphStyle,.font:font])
        
        var pipRect = bounds
        pipRect.size.height = pipString.size().height
        pipRect.origin.y += (pipRect.size.height) / 2
        pipString.draw(in: pipRect)
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
    }
}

protocol CardViewDelegate {
    func interactionEnded(with card: CardView)
}

extension CardView {
    private struct SizeRatio {
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
    }
    private var cornerRadius: CGFloat {
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }
}
