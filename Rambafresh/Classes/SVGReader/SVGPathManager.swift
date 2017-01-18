//
//  SVGPathManager.swift
//  RambafreshSVG
//
//  Created by m.rakhmanov on 01.01.17.
//  Copyright © 2017 m.rakhmanov. All rights reserved.
//

import Foundation
import UIKit

public typealias ConfigurationTime = (time: CGFloat, configuration: SVGPathConfiguration)
typealias ContainerTime = (time: CGFloat, container: SVGPathContainer)

public class SVGPathManager {
    
    fileprivate var containerTimes: [ContainerTime] = []
    
    public init(configurationTimes: [ConfigurationTime]) throws {
        containerTimes = try configurationTimes.map {
            (timeframe: $0.time,
             container: try SVGPathContainer(svg: $0.configuration.path,
                                             smooth: $0.configuration.timesSmooth,
                                             drawableFrame: $0.configuration.drawableFrame))
        }
    }
    
    public func toPath(proportion: CGFloat? = nil) throws -> UIBezierPath {
        let currentTime = proportion ?? 1.0
        let currentPaths = containerTimes.filter { $0.time < currentTime }
        
        guard currentPaths.count > 0 else {
            return UIBezierPath()
        }
        
        let paths: [UIBezierPath] = try currentPaths.map { path in
            let time = calculateRelativeTime(currentTime: currentTime, startTime: path.time)
            return try path.container.toPath(proportion: time)
        }
        
        let totalPath = UIBezierPath()
        paths.forEach { totalPath.append($0) }
        
        return totalPath
    }
    
    private func calculateRelativeTime(currentTime: CGFloat, startTime: CGFloat) -> CGFloat {
        return max((currentTime - startTime) / (1.0 - startTime), 0)
    }
}
