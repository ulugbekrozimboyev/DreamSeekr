//
//  ViewController.swift
//  DreamSeekr
//
//  Created by Ulugbek on 11/30/16.
//  Copyright © 2016 Ulugbek. All rights reserved.
//

import UIKit
import MobileCoreServices

class ViewController: UIViewController,UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var textField: UITextField!
    
    var dream:Dream = Dream()
    
    @IBAction func addImage(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        
//        presentedViewController(imagePicker, animated: true, completion: (() -> Void)? )
        
        present(imagePicker, animated: true)
        
    }
    
    @IBAction func saveImage(_ sender: Any) {
        
        var dictionary:[String:Any] = [:]
        dictionary.updateValue(dream.name as AnyObject, forKey: "name")
        dictionary.updateValue(dream.created, forKey: "created")
        dictionary.updateValue(dream.achived as AnyObject, forKey: "achived")
        dictionary.updateValue(dream.imageUrl as AnyObject, forKey: "imageUrl")
        
        if var array = UserDefaults.standard.object(forKey: "dreams") as? [Any] {
            
            array.append(dictionary)
            UserDefaults.standard.set(array, forKey: "dreams")
        } else {
            let array:[Any] = [dictionary]
            UserDefaults.standard.set(array, forKey: "dreams")
        }
        
        
    }
    
    override func loadView() {
        super.loadView() 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        dream.name = textField.text!
        return true
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: { () -> Void in
            
            if let mediaType = info[UIImagePickerControllerMediaType] as? NSObject,
            let image = info[UIImagePickerControllerOriginalImage] as? UIImage,
            let imageLinkUrl = info[UIImagePickerControllerReferenceURL] as? NSURL
            //    mediaType == kCIAttributeTypeImage
            {
                
                    self.imageView.image = image
                
                    let pngData = UIImagePNGRepresentation(image)
                
                var fileName = ""
                
                if let query = imageLinkUrl.query {
                    let array = query.components(separatedBy: "&")
                    
                    for item in array where item.hasPrefix("id") || item.hasPrefix("ext") {
                        let items = item.components(separatedBy: "=")
                        
                        if items.count > 0 {
                            fileName += items[1]
                        } else {
                            fileName += "." + items[1].lowercased()
                        }
                    }
                }
                
                let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
                
                let documentPath = path[0] as String
                
                let filePath = documentPath.appending("/" + fileName)
                do {
                    try pngData?.write(to: URL(fileURLWithPath: filePath), options: .atomic)
                    self.dream.imageUrl = fileName
                } catch {
                    print(error)
                }
            }
            
        })
    }


}

