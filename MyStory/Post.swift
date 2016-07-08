//
//  Post.swift
//  MyStory
//
//  Created by Jessica Choi on 7/7/16.
//  Copyright © 2016 Jessica Choi. All rights reserved.
//

import UIKit

struct PropertyKey {
    static let dateKey = "date"
    static let photoKey = "photo"
    static let titleKey = "title"
    static let captionKey = "caption"
}

class Post: NSObject, NSCoding {
    
    var date: NSDate?
    var photo: UIImage?
    var title: String?
    var caption: String?
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("posts")
    
    init?(photo: UIImage?, title: String?, caption: String?, date: NSDate?) {
        // Initialize stored properties.
        self.date = date
        self.photo = photo
        self.title = title
        self.caption = caption
        
        super.init()
        
//        // Initialization should fail if there is no name or if the rating is negative.
//        if name.isEmpty || rating < 0 {
//            return nil
//      }
    
    }

    func encodeWithCoder(aCoder: NSCoder){
        
        
        aCoder.encodeObject(date, forKey: PropertyKey.dateKey)
        aCoder.encodeObject(photo, forKey: PropertyKey.photoKey)
        aCoder.encodeObject(caption, forKey: PropertyKey.captionKey)
        aCoder.encodeObject(title, forKey: PropertyKey.titleKey)
    
        
    }
    required convenience init?(coder aDecoder: NSCoder) {
        
        let date = aDecoder.decodeObjectForKey(PropertyKey.dateKey) as? NSDate
        let photo = aDecoder.decodeObjectForKey(PropertyKey.photoKey) as? UIImage
        let title = aDecoder.decodeObjectForKey(PropertyKey.titleKey) as! String
        let caption = aDecoder.decodeObjectForKey(PropertyKey.captionKey) as! String
        
        self.init(photo: photo, title: title, caption: caption, date: date)


    }
    
}


//
//class func formatDateToStandardString(date: NSDate) -> String {
//    let dateFormatter = NSDateFormatter()
//    dateFormatter.dateFormat = "M/dd/yy, h:mm a"
//    let dateString = dateFormatter.stringFromDate(date)
//    return dateString
//}