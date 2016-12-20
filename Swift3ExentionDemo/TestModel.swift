//
//  TestModel.swift
//  Swift3ExentionDemo
//
//  Created by 麻阳 on 16/12/20.
//  Copyright © 2016年 麻阳. All rights reserved.
//

import UIKit

class TestModel: NSObject {
    
    var medicine_id:Int = 0
    
    var name:String?
    
    var app_medicine_code:String?
    
    var upc:String?
    
    var medicine_no:String?
    
    var spec:String?
    
    var price:Float = 0.0
    
    var stock:Int = 0
    
    var category_code:String?
    
    var category_name:String?
    
    
    override var description: String{
        
        
        
        return "medicine_id = " + "\(medicine_id)\n"+"name = \(name!)\n app_medicine_code = \(app_medicine_code!)\n medicine_no= \(medicine_no!)"
    }
    

}
