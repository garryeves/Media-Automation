//
//  SocialMediaTargets.swift
//  Media Automation
//
//  Created by Garry Eves on 17/1/20.
//  Copyright © 2020 Garry Eves. All rights reserved.
//

import Foundation
import SwiftyJSON

let socialMediaServices = ["YouTube", "Facebook", "LinkedIn", "Twitter", "Instagram"]

let podcastSM = "Podcast"

let websiteSM = "Website"

class socialMediaTargets: ObservableObject {

    func publishSocialMedia(publishDate: Date, sourceRecord: String) {
                
        let jsonObject4: NSMutableArray = NSMutableArray()
        
        for item in socialMediaServices {
            
            let jsonObject: NSMutableDictionary = NSMutableDictionary()
            let jsonObject2: NSMutableDictionary = NSMutableDictionary()
            let tempArray: NSMutableArray = NSMutableArray()

            tempArray.add(sourceRecord)
            
            jsonObject.setValue(tempArray, forKey: "EditSchedule")
            jsonObject.setValue(item, forKey: "ServiceName")
            jsonObject.setValue(publishDate.formatAirTableDateTimeToString, forKey: "PublishDate")
            
            jsonObject2.setValue(jsonObject, forKey: "fields")
            
            jsonObject4.add(jsonObject2)
        }

        let jsonObject3: NSMutableDictionary = NSMutableDictionary()
        
        jsonObject3.setValue(jsonObject4, forKey: "records")
        
        let jsonData: Data

        do {
            jsonData = try JSONSerialization.data(withJSONObject: jsonObject3, options: JSONSerialization.WritingOptions()) as Data
//                    let jsonString = NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue)! as String
//    
//                    print("Garry String = \(jsonString)")

             let urlString = "\(airtableDatabase)/\(publishTable)"

             let requestURL = URL(string: urlString)

             var urlRequest = URLRequest(url: requestURL!)

             urlRequest.httpMethod = "POST"
             urlRequest.addValue("Bearer \(secretKey)", forHTTPHeaderField: "Authorization")
             urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
             urlRequest.httpBody = jsonData

             let sem = DispatchSemaphore(value: 0)

             let session = URLSession.shared
             let task = session.dataTask(with: urlRequest) {
                 (data, response, error) -> Void in

                 let httpResponse = response as! HTTPURLResponse
                 let statusCode = httpResponse.statusCode

                 if (statusCode == 200) {
//                     let json = try? JSON(data: data!)
//
//                     for record in json!["records"] {
//                        self.recordID = record.1["id"].string!
//                    }

                    sem.signal()
                 } else  {
                     print("Failed to connect")
                     print("statusCode = \(statusCode)")
                     print("Error : \(error!.localizedDescription)")
                     sem.signal()
                 }
             }
             task.resume()

             sem.wait()
            } catch _ {
                print ("JSON Failure")
            }
    }
    
    func publishPodcast(publishDate: Date, sourceRecord: String) {
                        
        let jsonObject4: NSMutableArray = NSMutableArray()

        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        let jsonObject2: NSMutableDictionary = NSMutableDictionary()
        let tempArray: NSMutableArray = NSMutableArray()

        tempArray.add(sourceRecord)
        
        jsonObject.setValue(tempArray, forKey: "EditSchedule")
        jsonObject.setValue(podcastSM, forKey: "ServiceName")
        jsonObject.setValue(publishDate.formatAirTableDateTimeToString, forKey: "PublishDate")
        
        jsonObject2.setValue(jsonObject, forKey: "fields")
        
        jsonObject4.add(jsonObject2)

        let jsonObject3: NSMutableDictionary = NSMutableDictionary()

        jsonObject3.setValue(jsonObject4, forKey: "records")

        let jsonData: Data

        do {
            jsonData = try JSONSerialization.data(withJSONObject: jsonObject3, options: JSONSerialization.WritingOptions()) as Data
//                    let jsonString = NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue)! as String
//
//                    print("Garry String = \(jsonString)")

             let urlString = "\(airtableDatabase)/\(publishTable)"

             let requestURL = URL(string: urlString)

             var urlRequest = URLRequest(url: requestURL!)

             urlRequest.httpMethod = "POST"
             urlRequest.addValue("Bearer \(secretKey)", forHTTPHeaderField: "Authorization")
             urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
             urlRequest.httpBody = jsonData

             let sem = DispatchSemaphore(value: 0)

             let session = URLSession.shared
             let task = session.dataTask(with: urlRequest) {
                 (data, response, error) -> Void in

                 let httpResponse = response as! HTTPURLResponse
                 let statusCode = httpResponse.statusCode

                 if (statusCode == 200) {
        //                     let json = try? JSON(data: data!)
        //
        //                     for record in json!["records"] {
        //                        self.recordID = record.1["id"].string!
        //                    }

                    sem.signal()
                 } else  {
                     print("Failed to connect")
                     print("statusCode = \(statusCode)")
                     print("Error : \(error!.localizedDescription)")
                     sem.signal()
                 }
             }
             task.resume()

             sem.wait()
            } catch _ {
                print ("JSON Failure")
            }

    }
}

