//
//  ViewController.swift
//  Example
//
//  Created by Dark Dong on 2017/7/26.
//  Copyright © 2017年 Dark Dong. All rights reserved.
//

import UIKit
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
        
//        let picker = PhotoPickerNavigationController()
        
        let picker = PhotoPickerNavigationController.nc
        present(picker, animated: true, completion: nil)
    }
}

