//
//  SVGResizer.swift
//  RambafreshSVG
//
//  Created by m.rakhmanov on 25.12.16.
//  Copyright © 2016 m.rakhmanov. All rights reserved.
//

import Foundation
import UIKit

class SVGResizer {
    
    func resize(_ nodes: [SVGNode], to newFrame: CGRect) -> [SVGNode] {
        let normalized = normalize(nodes)
        let size = calculateSize(for: normalized)
        let scale = calcualteScale(first: newFrame.size, second: size)
        let rescaled = rescale(normalized, scale: scale)
        let moved = move(to: newFrame.origin, nodes: rescaled)
        
        return moved
    }
    
    private func normalize(_ nodes: [SVGNode]) -> [SVGNode] {
        var minX = CGFloat.greatestFiniteMagnitude
        var minY = minX
        
        for node in nodes {
            for point in node.points {
                minX = min(point.x, minX)
                minY = min(point.y, minY)
            }
        }
        
        return nodes.map { node in
            return SVGNode(instruction: node.instruction,
                           points: node.points.map { CGPoint(x: $0.x - minX, y: $0.y - minY) })
        }
    }
    
    private func rescale(_ nodes: [SVGNode], scale: CGFloat) -> [SVGNode] {
        return nodes.map { node in
            return SVGNode(instruction: node.instruction,
                           points: node.points.map { CGPoint(x: $0.x * scale, y: $0.y * scale) })
        }
    }
    
    private func calculateSize(for nodes: [SVGNode]) -> CGSize {
        var maxX: CGFloat = 0.0
        var maxY = maxX
        
        for node in nodes {
            for point in node.points {
                maxX = max(point.x, maxX)
                maxY = max(point.y, maxY)
            }
        }
        
        return CGSize(width: maxX, height: maxY)
    }
    
    private func calcualteScale(first: CGSize, second: CGSize) -> CGFloat {
        return min(first.width / second.width, first.height / second.height)
    }
    
    private func move(to point: CGPoint, nodes: [SVGNode]) -> [SVGNode] {
        return nodes.map { node in
            return SVGNode(instruction: node.instruction,
                           points: node.points.map { CGPoint(x: $0.x + point.x, y: $0.y + point.y) })
        }
    }
}
