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
    
    @IBOutlet weak var Smile: SmileView! {
        didSet{
            updateUI()
        }
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

