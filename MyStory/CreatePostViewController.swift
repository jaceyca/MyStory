//
//  CreatePostViewController.swift
//  MyStory
//
//  Created by Jessica Choi on 7/7/16.
//  Copyright © 2016 Jessica Choi. All rights reserved.
//

import UIKit

class CreatePostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var titleFieldLabel: UILabel!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var descriptionField: UITextView!
    @IBOutlet weak var photoView: UIImageView!
    
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
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        photoView.image = originalImage
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func photoLibrary(sender: AnyObject) {
        let libraryvc = UIImagePickerController()
        libraryvc.delegate = self
        libraryvc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(libraryvc, animated: true, completion: nil)
    }
    
    @IBAction func createPost(sender: AnyObject) {
        let photo = photoView.image
        let title = titleField.text
        let caption = descriptionField.text
        let date = datePicker.date
        if photo != nil && title != nil && caption != nil {
            let newPost = Post.init(photo: photo, title: title, caption: caption, date: date)
            posts?.insert(newPost!, atIndex: 0)
            
            savePosts()
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
