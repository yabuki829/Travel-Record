//
//  PostViewController.swift
//  map
//
//  Created by Yabuki Shodai on 2021/05/25.
//

import UIKit

import FirebaseAuth
import FirebaseFirestore
import Firebase
import Photos
import CoreLocation

class PostViewController: UIViewController,UIImagePickerControllerDelegate & UINavigationControllerDelegate, CLLocationManagerDelegate{
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var postButton: UIBarButtonItem!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var placeTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    var locationManager: CLLocationManager!
    let geocoder = CLGeocoder()
    var Database = Firestore.firestore()
    var  latitudeData  = Double()
    var longitudeData = Double()
    var imageArray = [UIImage]()
    var dateString = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        grabPhotos()
        
        postButton.isEnabled = true
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        titleTextField.resignFirstResponder()
        
        textView.resignFirstResponder()
        
        
    }
    @IBAction func post(_ sender: Any) {
        if self.titleTextField.text?.isEmpty == true {
            print("タイトルが入力されてません")
            return
        }
       
        if textView.text.isEmpty == true {
            print("文章が入力されてません")
            return
        }
        
        getDate()
        postButton.isEnabled = false
        //画像　タイトル　感想　文章 座標　　の　５つをfirebaseに保存する
        let passData = self.imageView.image?.jpegData(compressionQuality: 2.0   )
       
        let imageRef = Storage.storage().reference().child("image").child("\(UUID().uuidString + String(Date().timeIntervalSince1970)).jpg")
        
        imageRef.putData(passData!, metadata: nil) { (metadata, error) in
            if error != nil {
                print(error)
                return
                
            }
            imageRef.downloadURL { (url, error) in
                if error != nil {
                    print("error")
                    return
                }
                self.Database.collection("Users").document(Auth.auth().currentUser!.uid).collection("Posts").document().setData(["title":self.titleTextField.text,"content":self.textView.text,"image": url?.absoluteString,"postDate": Date().timeIntervalSince1970,"dateString": self.dateString,"latitude":self.latitudeData,"longitude":self.longitudeData])
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    func setupLocationManager() {
        locationManager = CLLocationManager()
        guard let locationManager = locationManager else { return }
        locationManager.requestWhenInUseAuthorization()
        
        let status = CLLocationManager.authorizationStatus()
        if status == .authorizedWhenInUse {
            locationManager.delegate = self
            locationManager.distanceFilter = 10
            locationManager.startUpdatingLocation()
            
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let location = locations.first
        let latitude = location?.coordinate.latitude
        let longitude = location?.coordinate.longitude
        latitudeData = latitude!
        longitudeData = longitude!//Double
        
        
        let Location = CLLocation(latitude: latitude!, longitude: longitude!)
        CLGeocoder().reverseGeocodeLocation(Location) { placemarks, error in
            if let placemark = placemarks?.first {
                print(placemark)
                let country = String(placemark.country!)
                let locality = placemark.locality
                if let Area = placemark.administrativeArea {
                    print(placemark.administrativeArea!)
                    self.placeTextField.text = "\(String(country + Area + locality!))"
                }
                self.placeTextField.text = "\(String(country + locality!))"
            }
            
            
        }
    }
    @IBAction func getLocation(_ sender: Any) {
        setupLocationManager()
        
    }
    

    
}


extension PostViewController:UICollectionViewDataSource, UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
 
        return imageArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell2", for: indexPath)
        let image =  cell.contentView.viewWithTag(1) as! UIImageView
        image.contentMode = .scaleToFill
        image.image = imageArray[indexPath.row]
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 4 - 1
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var selectImage = imageArray[indexPath.row]
        
        imageView.image = selectImage
    }
    //コレクション系
    func grabPhotos(){
        print("呼ばれました")
        let imgManager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
        
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false )]
        
        //写真などのデータを PHFetchResult インスタンスとして取得
        let fetchResult:PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        print(fetchResult)
        if fetchResult.count > 0 {
            for i in 0..<fetchResult.count{
                
                imgManager.requestImage(for: fetchResult.object(at: i) as! PHAsset, targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: requestOptions) { image , error in
                    self.imageArray.append(image!)
                }
            }
            
            self.collectionView.reloadData()
        }
        else {
           
        }
        self.collectionView.reloadData()
        
    }
}



extension PostViewController{
    


    
    //日付の取得
    func getDate(){
        let now = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyy年MM月dd日"
        let date = formatter.string(from: now as Date)
        dateString = date
    }
}
