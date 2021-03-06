//
//  CollectionViewController.swift
//  MyStory
//
//  Created by Jessica Choi on 7/7/16.
//  Copyright © 2016 Jessica Choi. All rights reserved.
//

import UIKit
import Photos
class CollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {


    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchCollectionView: UICollectionView!
    
    var posts : [Post]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchCollectionView.dataSource = self
        searchCollectionView.delegate = self
        
        loadPosts()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        searchCollectionView.insertSubview(refreshControl, atIndex: 0)

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        loadPosts()
        searchCollectionView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let posts = posts {
            print("returning \(posts.count)")
            return posts.count
        }
        print("returning 0")
        return 0
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

    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = searchCollectionView.dequeueReusableCellWithReuseIdentifier("CollectionCell", forIndexPath: indexPath) as! CollectionCell
        let post = posts[indexPath.row]
        
        cell.cellImage.image = self.getAssetThumbnail(post.photos![0])
        return cell
    }
    
    func loadPosts() {
        //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            self.posts = NSKeyedUnarchiver.unarchiveObjectWithFile(Post.ArchiveURL.path!) as? [Post]
        //}
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        loadPosts()
        self.searchCollectionView.reloadData()
        refreshControl.endRefreshing()
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    /*override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let vc = segue.destinationViewController as! CreatePostViewController
        vc.posts = posts
    }*/

}
	