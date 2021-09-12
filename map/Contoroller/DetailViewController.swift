//
//  DetailViewController.swift
//  map
//
//  Created by Yabuki Shodai on 2021/06/23.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class DetailViewController: UIViewController {
    var array = [DataSetCoordinate]()
    var dateString = String()
    var Database = Firestore.firestore()
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeUnixToNSDate(dateUnix: array[0].postDate)
        setImageandText()
      
        
    }
    @IBAction func imageTap(_ sender: Any) {
        self.performSegue(withIdentifier: "imageDetail", sender: self)
    }
    @IBAction func destroyPost(_ sender: Any) {
        let okAlert = UIAlertController(title: "報告", message: "投稿を削除しますがよろしいですか？", preferredStyle: .alert)
        
        let confirmAction: UIAlertAction = UIAlertAction(title: "削除", style: UIAlertAction.Style.default, handler:{ [self]
            (action: UIAlertAction!) -> Void in
            let DeleatDoc = Database.collection("Users").document(Auth.auth().currentUser!.uid).collection("Posts").whereField("postDate", in: [array[0].postDate]).getDocuments { (QuerySnapshot, Error) in
                if let error = Error{
                    return
                }
                for document in QuerySnapshot!.documents {
                      document.reference.delete()
                }
                self.navigationController?.popViewController(animated: true)
            }
           
        })
        self.present(okAlert, animated: true, completion: nil)
     
        okAlert.addAction(confirmAction)
        okAlert.addAction(UIAlertAction(title: "キャンセル", style: .default, handler: nil))
        
    }

    
    
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "detail" {
            print("--------detailに遷移します---------")
            print(array)
            let nextVC = segue.destination as! ProfileViewController
            nextVC.transitionArray = array
        }
        else if segue.identifier == "imageDetail"{
            print("imageDetail")
            let nextVC = segue.destination as! ImageDetailViewController
            nextVC.imageString = array[0].image
        }
        return
    }
    func  getDocumentID(){}
    func setImageandText(){
        textLabel.text = array[0].content
        titleText.text = array[0].title
        dateLabel.text = dateString
        imageView.sd_setImage(with: URL(string: array[0].image, relativeTo: nil))
    }
    func changeUnixToNSDate(dateUnix:Double) -> String{
        
        // UNIX時間 "dateUnix" をNSDate型 "date" に変換
        
        
        let date = NSDate(timeIntervalSince1970: dateUnix)
        
        // NSDate型を日時文字列に変換するためのNSDateFormatterを生成
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        // NSDateFormatterを使ってNSDate型 "date" を日時文字列 "dateStr" に変換
        dateString = formatter.string(from: date as Date)
        
        //なんとなくdateString返す　理由は特になし。
        return dateString
        
    }
    
    
    
    
}
