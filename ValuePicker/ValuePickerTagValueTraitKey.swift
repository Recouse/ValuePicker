//
//  ValuePickerTagValueTraitKey.swift
//  ValuePicker
//
//  Created by Firdavs Khaydarov on 16/06/2024.
//

import SwiftUI

struct ValuePickerTagValueTraitKey<V>: _ViewTraitKey, Sendable where V: Hashable & Sendable {
    enum Value {
        case untagged
        case tagged(V)
    }
    
    static var defaultValue: ValuePickerTagValueTraitKey<V>.Value {
        get { .untagged }
    }
}

extension View {
    func valuePickerTag<V>(_ value: V) -> some View where V: Hashable & Sendable {
        _trait(ValuePickerTagValueTraitKey<V>.self, .tagged(value))
    }
}
