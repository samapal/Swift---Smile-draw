//
//  ViewController.swift
//  Smile
//
//  Created by Dmitry Faddeev on 08/06/16.
//  Copyright © 2016 Vladimir Nefedov. All rights reserved.
//

import UIKit

class SmileViewController: UIViewController {

    var expression = smileExpression(eyes: .Open, eyeBrows: .Normal, mouth: .Smile)
    {
        didSet{
            updateUI()
            
        }
    }
    
    @IBAction func openEyes(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            switch expression.eyes {
            case .Open:
                expression.eyes = .Closed
            case .Closed:
                expression.eyes = .Open
            case .Squinting:
                break
            }
        }
    }
    @IBOutlet weak var Smile: SmileView! {
        didSet{
            Smile.addGestureRecognizer(
                UIPinchGestureRecognizer(target: Smile, action: #selector(Smile.changeScale(_:)))
                )
            let happierSwipeGestureRecognizer = UISwipeGestureRecognizer(
                target: self, action: #selector(SmileViewController.increaseHappiness))
            happierSwipeGestureRecognizer.direction = .Up
            Smile.addGestureRecognizer(happierSwipeGestureRecognizer)
            
            let sadSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(SmileViewController.increaseSad))
            sadSwipeGestureRecognizer.direction = .Down
            Smile.addGestureRecognizer(sadSwipeGestureRecognizer)
            updateUI()
        }
    }
    
    func increaseSad(){
        expression.mouth = expression.mouth.sadderMouth()
    }
    func increaseHappiness(){
       expression.mouth = expression.mouth.happierMouth()
    }
    
    private let mouthCurvatures = [smileExpression.Mouth.Frow:-1,
                                   smileExpression.Mouth.Grin:-0.5,
                                   smileExpression.Mouth.Neutral:0.0,
                                   smileExpression.Mouth.Smirk:0.5,
                                   smileExpression.Mouth.Smile:1]
    private let eyeBrowTilts = [smileExpression.EyeBrows.Furrowed:-1,
                                smileExpression.EyeBrows.Normal:0.0,
                                smileExpression.EyeBrows.Relaxed:1.0]
    
    private func updateUI(){
        switch expression.eyes {
        case .Open:
            Smile.eyesOpen = true
        case .Closed:
            Smile.eyesOpen = false
        case .Squinting:
            Smile.eyesOpen = false
        }
        Smile.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0.0
        Smile.eyeBrowTilt = eyeBrowTilts[expression.eyeBrows] ?? 0.0
        
        
        
    }

}

