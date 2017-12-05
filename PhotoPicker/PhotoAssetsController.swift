//
//  PhotoAssetsController.swift
//  PhotoPicker
//
//  Created by Dark Dong on 2017/6/24.
//  Copyright © 2017年 Dark Dong. All rights reserved.
//

import Photos

private let cellReuseIdentifier = "PhotoAssetCell"

open class PhotoAssetsController: UICollectionViewController {
    @IBOutlet var cancelButtonItem: UIBarButtonItem!
    @IBOutlet var previewButtonItem: UIBarButtonItem!
    @IBOutlet var doneButtonItem: UIBarButtonItem!

    public var assets: [PHAsset] = []
    public var shouldLoadData = true

    var selectedAssets: [PHAsset] = [] {
        didSet {
            let buttonEnabled = !selectedAssets.isEmpty
            previewButtonItem.isEnabled = buttonEnabled
            doneButtonItem.isEnabled = buttonEnabled
        }
    }
    
    deinit {
        print(type(of: self), #function)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        print(type(of: self), #function)
        
        cancelButtonItem.title = pickerConfig?.cancelTitle
        previewButtonItem.title = pickerConfig?.previewTitle
        doneButtonItem.title = pickerConfig?.doneTitle
        
        let layout = collectionView!.collectionViewLayout as!  UICollectionViewFlowLayout
        let spacing = pickerConfig!.interAssetSpacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        let colmuns = pickerConfig!.numberOfAssetColumns
        let itemLength = (view.frame.width - (CGFloat(colmuns)+1) * spacing) / CGFloat(colmuns)
        layout.itemSize = CGSize(width: itemLength, height: itemLength)

        collectionView?.allowsMultipleSelection = true
        
        let nibForCell = pickerConfig?.nibForAssetCell ?? UINib(nibName: "PhotoAssetCell", bundle: photoPickerBundle)
        collectionView?.register(nibForCell, forCellWithReuseIdentifier: cellReuseIdentifier)
        
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized: //3
                if self.shouldLoadData {
                    self.loadData()
                }
            default:
                break
            }
        }
        
        selectedAssets = []
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.toolbar.isTranslucent = false
        navigationController?.isToolbarHidden = false
    }
    
    open override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! PhotoBrowserController
        vc.assets = selectedAssets
    }
    
    //called on non-main queue
    func loadData() {
        let result = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
        if let cameraRoll = result.firstObject {
            DispatchQueue.main.async { [weak self] in
                self?.title = cameraRoll.localizedTitle
            }
            let result = PHAsset.fetchAssets(in: cameraRoll, options: nil)
            let mediaType = pickerConfig!.mediaType
            result.enumerateObjects({ (asset, index, stop) in
                if mediaType == nil || asset.mediaType == mediaType {
                    self.assets.append(asset)
                }
            })
        }
        
        if !self.assets.isEmpty {
            DispatchQueue.main.sync { [weak self] in
                // because reloadData is async, we can't call scrollToEnd immediateley
                // execution order is: begin, reloadData, dataSourceMethods, performBatchUpdates, end, performBatchUpdatesCompletion
                // thus we can call scrollToEnd in performBatchUpdates
                self?.collectionView?.reloadData()
                self?.collectionView?.performBatchUpdates({
                    self?.collectionView?.scrollToEnd(animated: false)
                }, completion: { _ in
                })
            }
        }
    }
    
    //MARK: - action

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        if let picker = picker, let _ = picker.pickerDelegate?.pickerDidCancel?(picker) {
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        if let picker = picker, let _ = picker.pickerDelegate?.picker(picker, didSelectAssets: selectedAssets) {
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}

extension PhotoAssetsController {
    open override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets.count
    }
    
    open override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let asset = assets[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! PhotoAssetCell
        let layout = collectionView.collectionViewLayout as!  UICollectionViewFlowLayout
        let scale = UIScreen.main.scale
        let assetPixelSize = CGSize(width: layout.itemSize.width * scale, height: layout.itemSize.height * scale)
        cell.reuse(with: asset, assetPixelSize: assetPixelSize)
        return cell
    }
    
    open override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let asset = assets[indexPath.row]
        if let picker = picker, let shouldSelectItem = picker.pickerDelegate?.picker?(picker, shouldSelectAsset: asset, selectedAssets: selectedAssets) {
            return shouldSelectItem
        } else {
            return true
        }
    }
    
    open override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let asset = assets[indexPath.row]
        selectedAssets.append(asset)
    }
    
    open override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let asset = assets[indexPath.row]
        let index = selectedAssets.index(of: asset)!
        selectedAssets.remove(at: index)
    }
}

open class PhotoAssetCell: UICollectionViewCell {
    @IBOutlet var assetImageView: UIImageView!
    @IBOutlet var selectionImageView: UIImageView!

    open var photoAssetImageView: UIImageView! {
        return assetImageView
    }
    
    open var photoSelectionImageView: UIImageView! {
        return selectionImageView
    }
    
    override open var isSelected: Bool {
        didSet {
            photoSelectionImageView.isHighlighted = isSelected
        }
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()        
    }
    
    open func reuse(with asset: PHAsset, assetPixelSize: CGSize) {
//        print(type(of: self), "reuse", assetImageView.frame.size)
        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true
        PHImageManager.default().requestImage(for: asset, targetSize: assetPixelSize, contentMode: .aspectFill, options: options) { [weak self] (image, info) in
			self?.photoAssetImageView.contentMode = .scaleAspectFill
            self?.photoAssetImageView.image = image        
        }
    }
}
