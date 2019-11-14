//
//  CameraViewController.swift
//  codepath-instagram
//
//  Created by Sergio P. on 11/13/19.
//  Copyright © 2019 Sergio P. All rights reserved.
//

import UIKit
import AlamofireImage
import Parse

class CameraViewController: UIViewController,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    // MARK: - Properties
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var captionField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        captionField.becomeFirstResponder()
    }
    
    // MARK: - Button Actions
    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onShare(_ sender: Any) {
        let post = PFObject(className: "posts")
        post["caption"] = captionField.text!
        post["author"] = PFUser.current()!
        
        post.saveInBackground { (success, error) in
            if success {
                print("Post saved!")
            } else {
                print("Error: \(error?.localizedDescription ?? "No description")")
            }
        }
    }
    
    @IBAction func onCameraButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        present(picker, animated: true, completion: nil)
    }
    
    // MARK: - Image Controller
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImg = info[.editedImage] as! UIImage
        let size = CGSize(width: 500, height: 500)
        let scaledImage = selectedImg.af_imageScaled(to: size)
        imageView.image = scaledImage
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
