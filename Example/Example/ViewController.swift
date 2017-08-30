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
        
        let picker = PhotoPickerNavigationController.nc
        picker.config.rootTitle = "Root Title"
        picker.config.mediaType = .image
        picker.pickerDelegate = self
        present(picker, animated: true, completion: nil)
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
