//
//  ProfileViewController.swift
//  map
//
//  Created by Yabuki Shodai on 2021/05/25.

//map sns

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import  SDWebImage
class ProfileViewController: UIViewController{
    
    var db = Firestore.firestore()
    var postArray = [DataSetCoordinate]()
    var transitionArray = [DataSetCoordinate]()
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        loadDataBase()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! DetailViewController
        nextVC.array = transitionArray
    }
    
}

extension ProfileViewController{
    func loadDataBase(){
        db.collection("Users").document(Auth.auth().currentUser!.uid).collection("Posts").order(by:"postDate", descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil{
                print(error as Any)
                return
            }
            
            self.postArray = []
            if let snapShotDoc = snapshot?.documents {
                for doc in snapShotDoc {
                    let data = doc.data()
                    if let title = data["title"],let content = data["content"],let postDate = data["postDate"],let latitude = data["latitude"],let longitude = data["longitude"],let image = data["image"]{
                        let  newDataSet = DataSetCoordinate(title: title as! String, content: content as! String, postDate: postDate as! Double,  latitudeDouble: latitude as! Double, longitudeDouble: longitude as! Double, image: image as! String)
                        print("postArrayに入れてます")
                        self.postArray.append(newDataSet)
                        
                    }
                    
                    
                }
                
            }
            print(self.postArray.count)
            self.collectionView.reloadData()
        }
    }
}

extension ProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return postArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let image = cell.contentView.viewWithTag(1) as! UIImageView
        print(self.postArray[indexPath.row])
        print(indexPath.row)
        image.sd_setImage(with: URL(string: postArray[indexPath.row].image), completed: nil)
        image.contentMode = .scaleAspectFill
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width /  4 - 1
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        transitionArray = [DataSetCoordinate]()
        self.transitionArray.append(self.postArray[indexPath.row])
        self.performSegue(withIdentifier: "detail", sender: self)
    }
}
