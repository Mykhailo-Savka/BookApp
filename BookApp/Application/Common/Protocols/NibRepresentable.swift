//
//  NibRepresentable.swift
//  BookApp
//
//  Created by Savka Mykhailo on 21.07.2023.
//

import UIKit

protocol NibRepresentable {
    static var nib: UINib { get }
    static var identifier: String { get }
}
