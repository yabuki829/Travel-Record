//
//  ViewController.swift
//  map
//
//  Created by Yabuki Shodai on 2021/05/20.
//

import UIKit
import MapKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var  locationManager:CLLocationManager!
    
    var num = 0
    var num2 = 0
    var type = false
    var db = Firestore.firestore()
    var postArray = [DataSetCoordinate]()
    var dateString = String()
    //遷移後に値を送るためのに使う配列
    var transitionArray = [DataSetCoordinate]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager = CLLocationManager()  // 変数を初期化
        locationManager.delegate = self
        locationManager.startUpdatingLocation()  // 位置情報更新を指示
        locationManager.requestWhenInUseAuthorization()  // 位置情報取得の許可を得る
        loadDataBase()
    }
    override func viewWillAppear(_ animated: Bool) {
        let annotation = MKPointAnnotation()
        mapView.removeAnnotation(annotation)
    }


    @IBAction func changeMapType(_ sender: Any) {
        type = !type
        if type == true {
            mapView.mapType = .hybrid
        }
        if type == false {
            mapView.mapType = .standard
        }
    }
    @objc func buttonEvent(_ sender: UIButton) {
        
        if transitionArray.count != 0{
            self.performSegue(withIdentifier: "detail", sender: self)
        }
        else {
            let alert = UIAlertController(title: "報告", message: "削除された投稿です", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        }
    }
    
 
    @IBAction func fucusUserLocation(_ sender: Any) {
        
        mapView.setCenter(mapView.userLocation.coordinate, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if segue.identifier == "detail" {
           
                let nextVC = segue.destination as! DetailViewController
                
                //遷移後に値を送るためのに使う配列
                nextVC.array = transitionArray
          
        }
        return
    }
    
}

extension UIImage {
    public convenience init(url: String) {
        let url = URL(string: url)
        do {
            let data = try Data(contentsOf: url!)
            self.init(data: data)!
            return
        } catch let err {
            print(err)
        }
        self.init()
    }
}


extension MapViewController:CLLocationManagerDelegate,UIGestureRecognizerDelegate,MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let title = view.annotation?.title
        var filterArray = [DataSetCoordinate]()
        transitionArray = [DataSetCoordinate]()
        filterArray = postArray.filter { ($0.title) == title}
        transitionArray.append(contentsOf: filterArray)
        if transitionArray.isEmpty == true {
            return
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
       
        if (annotation is MKUserLocation) {
              return nil
        }
        
        var filterArray = [DataSetCoordinate]()
        var filterString = String()
        filterString = annotation.title!!
        
        
        filterArray = postArray.filter { ($0.title) == filterString}
       
        let myPinIdentifier = "PinAnnotationIdentifier"
        // ピンを生成.
        let myPinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: myPinIdentifier)

        
        // コールアウトを表示する.
        myPinView.canShowCallout = true
        
        
        let annotation = annotation
        
        myPinView.annotation = annotation

            
        let rightImageView = UIImageView(image: UIImage(url:filterArray[0].image))
        rightImageView.contentMode = .scaleAspectFit
        rightImageView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        let btn = UIButton()
        
        btn.setTitle("＞＞", for: UIControl.State.normal)
        btn.frame = CGRect(x:0, y:0,
                              width:40, height:40)
        btn.setTitleColor(UIColor.darkGray, for: .normal)
        btn.addTarget(self, action: #selector(buttonEvent(_:)), for: UIControl.Event.touchUpInside)
        myPinView.rightCalloutAccessoryView = btn
        myPinView.leftCalloutAccessoryView = rightImageView
        return myPinView
    }
}

extension MapViewController{
    func loadDataBase(){
        db.collection("Users").document(Auth.auth().currentUser!.uid).collection("Posts").order(by:"postDate", descending: false).addSnapshotListener { (snapshot, error) in
            if error != nil{
                return
            }
            self.postArray = []
            if let snapShotDoc = snapshot?.documents {
                for doc in snapShotDoc {
                    let data = doc.data()
                    if let title = data["title"],let content = data["content"],let postDate = data["postDate"],let latitude = data["latitude"],let longitude = data["longitude"],let image = data["image"]{
                        let  newDataSet = DataSetCoordinate(
                            title: title as! String,
                            content: content as! String,
                            postDate: postDate as! Double,
                            latitudeDouble: latitude as! Double,
                            longitudeDouble: longitude as! Double,
                            image: image as! String)
                        self.postArray.append(newDataSet)
                        }
                    }
                
                for array in self.postArray{
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2DMake(array.latitudeDouble,array.longitudeDouble)
                    annotation.title = array.title
                    
                    annotation.subtitle = self.changeUnixToNSDate(dateUnix: array.postDate)
                    self.mapView.addAnnotation(annotation)
                  
                }
                
            }
            
        }
    }
    func changeUnixToNSDate(dateUnix:Double) -> String{
        let date = NSDate(timeIntervalSince1970: dateUnix)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日 HH時mm分"
        dateString = formatter.string(from: date as Date)
        return dateString
    }
    
}
