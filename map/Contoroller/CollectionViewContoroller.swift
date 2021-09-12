//
//  CollectionViewContoroller.swift
//  map
//
//  Created by Yabuki Shodai on 2021/06/23.
//


import UIKit
import Photos

class CollectionViewContoroller: UICollectionViewController{
    
    
    var imageArray = [UIImage]()
    override func viewDidLoad(){
        grabPhotos()
    }
    func grabPhotos(){
        let imgManager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
        
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        //写真などのデータを PHFetchResult インスタンスとして取得
        let fetchResult:PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        if fetchResult.count > 0 {
            for i in 0..<fetchResult.count{
                imgManager.requestImage(for: fetchResult.object(at: i) as! PHAsset, targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: requestOptions) { image , error in
                    self.imageArray.append(image!)
                }
            }
        }
        else {
            print("You got no Photos! ")
            self.collectionView.reloadData()
        }
        
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let imageView = cell.contentView.viewWithTag(1) as! UIImageView
        imageView.image = imageArray[indexPath.row]
        
        return cell
    }
}

