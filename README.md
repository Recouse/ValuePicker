# ValuePicker

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FRecouse%2FValuePicker%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/Recouse/ValuePicker)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FRecouse%2FValuePicker%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/Recouse/ValuePicker)

Customizable (soon) value picker for SwiftUI.

<img width="300" src="https://github.com/user-attachments/assets/91525082-f9c1-4539-9382-47a044b8a819" alt="ValuePicker" />

> [!Note]
> Please note that this is a work in progress. Planned features include, but are not limited to:
> - [ ] Haptic feedback
> - [ ] Custom styles
> - [ ] More platforms (macOS, tvOS, watchOS, visionOS)

## Installation

#### [Xcode Package Dependency](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app)

From Xcode menu: `File` > `Swift Packages` > `Add Package Dependency`

```text
https://github.com/Recouse/ValuePicker
```

#### [Swift Package Manager](https://www.swift.org/documentation/package-manager/)

In your `Package.swift` file, first add the following to the package `dependencies`:

```swift
.package(url: "https://github.com/Recouse/ValuePicker.git"),
```

And then, include "ValuePicker" as a dependency for your target:

```swift
.target(name: "<target>", dependencies: [
    .product(name: "ValuePicker", package: "ValuePicker"),
]),
```

## Usage

The API is designed to resemble SwiftUI's [Picker](https://developer.apple.com/documentation/swiftui/picker). Instead of using `tag()`, you should use `valuePickerTag()`, which also accepts any `Hashable` value.

```swift
import SwiftUI
import ValuePicker

struct ContentView: View {
    @State private var revenueSelection: String = "Weekly"

    var body: some View {
        VStack(alignment: .leading) {
            Text("Revenue")
                .font(.title)

            ValuePicker(selection: $revenueSelection) {
                ForEach(["Weekly", "Monthly", "Quarterly", "Yearly"], id: \.self) { option in
                    Text(option)
                        .valuePickerTag(option)
                }
            }
        }
        .padding()
    }
}
```

## Compatibility
* iOS 15.0+
* macOS 12.0+
* visionOS 1.0+

## Dependencies
No dependencies.

## Contributing
Contributions to are always welcomed! If you'd like to contribute, please fork this repository and 
submit a pull request with your changes.

### License
ValuePicker is released under the MIT License. See [LICENSE](LICENSE) for more information.
