//
//  ImageDetailViewController.swift
//  map
//
//  Created by Yabuki Shodai on 2021/06/25.
//

import UIKit

class ImageDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var imageString = String()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        imageView.sd_setImage(with: URL(string: imageString, relativeTo: nil))
        // Do any additional setup after loading the view.
    }


    
    @IBAction func downLoadImage(_ sender: Any) {
        print("downLoad")
        let targetImage = imageView.image
        UIImageWriteToSavedPhotosAlbum(targetImage!,self,#selector(showResultOfSaveImage(_:didFinishSavingWithError:contextInfo:)),nil)
    }
    
    
    @objc func showResultOfSaveImage(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeMutableRawPointer) {

        var title = "保存完了"
        var message = "カメラロールに保存しました"
        if error != nil {
          title = "エラー"
          message = "保存に失敗しました"
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        // OKボタンを追加
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        // UIAlertController を表示
        self.present(alert, animated: true, completion: nil)
      }
}
