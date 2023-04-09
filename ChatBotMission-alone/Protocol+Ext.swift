//
//  Protocol+Ext.swift
//  ChatBotMission-alone
//
//  Created by 김라영 on 2023/02/02.
//

import Foundation
import UIKit

protocol Nibbed {
    static var uiNib: UINib { get }
}

extension Nibbed {
    static var uiNib: UINib {
        return UINib(nibName: String(describing: Self.self), bundle: nil)
    }
}
extension UITableViewCell : Nibbed {}

protocol ReuseIdentifier {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifier {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

extension UITableViewCell: ReuseIdentifier {}
