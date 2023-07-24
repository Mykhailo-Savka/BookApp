//
//  UITableView+Cell.swift
//  BookApp
//
//  Created by Savka Mykhailo on 23.07.2023.
//

import UIKit

extension UITableView {
    func dequeueCell<T: UITableViewCell>(_ type: T.Type, indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(
            withIdentifier: type.identifier,
            for: indexPath) as! T
    }

    func registerCell<T: UITableViewCell>( _ type: T.Type) {
        self.register(type.nib, forCellReuseIdentifier: type.identifier)
    }

    func registerHeader<T: UITableViewHeaderFooterView>(_ type: T.Type) {
        self.register(
            type.nib,
            forHeaderFooterViewReuseIdentifier: type.identifier)
    }

    func dequeueHeader<T: UITableViewHeaderFooterView>(_ type: T.Type) -> T {
        return self.dequeueReusableHeaderFooterView(
            withIdentifier: type.identifier) as! T
    }
}
