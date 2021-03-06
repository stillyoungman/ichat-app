//
//  SpeechBubble.swift
//  iChat
//
//  Created by Constantine Nikolsky on 03.10.2020.
//  Copyright © 2020 . All rights reserved.
//
//  Generated by PaintCode
//  http://www.paintcodeapp.com
//

import UIKit

public class SpeechBubblePath: NSObject {

    public class func draw(frame: CGRect = CGRect(x: 0, y: -0, width: 184, height: 30), _ c: UIColor? = nil) -> UIBezierPath {
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: frame.maxX - 10, y: frame.maxY - 18.15))
        bezierPath.addCurve(to: CGPoint(x: frame.maxX - 2.53, y: frame.maxY - 10.27),
                            controlPoint1: CGPoint(x: frame.maxX - 10, y: frame.maxY - 13.77),
                            controlPoint2: CGPoint(x: frame.maxX - 7.51, y: frame.maxY - 12.02))
        bezierPath.addLine(to: CGPoint(x: frame.maxX - 2, y: frame.maxY - 10.08))
        bezierPath.addCurve(to: CGPoint(x: frame.maxX - 1.6, y: frame.maxY - 9),
                            controlPoint1: CGPoint(x: frame.maxX - 1.48, y: frame.maxY - 9.91),
                            controlPoint2: CGPoint(x: frame.maxX - 1.41, y: frame.maxY - 9.47))
        bezierPath.addCurve(to: CGPoint(x: frame.maxX - 1.97, y: frame.maxY - 8.57),
                            controlPoint1: CGPoint(x: frame.maxX - 1.67, y: frame.maxY - 8.83),
                            controlPoint2: CGPoint(x: frame.maxX - 1.8, y: frame.maxY - 8.68))
        bezierPath.addCurve(to: CGPoint(x: frame.maxX - 10, y: frame.maxY - 6.04),
                            controlPoint1: CGPoint(x: frame.maxX - 3.73, y: frame.maxY - 7.49),
                            controlPoint2: CGPoint(x: frame.maxX - 6.08, y: frame.maxY - 6.21))
        bezierPath.addCurve(to: CGPoint(x: frame.maxX - 18, y: frame.maxY - 2),
                            controlPoint1: CGPoint(x: frame.maxX - 11.13, y: frame.maxY - 3.3),
                            controlPoint2: CGPoint(x: frame.maxX - 14.56, y: frame.maxY - 2))
        bezierPath.addLine(to: CGPoint(x: frame.minX + 10, y: frame.maxY - 2))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 2, y: frame.maxY - 9.18),
                            controlPoint1: CGPoint(x: frame.minX + 5.58, y: frame.maxY - 2),
                            controlPoint2: CGPoint(x: frame.minX + 2, y: frame.maxY - 5.21))
        bezierPath.addLine(to: CGPoint(x: frame.minX + 2, y: frame.minY + 9.18))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 10, y: frame.minY + 2),
                            controlPoint1: CGPoint(x: frame.minX + 2, y: frame.minY + 5.21),
                            controlPoint2: CGPoint(x: frame.minX + 5.58, y: frame.minY + 2))
        bezierPath.addLine(to: CGPoint(x: frame.maxX - 18, y: frame.minY + 2))
        bezierPath.addCurve(to: CGPoint(x: frame.maxX - 10, y: frame.minY + 9.18),
                            controlPoint1: CGPoint(x: frame.maxX - 13.58, y: frame.minY + 2),
                            controlPoint2: CGPoint(x: frame.maxX - 10, y: frame.minY + 5.21))
        bezierPath.addLine(to: CGPoint(x: frame.maxX - 10, y: frame.maxY - 18.15))
        bezierPath.close()
        bezierPath.usesEvenOddFillRule = true
        return bezierPath
    }

}
