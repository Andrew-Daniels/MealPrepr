//
//  ConnectionErrorView.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 2/2/19.
//  Copyright © 2019 Andrew Daniels. All rights reserved.
//

import Foundation
import UIKit

class ConnectionErrorView {
    
    private var connectionStatusView: UIView!
    private var connectionStatusLabel: UILabel!
    private var connectionViewStatus: ConnectionViewStatus = .NotConstrained
    private var connectionStatus: Reachability.Connection!
    private var parent: UIViewController!
    private var delegate: ConnectionErrorViewDelegate?
    private var bottomViewConstant: CGFloat!
    private var connectedToInternet: Bool!
    
    init(parent: UIViewController, bottomViewConstant: CGFloat = 0) {
        self.parent = parent
        self.delegate = parent as? ConnectionErrorViewDelegate
        self.bottomViewConstant = bottomViewConstant
        
        let view = UIView()
        view.backgroundColor = .white
        let label = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "No connection"
        label.font = UIFont(name: "Helvetica", size: 11)
        view.addSubview(label)
        
        self.connectionStatusView = view
        self.connectionStatusLabel = label
    }
    
    enum ConnectionViewStatus: Int {
        case Constrained
        case NotConstrained
        case ConstrainedVisible
    }
    
    public func hasConnectionViews() -> Bool {
        return connectionStatusView != nil && connectionStatusLabel != nil
    }
    
    public func addConnectionViews(view: UIView, label: UILabel) {
        connectionStatusView = view
        connectionStatusLabel = label
    }
    
    public func setConnectionStatus(status: Reachability.Connection, containedInTabController: Bool = false) {
        
        switch status {
            
        case .none:
            connectedToInternet = false
            changeConnectionStatus(containedInTabController: containedInTabController)
        case .wifi:
            connectedToInternet = true
            changeConnectionStatus(containedInTabController: containedInTabController)
        case .cellular:
            connectedToInternet = true
            changeConnectionStatus(containedInTabController: containedInTabController)
        }
        
        connectionStatus = status
    }
    
    private func changeConnectionStatus(containedInTabController: Bool) {
        
        DispatchQueue.main.async {
            if self.hasConnectionViews() && !self.connectedToInternet {
                switch self.connectionViewStatus {
                case .Constrained:
                    self.connectionViewStatus = .ConstrainedVisible
                    if !containedInTabController {
                        self.setConnectionViewsVisible(visible: true)
                    }
                    break
                case .NotConstrained:
                    self.setConnectionViewConstraints()
                    self.connectionViewStatus = .Constrained
                    if !containedInTabController {
                        self.setConnectionViewsVisible(visible: true)
                    }
                    self.delegate?.handleErrorViewVisibility(visible: true)
                    break
                case .ConstrainedVisible:
                    self.connectionViewStatus = .ConstrainedVisible
                    break
                }
            } else if self.hasConnectionViews() && self.connectedToInternet {
                self.setConnectionViewsVisible(visible: false)
                if self.connectionViewStatus == .ConstrainedVisible {
                    self.connectionViewStatus = .Constrained
                }
                self.delegate?.handleErrorViewVisibility(visible: false)
            }
        }
        
    }
    
    private func setConnectionViewConstraints() {
        
        parent.view.addSubview(connectionStatusView)
        
        let top = NSLayoutConstraint(item: connectionStatusLabel, attribute: .top, relatedBy: .equal, toItem: connectionStatusView, attribute: .top, multiplier: 1, constant: 5)
        let x = NSLayoutConstraint(item: connectionStatusLabel, attribute: .centerX, relatedBy: .equal, toItem: connectionStatusView, attribute: .centerX, multiplier: 1, constant: 0)
        
        parent.view.addConstraints([top, x])
        
        let bottom = NSLayoutConstraint(item: connectionStatusView, attribute: .bottom, relatedBy: .equal, toItem: parent.view, attribute: .bottom, multiplier: 1, constant: bottomViewConstant)
        let leading = NSLayoutConstraint(item: connectionStatusView, attribute: .leading, relatedBy: .equal, toItem: parent.view, attribute: .leading, multiplier: 1, constant: 0)
        let trailing = NSLayoutConstraint(item: connectionStatusView, attribute: .trailing, relatedBy: .equal, toItem: parent.view, attribute: .trailing, multiplier: 1, constant: 0)
        let height = NSLayoutConstraint(item: connectionStatusView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)
        
        parent.view.addConstraints([bottom, leading, trailing, leading, height])
        
    }
    
    private func setConnectionViewsVisible(visible: Bool) {
        connectionStatusLabel.isHidden = !visible
        connectionStatusView.isHidden = !visible
        
        delegate?.handleErrorViewVisibility(visible: visible)
    }
}
