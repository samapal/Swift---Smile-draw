//
//  SmileView.swift
//  Smile
//
//  Created by Dmitry Faddeev on 08/06/16.
//  Copyright © 2016 Vladimir Nefedov. All rights reserved.
//

import UIKit

@IBDesignable
class SmileView: UIView {

    @IBInspectable
    var scale: CGFloat = 0.9 { didSet{setNeedsDisplay()}}
    @IBInspectable
    var mouthCurvature: Double = 1.0 { didSet{setNeedsDisplay()}} //1 full smile -1 full frown
    @IBInspectable
    var eyesOpen: Bool = false { didSet{setNeedsDisplay()}}
    @IBInspectable
    var eyeBrowTilt: Double = -1.0 { didSet{setNeedsDisplay()}} // -1 full furrow, 1 fully relax
    @IBInspectable
    var color: UIColor = UIColor.blueColor() { didSet{setNeedsDisplay()}}
    @IBInspectable
    var lineWidth: CGFloat = 5.0 { didSet{setNeedsDisplay()}}
    
    func changeScale(recognizer: UIPinchGestureRecognizer){
        switch recognizer.state {
        case .Changed, .Ended:
            scale *= recognizer.scale
            recognizer.scale = 1.0
        default:
            break
        }
    }
    
    private var skullRadius: CGFloat {
       return min(bounds.size.width,bounds.size.height)/2*scale
    }

    private var skullCenter: CGPoint {
     return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    private struct Ratios {
        static let ScullRadiusToEyeOffset: CGFloat = 3
        static let ScullRadiusToEyeRadius: CGFloat = 10
        static let ScullRadiusToMouthWidth: CGFloat = 1
        static let ScullRadiusToMouthHeigth: CGFloat = 3
        static let ScullRadiusToMouthOffset: CGFloat = 3
        static let ScullRadiusToBrowOffset: CGFloat = 5
    }
    
    private enum Eye {
       case left
       case rigth
    }
    
    private func pathForCircleCentredAtPoint(midPoint withcenter: CGPoint, withRadius radius: CGFloat)->UIBezierPath {
        let path = UIBezierPath(arcCenter: withcenter, radius: radius, startAngle: 0.0, endAngle: CGFloat(2*M_PI), clockwise: false)
        path.lineWidth = lineWidth
        UIColor.blueColor().set()
        return path
        
    }
    
    private func getEyeCenter(eye:Eye)->CGPoint {
        let eyeOffset = skullRadius/Ratios.ScullRadiusToEyeOffset
        var eyeCenter = skullCenter
        eyeCenter.y -= eyeOffset
        switch eye {
        case .left:
            eyeCenter.x -= eyeOffset
        case .rigth:
            eyeCenter.x += eyeOffset
        
        }
        
       return eyeCenter
    }
    
    private func pathForEye(eye:Eye)->UIBezierPath{
      let eyeRadius = skullRadius/Ratios.ScullRadiusToEyeRadius
      let eyeCenter = getEyeCenter(eye)
       // UIColor.redColor().set()
        if eyesOpen {
         return pathForCircleCentredAtPoint(midPoint: eyeCenter, withRadius: eyeRadius)
        } else {
            let path = UIBezierPath()
            path.moveToPoint(CGPoint(x: eyeCenter.x-eyeRadius, y: eyeCenter.y))
            path.addLineToPoint(CGPoint(x: eyeCenter.x+eyeRadius, y: eyeCenter.y))
            path.lineWidth = lineWidth
            return path
        }
        
        
    }
    
    private func pathForMouth()->UIBezierPath{
        let mouthwidth = skullRadius / Ratios.ScullRadiusToMouthWidth
        let mouthHeigth = skullRadius / Ratios.ScullRadiusToMouthHeigth
        let mouthOffset = skullRadius / Ratios.ScullRadiusToMouthOffset
        
        let mouthRect = CGRect(x: skullCenter.x - mouthwidth/2, y:skullCenter.y+mouthOffset, width: mouthwidth, height: mouthHeigth)
        

        
        let smileOffset = CGFloat(max(-1, min(mouthCurvature,1)))*mouthRect.height
        let start = CGPoint(x: mouthRect.minX, y: mouthRect.minY)
        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.minY)
        let cp1 = CGPoint(x: mouthRect.minX+mouthRect.width/3, y: mouthRect.minY + smileOffset)
        let cp2 = CGPoint(x: mouthRect.maxX-mouthRect.width/3, y: mouthRect.minY+smileOffset)
        let path = UIBezierPath()
        path.moveToPoint(start)
        path.addCurveToPoint(end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWidth
        
        return path
      
    }
    
    private func pathForBrow(eye: Eye)-> UIBezierPath {
        var tilt = eyeBrowTilt
        switch eye {
        case .left:
            tilt *= -1.0
        case .rigth:
            break
        }
        var browCenter = getEyeCenter(eye)
        browCenter.y -= skullRadius / Ratios.ScullRadiusToBrowOffset
        let eyeRadius = skullRadius / Ratios.ScullRadiusToEyeRadius
        let titleOffset = CGFloat(max(-1, min(tilt,1))) * eyeRadius / 2
        let browStart = CGPoint(x: browCenter.x - eyeRadius, y: browCenter.y - titleOffset)
        let browEnd = CGPoint(x: browCenter.x + eyeRadius, y: browCenter.y + titleOffset)
        let path = UIBezierPath()
        path.moveToPoint(browStart)
        path.addLineToPoint(browEnd)
        path.lineWidth = lineWidth
        return path
    }
    
    override func drawRect(rect: CGRect) {
        // Drawing code

        color.set()
        
        pathForCircleCentredAtPoint(midPoint: skullCenter, withRadius: skullRadius).stroke()
        pathForEye(.left).stroke()
        pathForEye(.rigth).stroke()
        pathForMouth().stroke()
        pathForBrow(.left).stroke()
        pathForBrow(.rigth).stroke()
        
    }

}
