//
//  FormatterExtension.swift
//  CBN
//
//  Created by Aditya Nanda Purnama on 23/10/18.
//  Copyright © 2018 CBN. All rights reserved.
//

import UIKit
extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = "."
        formatter.numberStyle = .decimal
        return formatter
    }()
}

extension BinaryInteger {
    var formattedWithSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }
}
