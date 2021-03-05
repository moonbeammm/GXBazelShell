//
//  HomeViewController.swift
//  _idx_gxhome_library_007755E5_ios_min9.0
//
//  Created by sgx on 2020/8/24.
//

import UIKit
//import AVCaptureDevice
//import AVMediaFormat
//import Photos
//import AssetsLibrary
import Photos
import srcs_app_GXPlayer_gxplayer_library

public class HomeViewController: UIViewController {
    public override func viewDidLoad() {
        self.view.backgroundColor = UIColor.blue
//        获得相机胶卷
//        PHAssetCollectionTypeSmartAlbum = 2,  智能相册，系统自己分配和归纳的
//        PHAssetCollectionSubtypeSmartAlbumUserLibrary = 209,  相机胶卷
//        PHAssetCollection *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
//        相机胶卷相簿存储到数组
//        [allAlbumArray addObject:cameraRoll];
        
//        let cameraRoll = PHPhotoLibrary.
        
//        let assetArr: [PHAsset] = self.getAllAlbumAndPHAsset() {//获取照片资源
//            //吧强求到图片资源转换成UIIMgae，在回掉方法中获取图片data数据，然后做相应的操作
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
////                self.getImageFromPHAsset(asset: assetArr[0], size: CGSize.init(width: 100, height: 100))
//                let asset = PHAsset.init()
//                let size = CGSize.init(width: 100, height: 100)
//                self.getImageFromPHAsset(asset: asset, size: size)
//            }
//        }
        
        
//        let assetArr = self.getAllAlbumAndPHAsset()
//        print(assetArr)

    }
    
    
    //1.获取所有PHAsset资源的集合,包含视频和照片
    func getAllPHAssetFromSysytem()->([PHAsset]){
        var arr:[PHAsset] = []
        let options = PHFetchOptions.init()
        let assetsFetchResults:PHFetchResult = PHAsset.fetchAssets(with: options)
        // 遍历，得到每一个图片资源asset，然后放到集合中
        assetsFetchResults.enumerateObjects { (asset, index, stop) in
            arr.append(asset)
        }
        
        print("\(arr.count)")
        return arr
    }

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let playerVC = GXURLViewController.init()
        self.navigationController?.pushViewController(playerVC, animated: true)
    }

    //2.先获取所有相册，然后从相机胶卷中获取PHAsset集合,（相机胶卷是相册中的一个，包含了所有视频和相册）

    func getAllAlbumAndPHAsset()->([PHAsset]){
        
        var arr:[PHAsset] = []
        let options = PHFetchOptions.init()
        // 所有智能相册集合(系统自动创建的相册)
//        let smartAlbums:PHFetchResult = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.smartAlbum, subtype: PHAssetCollectionSubtype.albumRegular, options: options)
        let smartAlbums = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.smartAlbum, subtype: PHAssetCollectionSubtype.albumRegular, options: options)
        //遍历得到每一个相册
        for i in 0..<smartAlbums.count {
            // 是否按创建时间排序
            let options = PHFetchOptions.init()
            options.sortDescriptors = [NSSortDescriptor(key: "creationDate",
                                                        ascending: false)]//时间排序
            options.predicate = NSPredicate.init(format: "mediaType == %ld", PHAssetMediaType.image.rawValue)//˙只选照片
            
            let collection:PHCollection  = smartAlbums[i];//得到一个相册,一个集合就是一个相册
            /**
             相册标题英文：
             Portrait、Long Exposure、Panoramas、Hidden、Recently Deleted、Live Photos、Videos、Animated、Recently Added、Slo-mo、Time-lapse、Bursts、Camera Roll、Screenshots、Favorites、Selfies
             */
            print("相册标题---%@",collection.localizedTitle as Any);
            
            //遍历获取相册
            
            if collection is PHAssetCollection {
                if collection.localizedTitle == "相机胶卷" || collection.localizedTitle == "Camera Roll"{//相册的名字是相机交卷，这里面包含了所有的资源，包括照片、视频、gif。 注意相册名字中英文
                    let assetCollection = collection as! PHAssetCollection
                    //collection中的资源都统一使用PHFetchResult 对象封装起来。
                    //得到PHFetchResult封装的图片资源集合
                    let fetchResult:PHFetchResult = PHAsset.fetchAssets(in: assetCollection, options: nil)
                    
                    
                    var assetArr:[PHAsset] = []
                    if fetchResult.count>0{
                        //某个相册里面的所有PHAsset对象（PHAsset对象对应的是图片，需要通过方法请求到图片）
                        assetArr  = getAllPHAssetFromOneAlbum(assetCollection: assetCollection)
                        
                        arr.append(contentsOf: assetArr)
                    }
                }
            }
            
        }
        
        return arr
    }



    //获取一个相册里的所有图片的PHAsset对象
    func getAllPHAssetFromOneAlbum(assetCollection:PHAssetCollection)->([PHAsset]){
        // 存放所有图片对象
        var arr:[PHAsset] = []
        // 是否按创建时间排序
        let options = PHFetchOptions.init()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate",
                                                    ascending: false)]//时间排序
        options.predicate = NSPredicate.init(format: "mediaType == %ld", PHAssetMediaType.image.rawValue)//˙只选照片
        // 获取所有图片资源对象
        let results:PHFetchResult = PHAsset.fetchAssets(in: assetCollection, options: options)
        
        // 遍历，得到每一个图片资源asset，然后放到集合中
        results.enumerateObjects { (asset, index, stop) in
            print("\(asset)")
            arr.append(asset)
        }
        
        return arr
    }

    //    根据PHAsset获取原图片信息
    func getImageFromPHAsset(asset:PHAsset,size:CGSize){
        var requestID:PHImageRequestID = -2
        let scale:CGFloat = CGFloat(UIScreen.main.scale)
        let width:CGFloat = CGFloat(min(375, 500))
        if (requestID >= 1 && (size.width) / width == scale) {
            PHCachingImageManager.default().cancelImageRequest(requestID)
        }
        let option:PHImageRequestOptions=PHImageRequestOptions.init()
        option.deliveryMode = PHImageRequestOptionsDeliveryMode.opportunistic
        option.resizeMode = PHImageRequestOptionsResizeMode.fast;
        
//        requestID = PHCachingImageManager.default().requestImageData(for: asset, options: option, resultHandler: { (Dat, str, orientation, [AnyHashable : Any]?) in
//            //Dat是图片数据
////            self.image = UIImage.init(data: Dat!)
////            self.collec?.reloadData()
//            print(11)
//        })
        requestID = PHCachingImageManager.default().requestImageData(for: asset, options: option, resultHandler: { (Dat, str, orientation, any) in
            print(11)
        })
        
        //请求视频的
        //        requestID = PHCachingImageManager.default().requestAVAsset(forVideo: PHAsset, options: PHVideoRequestOptions?, resultHandler: { (<#AVAsset?#>, AVAudioMix?, [AnyHashable : Any]?) in
        //
        //        })
        
        
    }
}

extension HomeViewController {
    public override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear!")
    }
}




