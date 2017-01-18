//
//  RambafreshViewConfiguration.swift
//  RambafreshSVG
//
//  Created by m.rakhmanov on 07.01.17.
//  Copyright © 2017 m.rakhmanov. All rights reserved.
//

import Foundation
import UIKit

struct RambafreshViewConfiguration {
    let frame: CGRect
    let animatable: RambafreshAnimatableViewConforming
    let scrollView: UIScrollView
    let animationEndDistanceOffset: CGFloat
    let animationStartDistance: CGFloat
    let handler: ActionHandler
}
