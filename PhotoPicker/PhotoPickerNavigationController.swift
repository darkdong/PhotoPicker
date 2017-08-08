//
//  PhotoPickerController.swift
//  PhotoPicker
//
//  Created by Dark Dong on 2017/6/26.
//  Copyright © 2017年 Dark Dong. All rights reserved.
//

import Photos

@objc public protocol PhotoPickerDelegate {
    func picker(_ picker: PhotoPickerNavigationController, didSelectAssets assets: [PHAsset])
    @objc optional func pickerDidCancel(_ picker: PhotoPickerNavigationController)
    @objc optional func picker(_ picker: PhotoPickerNavigationController, shouldSelectAsset: PHAsset, selectedAssets: [PHAsset]) -> Bool
}

public struct PickerConfig {
    // media type
    public var mediaType: PHAssetMediaType?
    
    // text
    public var rootTitle = "照片"
    public var doneTitle = "完成"
    public var cancelTitle = "取消"
    public var previewTitle = "预览"
    
    // image
    public var placeholderImage: UIImage? {
        return UIImage(named: "placeholder")
    }
    
    // layout
    public var numberOfAssetColumns = 4
    public var interAssetSpacing: CGFloat = 2
}

public class PhotoPickerNavigationController: UINavigationController {
    public static let storyboardName = "PhotoPicker"
    public static let storyboardGroupsControllerID = "Groups"
    public static let storyboardAssetsControllerID = "Assets"
    public static let storyboardBrowserControllerID = "Browser"

    public static var bundle: Bundle? = {
        return Bundle(identifier: "com.darkdong.PhotoPicker")
    }()

    public static var nc: PhotoPickerNavigationController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
        let picker = storyboard.instantiateInitialViewController() as! PhotoPickerNavigationController
        picker.viewControllers[0].title = picker.config.rootTitle
        let assetsVC = storyboard.instantiateViewController(withIdentifier: storyboardAssetsControllerID)
        picker.pushViewController(assetsVC, animated: false)
        return picker
    }
    
    public var config = PickerConfig() {
        didSet {
            viewControllers[0].title = config.rootTitle
        }
    }
    weak public var pickerDelegate: PhotoPickerDelegate?
    
    deinit {
        print(type(of: self), "deinit")
    }
}


