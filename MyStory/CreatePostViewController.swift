//
//  CreatePostViewController.swift
//  MyStory
//
//  Created by Jessica Choi on 7/7/16.
//  Copyright © 2016 Jessica Choi. All rights reserved.
//

import UIKit
import BSImagePicker
import Photos

class CreatePostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var titleFieldLabel: UILabel!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var captionField: UITextView!
    @IBOutlet weak var photoView: UIImageView!
    
    var photos: [PHAsset] = []
    var posts: [Post]?
    var collectionVC: CollectionViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        posts = NSKeyedUnarchiver.unarchiveObjectWithFile(Post.ArchiveURL.path!) as? [Post]
        if posts == nil {
            posts = []
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let size = CGSize(width: 600, height: 600)
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        photoView.image = resize(originalImage, newSize: size)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRectMake(0, 0, newSize.width, newSize.height))
        resizeImageView.contentMode = UIViewContentMode.ScaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    @IBAction func photoLibrary(sender: AnyObject) {
//        let libraryvc = UIImagePickerController()
//        libraryvc.delegate = self
//        libraryvc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        let vc = BSImagePickerViewController()
        photos = []
        
        bs_presentImagePickerController(vc, animated: true, select: { (asset: PHAsset) -> Void in
            // User selected an asset.
            // Do something with it, start upload perhaps?

            self.photos.append(asset)
            
            }, deselect: { (asset: PHAsset) -> Void in
                // User deselected an assets.
                // Do something, cancel upload?
                let i = self.photos.indexOf(asset) ?? -1
                self.photos.removeAtIndex(i)
                
            }, cancel: { (assets: [PHAsset]) -> Void in
                // User cancelled. And this where the assets currently selected.
                self.photos = []
            }, finish: { (assets: [PHAsset]) -> Void in
                // User finished with these assets
                self.photoView.image = self.getAssetThumbnail(self.photos[0])

            }, completion: nil)

        //        self.presentViewController(vc, animated: true, completion: nil)
    }

    
    func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.defaultManager()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.synchronous = true
        manager.requestImageForAsset(asset, targetSize: CGSize(width: 100.0, height: 100.0), contentMode: .AspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }
    

    
    @IBAction func createPost(sender: AnyObject) {

        
        let title = titleField.text
        let caption = captionField.text
        let date = datePicker.date
        
        if photos.count != 0 {
            print (photos.count)
            if title != nil && caption != nil {
                let newPost = Post.init(photos: photos, title: title, caption: caption, date: date)
                self.posts?.insert(newPost!, atIndex: 0)
                savePosts()
            }
        }
        self.dismissViewControllerAnimated(true, completion: nil)
        
//        NSNotificationCenter.defaultCenter().postNotificationName("madePost", object: nil)
        
    }
    
    @IBAction func cancelPost(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func savePosts(){
        let isSuccessfulPost = NSKeyedArchiver.archiveRootObject(posts!, toFile: Post.ArchiveURL.path!)
        if !isSuccessfulPost {
            print("failed to save post")
        } else {
            print("posted successfully")
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
