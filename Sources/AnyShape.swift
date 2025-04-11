//
//  AnyShape.swift
//  ValuePicker
//
//  Created by Firdavs Khaydarov on 11/04/2025.
//

import SwiftUI

// Internal backport of AnyShape

struct AnyShape: Shape, @unchecked Sendable {
    private let _path: (CGRect) -> Path

    init<S>(_ shape: S) where S : Shape {
        self._path = shape.path(in:)
    }

    func path(in rect: CGRect) -> Path {
        _path(rect)
    }
}
