//
//  DictionaryToModel.swift
//  Swift3ExentionDemo
//
//  Created by 麻阳 on 16/11/01.
//  Copyright © 2016年 麻阳. All rights reserved.
//

import Foundation


@objc public protocol DicModelProtocol{
    static func keyObjectClassMapping() -> [String: String]?
}


extension NSObject{
    
    //dic: 要进行转换的字典
    class func objectWithKeyValues(dict: NSDictionary)->AnyObject?{
        if BaseFoundation.isClassFromFoundation(c: self) {
            
            return nil
        }
        
        let obj:AnyObject = self.init()
        var cls:AnyClass = self.classForCoder()                                           //当前类的类型
        
        while("NSObject" !=  "\(cls)"){
            var count:UInt32 = 0
            let properties =  class_copyPropertyList(cls, &count)                         //获取属性列表
            for i in 0..<count{
                
                let property = properties?[Int(i)]
                
                
                var propertyType =  String(cString:property_getAttributes(property))  //属性类型
                let propertyKey = String(cString:property_getName(property))
                
                if propertyKey == "description"{ continue  }                              //description是计算型属性
                
                
                var value:AnyObject! = dict.object(forKey: propertyKey) as AnyObject!//取得字典中的值
                
                if value == nil {continue}
                
                let valueType =  "\(value.classForCoder)"     //字典中保存的值得类型
                if valueType == "NSDictionary"{               //1，值是字典。 这个字典要对应一个自定义的模型类并且这个类不是Foundation中定义的类型。
                    let subModelStr:String! = BaseFoundation.getType(code: &propertyType)
                    if subModelStr == nil{
                        print("字典中的键\(propertyKey)和模型中的不匹配")
                        assert(true)
                    }
                    if let subModelClass = NSClassFromString(subModelStr){
                        value = subModelClass.objectWithKeyValues(dict:value as! NSDictionary) //递归
                        
                    }
                }else if valueType == "NSArray"{              //值是数组。 数组中存放字典。 将字典转换成模型。 如果协议中没有定义映射关系，就不做处理
                    
                    if self.responds(to: Selector("keyObjectClassMapping")) {
                        if var subModelClassName = cls.keyObjectClassMapping()?[propertyKey]{   //子模型的类名称
                            subModelClassName =  BaseFoundation.bundlePath+"."+subModelClassName
                            if let subModelClass = NSClassFromString(subModelClassName){
                                value = subModelClass.objectArrayWithKeyValuesArray(array:value as! NSArray);
                                
                            }
                        }
                    }
                    
                }
                
                obj.setValue(value, forKey: propertyKey)
            }
            free(properties)                            //释放内存
            cls = cls.superclass()!                     //处理父类
        }
        return obj
    }
    
    /**
     将字典数组转换成模型数组
     array: 要转换的数组, 数组中包含的字典所对应的模型类就是 调用这个类方法的类
     
     当数组中嵌套数组， 内部的数组包含字典，cls就是内部数组中的字典对应的模型
     */
    class func objectArrayWithKeyValuesArray(array: NSArray)->NSArray?{
        if array.count == 0{
            return nil
        }
        var result = [AnyObject]()
        for item in array{
            let type = "\(((item as AnyObject).classForCoder)!)"
            if type == "NSDictionary" || type == "Dictionary" || type == "NSMutableDictionary"{
                if let model = objectWithKeyValues(dict: item as! NSDictionary){
                    result.append(model)
                    
                }
            }else if type == "NSArray" || type == "Array" || type == "NSMutableArray"{
                if let model =  objectArrayWithKeyValuesArray(array: item as! NSArray){
                    result.append(model)
                }
            }else{
                result.append(item as AnyObject)
            }
        }
        if result.count==0{
            return nil
        }else{
            return result as NSArray?
        }
    }
}


