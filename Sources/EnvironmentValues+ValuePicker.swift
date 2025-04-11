//
//  EnvironmentValues+ValuePicker.swift
//  ValuePicker
//
//  Created by Firdavs Khaydarov on 11/04/2025.
//

import SwiftUI

struct ValuePickerConstants {
    static let containerPadding = EdgeInsets(top: 6, leading: 6, bottom: 6, trailing: 6)
    static let itemPadding = EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
}

extension EnvironmentValues {
    @Entry var valuePickerShape: AnyShape = AnyShape(.capsule)
    
    @Entry var valuePickerItemShape: AnyShape = AnyShape(.capsule)

    @Entry var valuePickerContainerPadding: EdgeInsets = ValuePickerConstants.containerPadding

    @Entry var valuePickerItemPadding: EdgeInsets = ValuePickerConstants.itemPadding
}
