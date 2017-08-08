//
//  PhotoGroupsController.swift
//  PhotoPicker
//
//  Created by Dark Dong on 2017/6/24.
//  Copyright © 2017年 Dark Dong. All rights reserved.
//

import Photos

open class PhotoGroupsController: UITableViewController {
    @IBOutlet var cancelButtonItem: UIBarButtonItem!
    
    public var groups: [PHAssetCollection] = []
    
    deinit {
        print(type(of: self), "deinit")
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        print(type(of: self), "viewDidLoad")
        
        cancelButtonItem.title = pickerConfig?.cancelTitle
        
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized: //3
                self.loadData()
            default:
                break
            }
        }
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isToolbarHidden = true
    }
    
    open override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! PhotoGroupCell
        let indexPath = tableView.indexPath(for: cell)!
        let group = groups[indexPath.row]
        var assets: [PHAsset] = []
        let mediaType = pickerConfig!.mediaType
        PHAsset.fetchAssets(in: group, options: nil).enumerateObjects({ (asset, index, stop) in
            if mediaType == nil || asset.mediaType == mediaType {
                assets.append(asset)
            }
        })
        
        let vc = segue.destination as! PhotoAssetsController
        vc.title = group.localizedTitle
        vc.assets = assets
    }
    
    //called on non-main queue
    func loadData() {
        if groups.isEmpty {
            let result = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
            result.enumerateObjects({ (group, index, stop) in
                if group.assetCollectionSubtype == .smartAlbumUserLibrary {
                    self.groups.insert(group, at: 0)
                } else {
                    self.groups.append(group)
                }
            })
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    //MARK: - action
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        if let picker = picker, let _ = picker.pickerDelegate?.pickerDidCancel?(picker) {
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}

extension PhotoGroupsController {
    //MARK: - UITableViewDataSource
    
    open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    open override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let group = groups[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoGroupCell", for: indexPath) as! PhotoGroupCell
        cell.reuse(with: group, config: pickerConfig!)
        return cell
    }
}

open class PhotoGroupCell: UITableViewCell {
    @IBOutlet var coverImageview: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var countLabel: UILabel!
    
    open override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    open func reuse(with group: PHAssetCollection, config: PickerConfig) {
//        print(type(of: self), "reuse", coverImageview.frame.size)
        
        if let result = PHAsset.fetchKeyAssets(in: group, options: nil), let keyAsset = result.firstObject {
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            PHImageManager.default().requestImage(for: keyAsset, targetSize: coverImageview.frame.size, contentMode: .aspectFill, options: options) { [weak self] (image, info) in
                self?.coverImageview.image = image
            }
        } else {
            coverImageview.image = config.placeholderImage
        }
        
        titleLabel.text = group.localizedTitle
        
        let result = PHAsset.fetchAssets(in: group, options: nil)
        let count: Int
        if let mediaType = config.mediaType {
            count = result.countOfAssets(with: mediaType)
        } else {
            count = result.count
        }
        countLabel.text = "(\(count))"
    }
}
