//
//  PhotoBrowserController.swift
//  PhotoPicker
//
//  Created by Dark Dong on 2017/6/26.
//  Copyright © 2017年 Dark Dong. All rights reserved.
//

import Photos

open class PhotoBrowserController: UIViewController {
    static public var interPageSpacing: CGFloat = 20
    
    @IBOutlet var bottomLeftButtonItem: UIBarButtonItem!
    @IBOutlet var doneButtonItem: UIBarButtonItem!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var collectionToViewTrailingConstraint: NSLayoutConstraint!

    var assets: [PHAsset] = []
    
    deinit {
        print(type(of: self), #function)
    }

    open override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        print(type(of: self), #function)

        doneButtonItem.title = pickerConfig?.doneTitle

        let interPageSpacing = PhotoBrowserController.interPageSpacing
        let layout = collectionView.collectionViewLayout as!  UICollectionViewFlowLayout
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: view.frame.width + interPageSpacing, height: view.frame.height)

        collectionToViewTrailingConstraint.constant = interPageSpacing
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.toolbar.isTranslucent = true
        
//        navigationController?.isNavigationBarHidden = true
//        navigationController?.isToolbarHidden = true
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
        cell.reuse(with: asset, assetSize: layout.itemSize)
        return cell
    }
}

open class PhotoBrowserCell: UICollectionViewCell {
    @IBOutlet var assetImageView: UIImageView!
    @IBOutlet var assetToCellTrailingConstraint: NSLayoutConstraint!
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        assetToCellTrailingConstraint.constant = -PhotoBrowserController.interPageSpacing
    }
    
    public func reuse(with asset: PHAsset, assetSize: CGSize) {
//        print(type(of: self), "reuse", assetImageView.frame.size)

        let options = PHImageRequestOptions()
        options.isSynchronous = true
        PHImageManager.default().requestImage(for: asset, targetSize: assetSize, contentMode: .aspectFit, options: nil) { [weak self] (image, info) in
            self?.assetImageView.image = image
        }
    }
}
