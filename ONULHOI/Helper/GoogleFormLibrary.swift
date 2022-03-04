//
//  GoogleFormLibrary.swift
//  FeedbackApp
//
//  Created by Aniket Patil on 15/10/16.
//  Copyright © 2016 Aniket Patil. All rights reserved.
//

import Foundation

public var googleForml: String!
public var entryData = NSDictionary()
public var postData : String! = ""
var data:String! = ""
var data2:String! = ""

public class GoogleForm {
    
    public func clear()
    {
        postData = ""
        googleForml = ""
        
    }
    public func setGoogleFormLink(text:String)
    {
        googleForml = text
        postData.append(contentsOf: text)
    }
    
    public func setNextFields(entry:String,value:String)
    {
        data2 = "&"+entry+"="+value
        postData.append(contentsOf: data2)
    }
    
    public func sendToGoogleForm() -> Bool {
        
        guard let url = URL(string:googleForml) else { return false }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = postData.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {data, response, error -> Void in
            print(response as Any)
        })
        
        task.resume()
        return true
    }
}
