//
//  ViewController.swift
//  Deck
//
//  Created by Tibor Beke on 05/05/2018.
//  Copyright © 2018 Tibor Beke. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    var deck = DeckWidget()
    
    var initialCenter = [CardView:CGPoint]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for (card, widget) in deck.cards {
            let view = CardView(frame: CGRect(origin: self.view.center, size: CGSize(width: 150, height: 220)))
            view.associatedCard = card
            view.color = widget.color
            view.emoji = widget.emoji
            view.rotation = widget.rotation
            view.center = self.view.center
            view.backgroundColor = UIColor.clear
            widget.position = self.view.subviews.count
            self.view.addSubview(view)
            
        }
        enableGestures(on: self.view.subviews.last!)
    }
    
    fileprivate func enableGestures(on view: UIView) {
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(drag(_:))))
        view.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(pinch(_:))))
        view.addGestureRecognizer(UIRotationGestureRecognizer(target: self, action: #selector(rotate(_:))))
        view.gestureRecognizers?.forEach({ $0.delegate = self })
    }
    
    fileprivate func disableGestures(on view: UIView) {
        view.gestureRecognizers = nil
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: duration,
                                                       delay: 0,
                                                       options:[],
                                                       animations: {
                    self.view.subviews.forEach() {view in view.center = self.view.center}
        })
    }
    
    // MARK: - UIGestureRecognizer Actions
    @objc func drag(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard let cardView = gestureRecognizer.view as? CardView else {return}
        // Get the changes in the X and Y directions relative to
        // the superview's coordinate space.
        let translation = gestureRecognizer.translation(in: cardView.superview)
        if gestureRecognizer.state == .began {
            // Save the view's original position.
            initialCenter[cardView] = cardView.center
        }
        // Update the position for the .began, .changed, and .ended states
        if gestureRecognizer.state != .cancelled {
            // Add the X and Y translation to the view's original position.
            let newCenter = CGPoint(x: initialCenter[cardView]!.x + translation.x, y: initialCenter[cardView]!.y + translation.y)
            cardView.center = newCenter
        }
        else {
            // On cancellation, return the piece to its original location.
            cardView.center = initialCenter[cardView]!
        }
        
        switch gestureRecognizer.state {
        case .ended:
            interactionEnded(with: cardView)
        default: break

        }
    }
    
    @objc func rotate(_ gestureRecognizer: UIRotationGestureRecognizer) {
        guard let cardView = gestureRecognizer.view as? CardView else { return }
        
        switch gestureRecognizer.state {
        case .began, .changed:
            cardView.transform = cardView.transform.rotated(by: gestureRecognizer.rotation)
            gestureRecognizer.rotation = 0
        case .ended:
            interactionEnded(with: cardView)
        default: break
        }
    }
    
    @objc func pinch(_ gestureRecognizer: UIPinchGestureRecognizer) {
        guard let cardView = gestureRecognizer.view as? CardView else { return }
        
        switch gestureRecognizer.state {
        case .began, .changed:
            cardView.transform = (cardView.transform.scaledBy(x: gestureRecognizer.scale, y: gestureRecognizer.scale))
            gestureRecognizer.scale = 1.0
        case .ended:
            interactionEnded(with: cardView)
        default: break
        
        }
    }
    
    // MARK: UIGestureRecognizerDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer)
        -> Bool {
            return true
    }
    
    private func interactionEnded(with card: CardView) {
        var ended = false
        
        card.gestureRecognizers?.forEach({ recognizer in
            if (recognizer.state != .began && recognizer.state != .changed) {
                ended = true
            } else {
                ended = false
            }
        })
        
        if ended != true {
            return
            
        }
        
        disableGestures(on: card)
        enableGestures(on: self.view.subviews[self.view.subviews.index(of: card)!-1])
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: duration,
                                                       delay: 0,
                                                       options:[],
                                                       animations: {
                                                        card.center = self.view.bounds.origin
                                                        card.transform = CGAffineTransform.identity
        },
                                                       completion: { _ in
                                                        UIViewPropertyAnimator.runningPropertyAnimator(
                                                            withDuration: self.duration,
                                                            delay: 0,
                                                            options: [],
                                                            animations: {
                                                                card.transform = card.transform.rotated(by: self.deck.cards[card.associatedCard!]!.rotation)
                                                                self.view.sendSubview(toBack: card)
                                                                self.deck.cards[card.associatedCard!]!.position = self.view.subviews.index(of: card)!
                                                                card.center = self.view.center
                                                        })
        })
    }
}

extension ViewController {
    var duration : Double { return 0.6 }
}

