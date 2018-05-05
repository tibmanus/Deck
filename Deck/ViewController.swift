//
//  ViewController.swift
//  Deck
//
//  Created by Tibor Beke on 05/05/2018.
//  Copyright © 2018 Tibor Beke. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate, CardViewDelegate {

    @IBOutlet var deck: [CardView]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for card in deck {
            card.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(drag(_:))))
            card.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(pinch(_:))))
            card.addGestureRecognizer(UIRotationGestureRecognizer(target: self, action: #selector(rotate(_:))))
            card.gestureRecognizers?.forEach({ $0.delegate = self })
            card.delegate = self
        }
    }
    
    // MARK: - UIGestureRecognizer Actions
    @objc func drag(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard let cardView = gestureRecognizer.view as? CardView else {return}
        // Get the changes in the X and Y directions relative to
        // the superview's coordinate space.
        let translation = gestureRecognizer.translation(in: cardView.superview)
        if gestureRecognizer.state == .began {
            // Save the view's original position.
            cardView.initialCenter = cardView.center
        }
        // Update the position for the .began, .changed, and .ended states
        if gestureRecognizer.state != .cancelled {
            // Add the X and Y translation to the view's original position.
            let newCenter = CGPoint(x: cardView.initialCenter.x + translation.x, y: cardView.initialCenter.y + translation.y)
            cardView.center = newCenter
        }
        else {
            // On cancellation, return the piece to its original location.
            cardView.center = cardView.initialCenter
        }
        
        switch gestureRecognizer.state {
        case .began, .changed:
            cardView.dragEnded = false
        case .ended:
            cardView.dragEnded = true
        default:
            break
        }
    }
    
    @objc func rotate(_ gestureRecognizer: UIRotationGestureRecognizer) {
        guard let cardView = gestureRecognizer.view as? CardView else { return }
        
        switch gestureRecognizer.state {
        case .began, .changed:
            cardView.rotateEnded = false
            cardView.transform = cardView.transform.rotated(by: gestureRecognizer.rotation)
            gestureRecognizer.rotation = 0
        case .ended:
            cardView.rotateEnded = true
        default: break
        }
    }
    
    @objc func pinch(_ gestureRecognizer: UIPinchGestureRecognizer) {
        guard let cardView = gestureRecognizer.view as? CardView else { return }
        
        switch gestureRecognizer.state {
        case .began, .changed:
            cardView.pinchEnded = false
            cardView.transform = (cardView.transform.scaledBy(x: gestureRecognizer.scale, y: gestureRecognizer.scale))
            gestureRecognizer.scale = 1.0
        case .ended:
            cardView.pinchEnded = true
        default: break
        }
    }
    
    // MARK: UIGestureRecognizerDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer)
        -> Bool {
            return true
    }
    
    // MARK: - CardViewDelegate
    func interactionEnded(with card: CardView) {
        NSLog("interaction ended with \(card)")
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.6,
                                                       delay: 0,
                                                       options:[],
                                                       animations: {
                                                        card.center = self.view.bounds.origin
                                                        },
                                                       completion: { position in
                                                        UIViewPropertyAnimator.runningPropertyAnimator(
                                                            withDuration: 0.6,
                                                            delay: 0,
                                                            options: [],
                                                            animations: {
                                                                self.view.sendSubview(toBack: card)
                                                                card.center = self.view.center
                                                        })
        })
    }
    
}

extension CGRect {
    func zoom(by scale: CGFloat) -> CGRect {
        let newWidth = width * scale
        let newHeight = height * scale
        return insetBy(dx: (width - newWidth) / 2, dy: (height - newHeight) / 2)
    }
}

