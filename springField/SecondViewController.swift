//
//  SecondViewController.swift
//  NavTest
//
//  Created by Alexey on 01.05.2020.
//  Copyright © 2020 Alexey. All rights reserved.
//

import UIKit
import SpriteKit
class SecondViewController: ViewController {
    
    
    
    @IBOutlet weak var thisPlusButton: UIButton!
    @IBAction func plusButton(_ sender: Any) {
        if containerView.isHidden{
            setView(view: containerView, hidden: false)
            return
        }
        setView(view: containerView, hidden: true)
    }
    @IBOutlet weak var containerView: UIView!
    lazy var dynamicAnimator: UIDynamicAnimator =
        {
        let dynamicAnimator = UIDynamicAnimator(referenceView: self.view)
        return dynamicAnimator
    }()
    
    lazy var collision: UICollisionBehavior =
    {
        let collision = UICollisionBehavior(items: [self.containerView])
        collision.translatesReferenceBoundsIntoBoundary = true
        return collision
    }()
    
    lazy var fieldBehaviors: [UIFieldBehavior] =
    {
        var fieldBehaviors = [UIFieldBehavior]()
        for _ in 0 ..< 2
        {
            let field = UIFieldBehavior.springField()
            field.addItem(self.containerView)
            fieldBehaviors.append(field)
        }
        return fieldBehaviors
    }()
    
    lazy var itemBehavior: UIDynamicItemBehavior =
    {
        let itemBehavior = UIDynamicItemBehavior(items: [self.containerView])
        // Adjust these values to change the "stickiness" of the view
        itemBehavior.density = 0.01
        itemBehavior.resistance = 10
        itemBehavior.friction = 0.0
        itemBehavior.allowsRotation = false
        return itemBehavior
    }()
    
    
    lazy var panGesture: UIPanGestureRecognizer =
    {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(sender:)))
        return panGesture
    }()
    
    lazy var attachment: UIAttachmentBehavior =
    {
        let attachment = UIAttachmentBehavior(item: self.containerView, attachedToAnchor: .zero)
        return attachment
    }()
    
    func setView(view: UIView, hidden: Bool) {

        UIView.transition(with: view, duration: 0.5, options: hidden ? .transitionFlipFromLeft : .transitionFlipFromRight, animations: {
            if !hidden{
                view.alpha = 1
                view.isHidden = hidden
            }
            else{
                view.alpha = 0
            }
        }, completion: { _ in
            if hidden{
                view.isHidden = true
            }
        } )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.containerView.isHidden = true
        thisPlusButton.layer.cornerRadius = 25
        title = "Non main"
        dynamicAnimator.addBehavior(collision)
        dynamicAnimator.addBehavior(itemBehavior)
        for field in fieldBehaviors
        {
            dynamicAnimator.addBehavior(field)
        }
        // some ad
        self.containerView.addGestureRecognizer(panGesture)
        
    }
}
extension SecondViewController{
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        
        dynamicAnimator.updateItem(usingCurrentState: containerView)
        
        fieldBehaviors[0].position = CGPoint(x: 20 + containerView.frame.width / 2, y: 20 + containerView.frame.height / 2)
        fieldBehaviors[0].region = UIRegion(size: CGSize(width: (view.bounds.width / 2) + 20  , height: (view.frame.height / 2) + 20 ))
        fieldBehaviors[1].position = CGPoint(x: 20 + containerView.frame.width / 2, y: -20 + view.bounds.height - containerView.bounds.height / 2)
        fieldBehaviors[1].region = UIRegion(size: CGSize(width: (view.bounds.width / 2) + 20  , height: (view.frame.height / 2) + 20 ))
        
        
    }
    
    @objc func handlePan(sender: UIPanGestureRecognizer)
    {
        let location = sender.location(in: view)
        let velocity = sender.velocity(in: view)
        switch sender.state
        {
        case .began:
            attachment.anchorPoint = location
            dynamicAnimator.addBehavior(attachment)
        case .changed:
            attachment.anchorPoint = location
        case .cancelled, .ended, .failed, .possible:
            itemBehavior.addLinearVelocity(velocity, for: self.containerView)
            dynamicAnimator.removeBehavior(attachment)
        }
    }
}


