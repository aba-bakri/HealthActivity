# DTRuler

[![Swift](https://img.shields.io/badge/Swift-4.0-ff3f26.svg?style=flat)](https://swift.org/)
[![Platform](https://img.shields.io/cocoapods/p/DTRuler.svg?style=flat)](http://cocoadocs.org/docsets/DTRuler)
[![CocoaPods](http://img.shields.io/cocoapods/v/DTRuler.svg)](https://cocoapods.org/pods/DTRuler)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

## Introduction

Simple ruler input control.

![Demo](Demo.gif)

## Installation

### Requirement

iOS 8.4+

### [CocoaPods](http://cocoapods.org)

To install DTRuler add a dependency to your Podfile:

```
pod "DTRuler"
```

### [Carthage](https://github.com/Carthage/Carthage)

To install DTRuler add a dependency to your Cartfile:

```
github "danjiang/DTRuler"
```

```
carthage update --platform ios
```

## Usage

### Import

```swift
import DTRuler
```

### Use

```swift
// Float with step as 0.1
let scale = 78.9
let ruler = DTRuler(scale: .float(scale), minScale: .float(9), maxScale: .float(999), width: view.bounds.width - 50)

// or Integer with step as 1
let scale = 59
let ruler = DTRuler(scale: .integer(scale), minScale: .integer(10), maxScale: .integer(100), width: view.bounds.width - 50)

ruler.delegate = self

extension ViewController: DTRulerDelegate {
  
  func didChange(on ruler: DTRuler, withScale scale: DTRuler.Scale) {
    switch scale {
    case .float(let f):
      print(f)
    case .integer(let i):
      print(i)
  }

}
```

### Customize

```swift
struct Colorful: DTRulerTheme {
  
  var backgroundColor: UIColor {
    return UIColor.lightGray
  }
  
  var pointerColor: UIColor {
      return UIColor.gray
  }
  
  var majorScaleColor: UIColor {
    return UIColor.darkGray
  }
  
  var minorScaleColor: UIColor {
    return UIColor.darkGray
  }
  
  var labelColor: UIColor {
    return UIColor.darkGray
  }
  
}

DTRuler.theme = Colorful()
```

