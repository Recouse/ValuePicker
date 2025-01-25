//
//  ValuePickerItemPreferenceKey.swift
//  ValuePicker
//
//  Created by Firdavs Khaydarov on 23/06/2024.
//

import SwiftUI

struct ValuePickerItemPreferenceKey<ID>: PreferenceKey where ID: Hashable & Sendable {
    struct Item {
        let id: ID
        let anchor: Anchor<CGRect>
    }
    
    typealias Value = [Item]
    
    static var defaultValue: [Item] {
        get { [] }
    }
    
    static func reduce(
        value: inout [Item],
        nextValue: () -> [Item]
    ) {
        let merged = value + nextValue()
        value = merged.uniqued(by: \.id)
    }
}

public struct ValuePickerItemPreferenceModifier<ID>: ViewModifier where ID: Hashable & Sendable {
    public let id: ID
    
    public init(id: ID) {
        self.id = id
    }
    
    public func body(content: Content) -> some View {
        content.anchorPreference(
            key: ValuePickerItemPreferenceKey<ID>.self,
            value: .bounds
        ) {
            [ValuePickerItemPreferenceKey.Item(id: id, anchor: $0)]
        }
    }
}

extension Array {
    func uniqued<T>(by keyPath: KeyPath<Element, T>) -> [Element] where T: Hashable {
        var seen = Set<T>()
        return filter { seen.insert($0[keyPath: keyPath]).inserted }
    }
}
