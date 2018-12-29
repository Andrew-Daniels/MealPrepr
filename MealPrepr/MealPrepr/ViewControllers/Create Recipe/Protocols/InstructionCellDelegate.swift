//
//  InstructionCellDelegate.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 12/29/18.
//  Copyright © 2018 Andrew Daniels. All rights reserved.
//

import Foundation
import UIKit

protocol InstructionCellDelegate {
    func instructionCellCollectionViewContentSizeSet(for cell: InstructionCell, toSize: CGSize)
}
