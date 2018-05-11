//
//  ViewController.swift
//  Deck
//
//  Created by Tibor Beke on 05/05/2018.
//  Copyright © 2018 Tibor Beke. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var deck = Deck()
    
    var initialCenter = [CardView:CGPoint]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addCards()
    }
    
    fileprivate func addCards() {
        for card in deck.cards {
            let view = CardView(frame: CGRect(origin: self.view.center, size: CGSize(width: 150, height: 220)))
            view.associatedCard = card
            view.color = card.color
            view.emoji = card.emoji
            view.rotation = card.rotation
            view.center = self.view.center
            view.backgroundColor = UIColor.clear
            card.position = self.view.subviews.count
            self.view.addSubview(view)
        }
        enableGestures(on: self.view.subviews.last)
    }
    
    fileprivate func enableGestures(on view: UIView?) {
        view?.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(drag(_:))))
        view?.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(pinch(_:))))
        view?.addGestureRecognizer(UIRotationGestureRecognizer(target: self, action: #selector(rotate(_:))))
        view?.gestureRecognizers?.forEach({ recognizer in recognizer.delegate = self })
    }
    
    fileprivate func disableGestures(on view: UIView) {
        view.gestureRecognizers = nil
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { context in
            self.view.subviews.forEach() { view in
                if let superview = view.superview {
                    view.center = superview.center
                }
            }
        }, completion: nil)
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
            guard let iC = initialCenter[cardView] else {
                fatalError("You forgot to add this card's initial position when the gesture started.")
            }
            let newCenter = CGPoint(x: iC.x + translation.x, y: iC.y + translation.y)
            cardView.center = newCenter
        }
        else {
            // On cancellation, return the piece to its original location.
            guard let iC = initialCenter[cardView] else {
                fatalError("You forgot to add this card's initial position when the gesture started.")
            }
            cardView.center = iC
        }
        
        if gestureRecognizer.state == .ended {
            handleEndOfInteraction(with: cardView)
        }
    }
    
    @objc func rotate(_ gestureRecognizer: UIRotationGestureRecognizer) {
        guard let cardView = gestureRecognizer.view as? CardView else { return }
        
        switch gestureRecognizer.state {
        case .began, .changed:
            cardView.transform = cardView.transform.rotated(by: gestureRecognizer.rotation)
            gestureRecognizer.rotation = 0
        case .ended:
            handleEndOfInteraction(with: cardView)
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
            handleEndOfInteraction(with: cardView)
        default: break
            
        }
    }
    
    private func isInteractionEnded(for card: CardView) -> Bool {
        var ended = false
        
        card.gestureRecognizers?.forEach({ recognizer in
            if (recognizer.state != .began && recognizer.state != .changed) {
                ended = true
            } else {
                ended = false
            }
        })
        
        return ended
    }
    
    private func handleEndOfInteraction(with card: CardView) {
        if isInteractionEnded(for: card) != true {
            return
        }
        
        disableGestures(on: card)
        if let index = self.view.subviews.index(of: card), index > 0 {
            enableGestures(on: self.view.subviews[index-1])
        }
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
                                                                if let index = self.deck.cards.index(of: card.associatedCard)
                                                                {
                                                                    card.transform = card.transform.rotated(by: self.deck.cards[index].rotation)
                                                                    self.view.sendSubview(toBack: card)
                                                                    if let index = self.view.subviews.index(of: card) {
                                                                        self.deck.cards[index].position = index
                                                                    } else {
                                                                        self.deck.cards[index].position = -1
                                                                    }
                                                                    card.center = self.view.center
                                                                }
                                                        })
        })
    }
    
    // MARK: UIGestureRecognizerDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer)
        -> Bool {
            return true
    }
    
}

extension ViewController {
    var duration : Double { return 0.6 }
}
