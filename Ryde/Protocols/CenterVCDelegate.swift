//
//  CenterVCDelegate.swift
//  Ryde
//
//  Created by Sean Sutton on 1/5/18.
//  Copyright © 2018 Au Development. All rights reserved.
//

import UIKit

protocol CenterVCDelegate {
    func toggleLeftPanel()
    func addLeftPanelViewController()
    func animateLeftPanel(shouldExpand: Bool)
}
