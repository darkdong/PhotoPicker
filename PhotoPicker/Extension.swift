//
//  Extension.swift
//  PhotoPicker
//
//  Created by Dark Dong on 2017/6/6.
//  Copyright © 2017年 Dark Dong. All rights reserved.
//

import UIKit

extension UIViewController {
    var picker: PhotoPickerNavigationController? {
        if let picker = navigationController as? PhotoPickerNavigationController {
            return picker
        } else {
            return nil
        }
    }
    
    var pickerConfig: PickerConfig? {
        return picker?.config
    }
}

extension UIScrollView {
    func scrollToEnd(animated: Bool, scrollDirection: UICollectionViewScrollDirection = .vertical) {
        switch scrollDirection {
        case .vertical:
            let diff = contentSize.height + contentInset.bottom - frame.height
            if (diff > 0) {
                setContentOffset(CGPoint(x: contentOffset.x, y: diff), animated: animated)
            }
        case .horizontal:
            let diff = contentSize.width + contentInset.right - frame.width
            if (diff > 0) {
                setContentOffset(CGPoint(x: diff, y: contentOffset.y), animated: animated)
            }
        }
    }
}

