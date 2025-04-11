//
//  ValuePicker.swift
//  ValuePicker
//
//  Created by Firdavs Khaydarov on 31/01/2024.
//

import SwiftUI

struct ValuePickerConstants {
    static let containerEdgeInsets = EdgeInsets(top: 6, leading: 6, bottom: 6, trailing: 6)
    static let capsuleEdgeInsets = EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
}

extension Animation {
    static let valuePicker: Animation = .spring(duration: 0.3, bounce: 0.15, blendDuration: 0.21)
}

@MainActor
public struct ValuePicker<SelectionValue, Content>: View where SelectionValue: Hashable & Sendable, Content: View {
    @Binding public var selection: SelectionValue
    public let animation: Animation
    public let content: Content

    @State private var isPressing = false
    @State private var pressStartLocation: CGPoint = .zero
    @State private var pressFinalLocation: CGPoint = .zero
    @State private var isDragging = false
    @State private var dragTranslation: CGSize = .zero
    @State private var preselectedValue: SelectionValue?

    var pressGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                withAnimation(animation) {
                    isPressing = true
                    pressStartLocation = value.startLocation
                }
            }
            .onEnded { value in
                withAnimation(animation) {
                    isPressing = false
                    pressFinalLocation = value.location
                }
            }
    }
    
    var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                withAnimation(animation) {
                    isDragging = true
                    dragTranslation = value.translation
                }
            }
            .onEnded { value in
                withAnimation(animation) {
                    isDragging = false
                    dragTranslation = .zero

                    if let preselectedValue {
                        selection = preselectedValue
                    }
                }
            }
    }
    
    public init(
        selection: Binding<SelectionValue>,
        animation: Animation? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._selection = selection
        self.animation = animation ?? .valuePicker
        self.content = content()
    }
    
    public var body: some View {
        HStack(spacing: 0) {
            _VariadicView.Tree(
                ValuePickerLayout(
                    selection: selection,
                    preselectedValue: preselectedValue,
                    isDragging: isDragging,
                    isPressing: isPressing,
                    animation: animation
                )
            ) {
                content
            }
        }
        .padding(ValuePickerConstants.containerEdgeInsets)
        .backgroundPreferenceValue(
            ValuePickerItemPreferenceKey<SelectionValue>.self
        ) { values in
            GeometryReader { geometry in
                let frame = frameForSelection(in: values, geometry: geometry)
                let currentFrame = capsuleCurrentFrame(
                    base: frame,
                    dragTranslation: dragTranslation,
                    values: values,
                    geometry: geometry
                )
                let isPressingCapsule = isPressing && currentFrame.contains(pressStartLocation)
                Capsule()
                    .fill(.background)
                    .scaleEffect(isPressingCapsule || isDragging ? 0.95 : 1)
                    .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
                    .frame(width: currentFrame.width, height: currentFrame.height)
                    .offset(x: currentFrame.minX, y: currentFrame.minY)
                    .onChange(of: pressFinalLocation) { newValue in
                        if !isPressing, !frame.contains(newValue) {
                            selectValue(at: newValue, in: values, geometry: geometry)
                        }
                    }
            }
        }
        .background(.quaternary, in: .capsule)
        .gesture(pressGesture.simultaneously(with: dragGesture))
    }

    private func selectValue(
        at location: CGPoint,
        in values: [ValuePickerItemPreferenceKey<SelectionValue>.Item],
        geometry: GeometryProxy
    ) {
        for value in values {
            let frame = geometry[value.anchor]
            let adjustedLocation = CGPoint(x: location.x, y: geometry.frame(in: .local).midY)
            if frame.contains(adjustedLocation) {
                withAnimation(animation) {
                    selection = value.id
                }
                return
            }
        }
    }

    private func frameForSelection(
        in values: [ValuePickerItemPreferenceKey<SelectionValue>.Item],
        geometry: GeometryProxy
    ) -> CGRect {
        if let anchor = values.first(where: { $0.id == selection })?.anchor {
            return geometry[anchor]
        }
        return .zero
    }
    
    private func capsuleCurrentFrame(
        base: CGRect,
        dragTranslation: CGSize,
        values: [ValuePickerItemPreferenceKey<SelectionValue>.Item],
        geometry: GeometryProxy
    ) -> CGRect {
        let initialFrame = capsuleFrame(
            for: base,
            dragTranslation: dragTranslation,
            geometry: geometry
        )
        var currentFrame = initialFrame

        for value in values {
            let valueFrame = geometry[value.anchor]
            if currentFrame.intersectionPercentage(valueFrame) >= 25 {
                currentFrame = capsuleFrame(for: valueFrame, geometry: geometry)
                DispatchQueue.main.async {
                    preselectedValue = value.id
                }
            }
        }

        return currentFrame
    }

    private func capsuleFrame(
        for base: CGRect,
        dragTranslation: CGSize = .zero,
        geometry: GeometryProxy
    ) -> CGRect {
        let capsuleWidth = base.width + ValuePickerConstants.capsuleEdgeInsets.leading + ValuePickerConstants.capsuleEdgeInsets.trailing
        let capsuleHeight = base.height + ValuePickerConstants.capsuleEdgeInsets.top + ValuePickerConstants.capsuleEdgeInsets.bottom
        let x = max(
            ValuePickerConstants.containerEdgeInsets.leading,
            min(
                base.minX + dragTranslation.width - ValuePickerConstants.containerEdgeInsets.leading - ValuePickerConstants.containerEdgeInsets.trailing,
                geometry.frame(in: .local).maxX - capsuleWidth - ValuePickerConstants.containerEdgeInsets.trailing
            )
        )
        let y = base.minY - 8

        return CGRect(
            x: x,
            y: y,
            width: capsuleWidth,
            height: capsuleHeight
        )
    }
}

struct ValuePickerLayout<SelectionValue>: _VariadicView_MultiViewRoot where SelectionValue: Hashable & Sendable {
    let selection: SelectionValue
    let preselectedValue: SelectionValue?
    let isDragging: Bool
    let isPressing: Bool
    let animation: Animation
    
    func body(children: _VariadicView.Children) -> some View {
        ForEach(children) { child in
            let trait = child[ValuePickerTagValueTraitKey<SelectionValue>.self]
            let (selected, preselected) = switch trait {
            case let .tagged(tag): (tag == selection, tag == preselectedValue)
            case .untagged: (false, false)
            }
            let highlighted = if isDragging || isPressing {
                preselected
            } else {
                selected
            }
            child
                .foregroundStyle(highlighted ? .primary : .secondary)
                .lineLimit(1)
                .padding(ValuePickerConstants.capsuleEdgeInsets)
                .animation(animation, value: selection)
                .animation(animation, value: preselected)
                .allowsTightening(false)
        }
    }
}
