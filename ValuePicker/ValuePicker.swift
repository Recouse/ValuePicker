//
//  ValuePicker.swift
//  ValuePicker
//
//  Created by Firdavs Khaydarov on 31/01/2024.
//

import SwiftUI

@MainActor
struct ValuePicker<SelectionValue, Content, Label>: View where SelectionValue: Hashable & Sendable, Content: View, Label: View {
    @Binding var selection: SelectionValue
    let animation: Animation
    let label: Label
    let content: Content
    
    @Namespace private var selectionAnimation
    
    private static var defaultAnimation: Animation {
        get { Animation.spring(duration: 0.3, bounce: 0.15) }
    }
    
    init(
        selection: Binding<SelectionValue>,
        animation: Animation = ValuePicker.defaultAnimation,
        @ViewBuilder label: @escaping () -> Label,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._selection = selection
        self.animation = animation
        self.label = label()
        self.content = content()
    }
    
    var body: some View {
        LabeledContent {
            HStack(spacing: 0) {
                _VariadicView.Tree(
                    ValuePickerLayout(
                        selection: $selection,
                        animation: animation,
                        selectionAnimationNamespace: selectionAnimation
                    )
                ) {
                    content
                }
            }
            .padding(6)
            .background(
                Capsule()
                    .fill(Color.gray.opacity(0.3))
            )
        } label: {
            label
        }
    }
}

extension ValuePicker where Label == Text {
    init(
        _ label: LocalizedStringKey,
        selection: Binding<SelectionValue>,
        animation: Animation = ValuePicker.defaultAnimation,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._selection = selection
        self.animation = animation
        self.label = Text(label)
        self.content = content()
    }
}

struct ValuePickerLayout<SelectionValue>: _VariadicView_MultiViewRoot where SelectionValue: Hashable & Sendable {
    @Binding var selection: SelectionValue
    let animation: Animation
    let selectionAnimationNamespace: Namespace.ID
    
    private let childBackground = "childBackground"
    
    func body(children: _VariadicView.Children) -> some View {
        ForEach(children) { child in
            let trait = child[ValuePickerTagValueTraitKey<SelectionValue>.self]
            let selected = switch trait {
            case let .tagged(tag): tag == selection
            case .untagged: false
            }
            child
                .foregroundColor(selected ? .black : .black.opacity(0.3))
                .lineLimit(1)
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background {
                    if selected {
                        Capsule()
                            .fill(Color.white)
                            .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
                            .matchedGeometryEffect(id: childBackground, in: selectionAnimationNamespace)
                    }
                }
                .animation(animation, value: selection)
                .onTapGesture {
                    if case let .tagged(tag) = trait {
                        withAnimation(animation) {
                            selection = tag
                        }
                    }
                }
        }
    }
}

#if DEBUG
#Preview {
    struct TestView: View {
        @State var selection: String = "apple"
        @State var moodSelection: String = "🤗"
        
        var body: some View {
            VStack {
                Text("Fruits")
                    .font(.headline)
                
                ValuePicker("Fruits", selection: $selection) {
                    ForEach(["apple", "banana", "orange", "kiwi", "pear"], id: \.self) { fruit in
                        Text(fruit)
                            .valuePickerTag(fruit)
                    }
                }
                .labelsHidden()
            }
            .padding()
            
            VStack {
                ValuePicker("Mood", selection: $moodSelection) {
                    ForEach(["🤗", "🥲", "🤖", "😵‍💫", "😃"], id: \.self) { mood in
                        Text(mood)
                            .valuePickerTag(mood)
                    }
                }
            }
            .padding()
        }
    }
    
    return TestView()
}
#endif
