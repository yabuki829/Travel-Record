//
//  ViewController.swift
//  map
//
//  Created by Yabuki Shodai on 2021/05/20.
//
//
//import UIKit
//import MapKit
//import Firebase
//import FirebaseFirestore
//import FirebaseAuth
//
//

//
//class MapViewController: UIViewController ,CLLocationManagerDelegate,UIGestureRecognizerDelegate,MKMapViewDelegate {
//
//    @IBOutlet weak var mapView: MKMapView!
//
//    var  locationManager:CLLocationManager!
//
//    var num = 0
//    var num2 = 0
//    var type = false
//    var db = Firestore.firestore()
//    var postArray = [DataSetCoordinate]()
//
//    override func viewDidLoad() {
//
//
//        super.viewDidLoad()
//        mapView.delegate = self
//        locationManager = CLLocationManager()  // 変数を初期化
//        locationManager.delegate = self
//        locationManager.startUpdatingLocation()  // 位置情報更新を指示
//        locationManager.requestWhenInUseAuthorization()  // 位置情報取得の許可を得る
//        loadDataBase()
//
//    }
//    override func viewWillAppear(_ animated: Bool) {
//    }
//
//
//
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//       
//        if (annotation is MKUserLocation) {
//              return nil
//            }
//        let myPinIdentifier = "PinAnnotationIdentifier"
//
//        // ピンを生成.
//        let myPinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: myPinIdentifier)
//
//        // アニメーションをつける.
//        myPinView.animatesDrop = true
//
//        // コールアウトを表示する.
//        myPinView.canShowCallout = true
//
//        // annotationを設定.
//        myPinView.annotation = annotation
//        let btn = UIButton()
//        btn.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
//        btn.setTitle(">", for: .normal)
//        btn.setTitleColor(UIColor.lightGray, for:.normal)
//        myPinView.rightCalloutAccessoryView = btn
//        if num <= postArray.count - 1{
//
//            let rightImageView = UIImageView(image: UIImage(url: postArray[num].image))
//            rightImageView.contentMode = .scaleAspectFit
//            rightImageView.frame = CGRect(x: 10, y: 0, width: 30, height: 30)
//            myPinView.leftCalloutAccessoryView = rightImageView
//            num = num + 1
//        }
//
//
//        return myPinView
//    }
//
//
//    //データベースからデータは持ってくる
//    func loadDataBase(){
//        db.collection("Users").document(Auth.auth().currentUser!.uid).collection("Posts").order(by:"postDate", descending: false).addSnapshotListener { (snapshot, error) in
//            if error != nil{
//                print(error)
//                return
//            }
//
//            self.postArray = []
//            if let snapShotDoc = snapshot?.documents {
//                for doc in snapShotDoc {
//
//                    let data = doc.data()
//
//
//                    if let title = data["title"], let subTitle = data["subTitle"],let latitude = data["latitude"],let longitude = data["longitude"],let image = data["image"]{
//                        let  newDataSet = DataSetCoordinate( latitudeDouble: latitude as! Double, longitudeDouble: longitude as! Double,  title: title as! String, subTitle: subTitle as! String, image: image as! String)
//                        self.postArray.append(newDataSet)
//                        self.num = 0
//
//                        }
//
//                    }
//                for array in self.postArray{
//                    let annotation = MKPointAnnotation()
//                    annotation.coordinate = CLLocationCoordinate2DMake(array.latitudeDouble,array.longitudeDouble)
//                    annotation.title = array.title
//
//
//                    annotation.subtitle = array.subTitle
//                  
//                    self.mapView.addAnnotation(annotation)
//
//                }
//
//            }
//
//        }
//    }
//
//    @IBAction func changeMapType(_ sender: Any) {
//        type = !type
//        if type == true {
//            mapView.mapType = .hybrid
//        }
//        if type == false {
//            mapView.mapType = .standard
//        }
//    }
//
//    @IBAction func fucusUserLocation(_ sender: Any) {
//        mapView.setCenter(mapView.userLocation.coordinate, animated: true)
//        print(mapView.userLocation.coordinate)
//    }
//
//}
//
//
//
//extension UIImage {
//    public convenience init(url: String) {
//        let url = URL(string: url)
//        do {
//            let data = try Data(contentsOf: url!)
//            self.init(data: data)!
//            return
//        } catch let err {
//            print("Error : \(err.localizedDescription)")
//            print("エラー")
//        }
//        self.init()
//    }
//
//
//}
//
//








