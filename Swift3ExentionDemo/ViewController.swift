//
//  ViewController.swift
//  Swift3ExentionDemo
//
//  Created by 麻阳 on 16/12/20.
//  Copyright © 2016年 麻阳. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = Bundle.main.path(forResource: "test", ofType: "json")
        
        guard let tempPath = path else{
            
            return
        }
        
        let pathUrl = URL.init(fileURLWithPath: tempPath)
        
        let data:NSData? = NSData.init(contentsOf: pathUrl)
        
        
        let jsonObject:[String:Any] = try! JSONSerialization.jsonObject(with: data as! Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary
        
        
        let array:[TestModel] = TestModel.objectArrayWithKeyValuesArray(array: jsonObject["data"] as! NSArray) as! [TestModel]
        
        let model:TestModel = array[0]
        
        print(model.description)
        
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

