//
//  PhotoPickerController.swift
//  PhotoPicker
//
//  Created by Dark Dong on 2017/6/26.
//  Copyright © 2017年 Dark Dong. All rights reserved.
//

import Photos

public let photoPickerBundle = Bundle(identifier: "com.darkdong.PhotoPicker")!

@objc public protocol PhotoPickerDelegate {
    func picker(_ picker: PhotoPickerNavigationController, didSelectAssets assets: [PHAsset])
    @objc optional func pickerDidCancel(_ picker: PhotoPickerNavigationController)
    @objc optional func picker(_ picker: PhotoPickerNavigationController, shouldSelectAsset: PHAsset, selectedAssets: [PHAsset]) -> Bool
    @objc optional func pickerDidLoad(_ picker: PhotoPickerNavigationController)
    @objc optional func pickerDidUnload(_ picker: PhotoPickerNavigationController)
}

public class PickerConfig: NSObject {
    // media type
    public var mediaType: PHAssetMediaType?
    
    // text
    public var rootTitle = "照片"
    public var doneTitle = "完成"
    public var cancelTitle = "取消"
    public var previewTitle = "预览"
    
    // image
//    public var albumCoverImage: UIImage? {
//        return UIImage(named: "album_cover", in: PhotoPickerNavigationController.bundle, compatibleWith: nil)
//    }
    
    // layout
    public var numberOfAssetColumns = 4
    public var interAssetSpacing: CGFloat = 2
    
    //custom UI
    public var nibForAssetCell: UINib?
}

public class PhotoPickerNavigationController: UINavigationController {
    public static let storyboardName = "PhotoPicker"
    public static let storyboardGroupsControllerID = "Groups"
    public static let storyboardAssetsControllerID = "Assets"
    public static let storyboardBrowserControllerID = "Browser"

    public static func nc(config: PickerConfig) -> PhotoPickerNavigationController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: photoPickerBundle)
        let picker = storyboard.instantiateInitialViewController() as! PhotoPickerNavigationController
        picker.config = config
        picker.viewControllers[0].title = config.rootTitle
        let assetsVC = storyboard.instantiateViewController(withIdentifier: storyboardAssetsControllerID)
        picker.pushViewController(assetsVC, animated: false)
        return picker
    }
    
    var config: PickerConfig!
    weak public var pickerDelegate: PhotoPickerDelegate?
    
    public override func viewDidLoad() {
        pickerDelegate?.pickerDidLoad?(self)
    }
    
    deinit {
        pickerDelegate?.pickerDidUnload?(self)
    }
}


