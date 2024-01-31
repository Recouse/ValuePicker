//
//  ValuePicker.swift
//  ValuePicker
//
//  Created by Firdavs Khaydarov on 31/01/2024.
//

import SwiftUI

struct ValuePicker<SelectionValue, Content>: View where SelectionValue: Hashable, Content: View {
    @Binding var selection: SelectionValue
    @ViewBuilder var content: () -> Content
    
    @Namespace private var selectionAnimation
    private let childBackground = "childBackground"
    
    init(selection: Binding<SelectionValue>, @ViewBuilder content: @escaping () -> Content) {
        self._selection = selection
        self.content = content
    }
    
    var body: some View {
        HStack(spacing: 0) {
            content().variadic { children in
                ForEach(children) { child in
                    let id = child.id(as: SelectionValue.self)
                    let selected = id == selection
                    child
                        .foregroundColor(selected ? .black : .black.opacity(0.3))
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(
                            Group {
                                if selected {
                                    Capsule()
                                        .fill(Color.white)
                                        .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
                                        .matchedGeometryEffect(id: childBackground, in: selectionAnimation)
                                }
                            }
                        )
                        .animation(.default, value: selection)
                        .onTapGesture {
                            if let id {
                                selection = id
                            }
                        }
                }
            }
        }
        .padding(6)
        .background(
            Capsule()
                .fill(Color.gray.opacity(0.3))
        )
    }
}

#Preview {
    struct TestView: View {
        @State var selection: String = "apple"
        var body: some View {
            ValuePicker(selection: $selection) {
                ForEach(["apple", "banana", "orange", "kiwi", "pear"], id: \.self) { fruit in
                    Text(fruit)
                }
            }
        }
    }
    
    return TestView()
}

fileprivate struct MultiViewRoot<Result: View>: _VariadicView_MultiViewRoot {
    var _body: (_VariadicView.Children) -> Result

    func body(children: _VariadicView.Children) -> some View {
        _body(children)
    }
}

fileprivate extension View {
    func variadic<R: View>(@ViewBuilder process: @escaping (_VariadicView.Children) -> R) -> some View {
        _VariadicView.Tree(MultiViewRoot(_body: process), content: { self })
    }
}
