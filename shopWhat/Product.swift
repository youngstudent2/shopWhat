//
//  Product.swift
//  shopWhat
//
//  Created by nju on 2020/11/11.
//  Copyright © 2020 youngstudent2. All rights reserved.
//

import UIKit
import os.log
class Product : NSObject,NSCoding {
    var name : String
    var photo : UIImage?
    var rating: Int
    var comment : String?
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let rating = "rating"
        static let comment = "comment"
    }
    
    static let DocumentsDirectory = FileManager().urls(for:.documentDirectory,in:.userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("products")
    
    init?(name:String,photo:UIImage?,rating:Int,comment:String?){
        guard !name.isEmpty else {
            return nil
        }
        
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }
        self.name = name
        self.photo = photo
        self.rating = rating
        self.comment = comment
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Product object", log:OSLog.default,type:.debug)
            return nil
        }
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
        let comment = aDecoder.decodeObject(forKey: PropertyKey.comment) as? String
        self.init(name:name,photo:photo,rating:rating,comment:comment)
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name,forKey: PropertyKey.name)
        coder.encode(photo,forKey: PropertyKey.photo)
        coder.encode(rating,forKey: PropertyKey.rating)
        coder.encode(comment,forKey: PropertyKey.comment)
        
    }
}
