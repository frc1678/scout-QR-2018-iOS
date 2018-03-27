//
//  ViewController.swift
//  QRCode-Generator
//
//  Created by Janet Liu on 3/27/18.
//  Copyright © 2018 Janet Liu. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var cycleNumberLabel: UILabel!
    @IBOutlet weak var QRImageView: UIImageView!
    var QRCodeImage: CIImage!
    var firebase: DatabaseReference!
    var cycleNumber: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firebase = Database.database().reference()
        var QRCodeText: String!
        var QRCodeData: NSData!
        self.firebase.child("QRCode").observe(.value, with: { (snap) in
            QRCodeText = snap.value as! String
            self.cycleNumber = Int(QRCodeText.dropLast(18))
            QRCodeData = QRCodeText.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)! as NSData
            
            // Generating UIImage of QRCode
            let filter = CIFilter(name: "CIQRCodeGenerator")
            filter!.setValue(QRCodeData!, forKey: "inputMessage")
            filter!.setValue("H", forKey: "inputCorrectionLevel")
            
            self.QRCodeImage = filter!.outputImage
            self.cycleNumberLabel.text = "Cycle Number: \(self.cycleNumber!)"
            self.displayQRCodeImage()
        })
    }
    
    // Scales up the QRCode so it is not blurry
    func displayQRCodeImage() {
        let scaleX = QRImageView.frame.size.width / QRCodeImage.extent.size.width
        let scaleY = QRImageView.frame.size.height / QRCodeImage.extent.size.height
        
        let transformedImage = QRCodeImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
        
        QRImageView.image = UIImage(ciImage: transformedImage)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

