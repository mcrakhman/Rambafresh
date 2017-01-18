//
//  UITableViewExtension.swift
//  RamblerYearlyEventApplication
//
//  Created by m.rakhmanov on 08.10.16.
//  Copyright © 2016 m.rakhmanov. All rights reserved.
//

import Foundation
import UIKit

extension UIScrollView {
    
    struct AssociatedKeys {
        static var pullToRefreshViewKey = "pullToRefreshViewKey"
    }
    
    var pullToRefreshView: RambafreshView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.pullToRefreshViewKey) as? RambafreshView
        }
        
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self,
                                         &AssociatedKeys.pullToRefreshViewKey,
                                         newValue,
                                         .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    open var showsPullToRefresh: Bool {
        
        get {
            if let view = pullToRefreshView {
                return !view.isHidden
            }
            return false
        }
        set {
            guard let pullToRefreshView = pullToRefreshView else {
                return
            }
            let constants = RambafreshViewConstants.KeyPaths.self
            
            if (!showsPullToRefresh && pullToRefreshView.isObserving) {
                self.removeObserver(pullToRefreshView, forKeyPath: constants.contentOffset)
                self.removeObserver(pullToRefreshView, forKeyPath: constants.frame)
                self.panGestureRecognizer.removeTarget(pullToRefreshView,
                                                       action: #selector(RambafreshView.gestureRecognizerUpdated(_:)))
                pullToRefreshView.isObserving = false
            } else if (showsPullToRefresh && !pullToRefreshView.isObserving) {
                self.addObserver(pullToRefreshView,
                                 forKeyPath: constants.contentOffset,
                                 options: NSKeyValueObservingOptions.new,
                                 context: nil)
                self.addObserver(pullToRefreshView,
                                 forKeyPath: constants.frame,
                                 options: NSKeyValueObservingOptions.new,
                                 context: nil)
                self.panGestureRecognizer.addTarget(pullToRefreshView,
                                                    action: #selector(RambafreshView.gestureRecognizerUpdated(_:)))
                pullToRefreshView.isObserving = true
            }
            pullToRefreshView.isHidden = !showsPullToRefresh
        }
    }
    
    open func stopAnimating() {
        if let animating = pullToRefreshView?.isAnimating, animating == true {
            pullToRefreshView?.stopAnimating()
        }
    }
	   
    open func addPullToRefresh(animatable: RambafreshAnimatableViewConforming, handler: @escaping ActionHandler) {
        guard pullToRefreshView == nil else {
            return
        }
        
        let rambafreshViewSizeHeight = animatable.getView.frame.size.height + RambafreshViewConstants.Layout.heightIncrease
        
        let pullToRefreshFrame = CGRect(x: 0,
                                        y: -rambafreshViewSizeHeight,
                                        width: bounds.width,
                                        height: rambafreshViewSizeHeight)
        
        let configuration = RambafreshViewConfiguration(frame: pullToRefreshFrame,
                                                        animatable: animatable,
                                                        scrollView: self,
                                                        animationEndDistanceOffset: 30.0,
                                                        animationStartDistance: 60.0,
                                                        handler: handler)
        
        let newPullToRefreshView = RambafreshView(frame: pullToRefreshFrame,
                                                  configuration: configuration)
        addSubview(newPullToRefreshView)
        sendSubview(toBack: newPullToRefreshView)
        
        pullToRefreshView = newPullToRefreshView
        
        showsPullToRefresh = true
    }
}
