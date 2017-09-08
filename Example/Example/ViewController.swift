//
//  ViewController.swift
//  Example
//
//  Created by Dark Dong on 2017/7/26.
//  Copyright © 2017年 Dark Dong. All rights reserved.
//

import UIKit
import Photos
import PhotoPicker

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showPicker(_ sender: Any) {
        print("showPicker")
//        let bundle = Bundle(identifier: "com.darkdong.PhotoPicker")
//        let picker = UIStoryboard(name: "PhotoPicker", bundle: bundle).instantiateInitialViewController() as! PhotoPickerNavigationController
        let config = PickerConfig()
        config.rootTitle = "Root Title"
        config.mediaType = .image
        config.numberOfAssetColumns = 3
//        config.nibForAssetCell = UINib(nibName: "CustomPhotoAssetCell", bundle: nil)
        let picker = PhotoPickerNavigationController.nc(config: config)
        picker.pickerDelegate = self
        present(picker, animated: true, completion: nil)
    }
}

class CustomPhotoAssetCell: PhotoAssetCell {
    @IBOutlet var assetImageView: UIImageView!
    @IBOutlet var selectedImageView: UIImageView!
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        selectedImageView.image = #imageLiteral(resourceName: "deselected")
        selectedImageView.highlightedImage = #imageLiteral(resourceName: "selected")
    }
    
    override open var photoAssetImageView: UIImageView! {
        return assetImageView
    }
    
    override open var photoSelectionImageView: UIImageView! {
        return selectedImageView
    }
}

extension ViewController: PhotoPickerDelegate {
    func picker(_ picker: PhotoPickerNavigationController, didSelectAssets assets: [PHAsset]) {
        //do what you want
        //...
        
        //dismiss picker
        picker.dismiss(animated: true, completion: nil)
    }
    
    func picker(_ picker: PhotoPickerNavigationController, shouldSelectAsset: PHAsset, selectedAssets: [PHAsset]) -> Bool {
        //limit number of selections
        if selectedAssets.count >= 5 {
            return false
        }
        return true
    }
}
