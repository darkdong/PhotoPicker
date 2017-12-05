//
//  PhotoBrowserController.swift
//  PhotoPicker
//
//  Created by Dark Dong on 2017/6/26.
//  Copyright © 2017年 Dark Dong. All rights reserved.
//

import Photos

open class PhotoBrowserController: UIViewController {
    @IBOutlet var bottomLeftButtonItem: UIBarButtonItem!
    @IBOutlet var doneButtonItem: UIBarButtonItem!
    @IBOutlet var collectionView: UICollectionView!

    var assets: [PHAsset] = []
    
    deinit {
        print(type(of: self), #function)
    }

//    open override var prefersStatusBarHidden: Bool {
//        return true
//    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        print(type(of: self), #function)

        title = pickerConfig?.previewTitle
        doneButtonItem.title = pickerConfig?.doneTitle

        let layout = collectionView.collectionViewLayout as!  UICollectionViewFlowLayout
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.toolbar.isTranslucent = true
        
//        navigationController?.isNavigationBarHidden = true
//        navigationController?.isToolbarHidden = true
    }
    
    open override func viewDidLayoutSubviews() {
        let itemSize = collectionView.frame.size
        let layout = collectionView.collectionViewLayout as!  UICollectionViewFlowLayout
        layout.itemSize = itemSize
    }
    
    //MARK: - action

    @IBAction func done(_ sender: UIBarButtonItem) {
        if let picker = picker, let _ = picker.pickerDelegate?.picker(picker, didSelectAssets: assets) {
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}

extension PhotoBrowserController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets.count
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let asset = assets[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoBrowserCell", for: indexPath) as! PhotoBrowserCell
        let layout = collectionView.collectionViewLayout as!  UICollectionViewFlowLayout
        let scale = UIScreen.main.scale
        let assetPixelSize = CGSize(width: layout.itemSize.width * scale, height: layout.itemSize.height * scale)
        cell.reuse(with: asset, assetPixelSize: assetPixelSize)
        return cell
    }
}

open class PhotoBrowserCell: UICollectionViewCell {
    @IBOutlet var assetImageView: UIImageView!
    
    public func reuse(with asset: PHAsset, assetPixelSize: CGSize) {
//        print(type(of: self), "reuse", assetImageView.frame.size)
        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true
        PHImageManager.default().requestImage(for: asset, targetSize: assetPixelSize, contentMode: .aspectFit, options: options) { [weak self] (image, info) in
            self?.assetImageView.image = image
        }
    }
}