//import UIKit
//import MapKit
//import Firebase
//import FirebaseFirestore
//import FirebaseAuth
//
//
//
//class MapViewController: UIViewController ,CLLocationManagerDelegate,UIGestureRecognizerDelegate,MKMapViewDelegate {
//
//    @IBOutlet weak var mapView: MKMapView!
//
//    var  locationManager:CLLocationManager!
//
//    var num = 0
//    var num2 = 0
//    var type = false
//    var db = Firestore.firestore()
//    var postArray = [DataSetCoordinate]()
//    var annotationArray = [MKAnnotation]()
//    override func viewDidLoad() {
//
//
//        super.viewDidLoad()
//        mapView.delegate = self
//        locationManager = CLLocationManager()  // 変数を初期化
//        locationManager.delegate = self
//        locationManager.startUpdatingLocation()  // 位置情報更新を指示
//        locationManager.requestWhenInUseAuthorization()  // 位置情報取得の許可を得る
//        loadDataBase()
//
//    }
//    override func viewWillAppear(_ animated: Bool) {
//    }
//
//
//
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//
//
//        if (annotation is MKUserLocation) {
//              return nil
//            }
//        let myPinIdentifier = "PinAnnotationIdentifier"
//
//        // ピンを生成.
//        let myPinView = MKPinAnnotationView(annotation: annotationArray[num], reuseIdentifier: myPinIdentifier)
//
//        // アニメーションをつける.
//        myPinView.animatesDrop = true
//
//        // コールアウトを表示する.
//        myPinView.canShowCallout = true
//
////         annotationを設定.
//
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = CLLocationCoordinate2DMake(self.postArray[num].latitudeDouble,self.postArray[num].longitudeDouble)
//        myPinView.annotation = annotation
//        num2 += 1
//        print("aaaaaaaaaaaaaaaaaa")
//        print("\(self.num2)回目")
//
//        print("anotation\(annotation)")
//        annotation.title = postArray[num].title
//        print(annotation.title)
//        print("myPinView\(myPinView.annotation)")
//
//        let btn = UIButton()
//        btn.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
//        btn.setTitle(">", for: .normal)
//        btn.setTitleColor(UIColor.lightGray, for:.normal)
//        myPinView.rightCalloutAccessoryView = btn
//
//
//            let rightImageView = UIImageView(image: UIImage(url: postArray[num].image))
//            rightImageView.contentMode = .scaleAspectFit
//            rightImageView.frame = CGRect(x: 10, y: 0, width: 30, height: 30)
//            myPinView.leftCalloutAccessoryView = rightImageView
//            num = num + 1
//
//
//        return myPinView
//    }
//
//
//    //データベースからデータは持ってくる
//    func loadDataBase(){
//        db.collection("Users").document(Auth.auth().currentUser!.uid).collection("Posts").order(by:"postDate", descending: false).addSnapshotListener { (snapshot, error) in
//            if error != nil{
//                print(error)
//                return
//            }
//
//            self.postArray = []
//            if let snapShotDoc = snapshot?.documents {
//                for doc in snapShotDoc {
//
//                    let data = doc.data()
//
//
//                    if let title = data["title"], let subTitle = data["subTitle"],let latitude = data["latitude"],let longitude = data["longitude"],let image = data["image"]{
//                        let  newDataSet = DataSetCoordinate( latitudeDouble: latitude as! Double, longitudeDouble: longitude as! Double,  title: title as! String, subTitle: subTitle as! String, image: image as! String)
//                        self.postArray.append(newDataSet)
//                        self.num = 0
//
//                        }
//
//                    }
//                for array in self.postArray{
//                    let annotation = MKPointAnnotation()
//                    annotation.coordinate = CLLocationCoordinate2DMake(array.latitudeDouble,array.longitudeDouble)
////                    annotation.title = array.title
//
//                    print("--------------------------------")
//                    print(array.title)
////                    annotation.subtitle = array.subTitle
//                    print(annotation)
//                    self.annotationArray.append(annotation)
//                    print("--------------------------------")
//                    self.mapView.addAnnotation(annotation)
//
//                }
//
//            }
//
//        }
//    }
//
//    @IBAction func changeMapType(_ sender: Any) {
//        type = !type
//        if type == true {
//            mapView.mapType = .hybrid
//        }
//        if type == false {
//            mapView.mapType = .standard
//        }
//    }
//
//    @IBAction func fucusUserLocation(_ sender: Any) {
//        mapView.setCenter(mapView.userLocation.coordinate, animated: true)
//        print(mapView.userLocation.coordinate)
//    }
//
//}
//
//
//
//extension UIImage {
//    public convenience init(url: String) {
//        let url = URL(string: url)
//        do {
//            let data = try Data(contentsOf: url!)
//            self.init(data: data)!
//            return
//        } catch let err {
//            print("Error : \(err.localizedDescription)")
//            print("エラー")
//        }
//        self.init()
//    }
//
//
//}
