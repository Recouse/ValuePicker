//
//  View+ValuePicker.swift
//  ValuePicker
//
//  Created by Firdavs Khaydarov on 11/04/2025.
//

import SwiftUI

public extension View {
    func valuePickerShape<S>(_ shape: S) -> some View where S: Shape {
        environment(\.valuePickerShape, AnyShape(shape))
    }

    func valuePickerItemShape<S>(_ shape: S) -> some View where S: Shape {
        environment(\.valuePickerItemShape, AnyShape(shape))
    }

    func valuePickerContainerPadding(_ padding: EdgeInsets? = nil) -> some View {
        environment(\.valuePickerContainerPadding, padding ?? ValuePickerConstants.containerPadding)
    }

    func valuePickerItemPadding(_ padding: EdgeInsets? = nil) -> some View {
        environment(\.valuePickerItemPadding, padding ?? ValuePickerConstants.itemPadding)
    }
}
