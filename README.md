# PhotoPicker
A photo picker that select photos from system albums 

## Requirements
iOS 8.0, Swift 3.1 

## Installation

### Carthage

1. Add `github "darkdong/PhotoPicker"` to your Cartfile
2. Run `carthage update --platform ios`
3. Add the framework to your project manually.
4. `import PhotoPicker` in Swift file

### Manual
Download and add sources to your project

## Usage

### Basic Usage

```
let picker = PhotoPickerNavigationController.nc
present(picker, animated: true, completion: nil)
```

### Config Picker

```
let picker = PhotoPickerNavigationController.nc
picker.config.rootTitle = "Root Title"
picker.config.mediaType = .image
present(picker, animated: true, completion: nil)
```

## License

PhotoPicker is released under the MIT license. [See LICENSE](https://github.com/darkdong/PhotoPicker/blob/master/LICENSE) for details.