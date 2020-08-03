//
//  storyClass.swift
//  Media Automation
//
//  Created by Garry Eves on 15/1/20.
//  Copyright © 2020 Garry Eves. All rights reserved.
//

import Foundation
import SwiftyJSON
import SwiftUI

let defaultNoteText = "Hi, this is Garry from Next Actions\n\nJoin me now to explore this question and see how working on the right things can improve your results\n\nBREAK\n\nDo you have something that ????\n\nIf you do then put a comment below\n\nIf you liked this video then please hit the like button.\n\nDo you know anyone who would benefit from this video.\n\nWhy not share it with them now.\n\nIf you haven't already, hit the subscribe button to get new videos as I release them.\n\nTo summarise\n\nIf you’re struggling with w??? then give me a call\n\nIsn’t it time you got the results you deserve\n\nPlease reach out to me on 0415 591672\n\nI am based in Australia so please use the international dialling code +61 if calling from another Country\n\nYou can also email me on garry@nextactions.com.au\n\nor visit nextactions.com.au where you will find a link to book a free short introductory call\n\nDo you have any topics you’d like me to cover\n\nIf you do please drop a comment below and I’ll add to the list of upcoming videos\n\nDon't forget to like the video and subscribe to my channel so you get new videos as they come out\n\nI’ll talk to you again soon"

class stories: ObservableObject {
    private var fullStoryList: [story] = Array()
    private var processedStoryList: [story] = Array()
    
    init() {
        load()
    }
    
    func load()
    {
        fullStoryList.removeAll()
        
        let urlString = "\(airtableDatabase)/\(scheduleTable)"
        
        let requestURL = URL(string: urlString)
        var urlRequest = URLRequest(url: requestURL!)
        
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("Bearer \(secretKey)", forHTTPHeaderField: "Authorization")
        
        let sem = DispatchSemaphore(value: 0)
        
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
    
            if (statusCode == 200) {
                let json = try? JSON(data: data!)
                
                for record in json!["records"] {
                    let recordID = record.1["id"].string!
                    
                    var Story = ""
                    var MenuName = ""
                    var MediaType = ""
                    var Status = ""
                    var DateScheduled: Date?
                    var PostType = ""
                    var YoutubeLink = ""
                    var PodcastEpisode = ""
                    var PodcastDate: Date?
                    var PodcastURL = ""
                    var Notes = ""
                    var VideoText = ""
                    var NonVideoText = ""
                    var TwitterText = ""
                    var Thumbnail: Data?
                    var PodcastText = ""
                    var PodcastTextTwitter = ""
                    
                    var postedServices: [String] = Array()
                    var asanaCourse: [String] = Array()
                    var asanaStatus: [String] = Array()
                    
                    for fieldList in record.1["fields"] {
                        if fieldList.1.string != "" {
                            switch fieldList.0 {
                                case "Story":
                                    Story = fieldList.1.string!

                                case "MenuName":
                                    MenuName = fieldList.1.string!
                                
                                case "Type":
                                    MediaType = fieldList.1.string!
                                
                                case "Status":
                                    Status = fieldList.1.string!
                                
                                case "Date Scheduled":
                                    DateScheduled = fieldList.1.string!.formatAirTableStringToDate
                                
                                case "PostType":
                                    PostType = fieldList.1.string!
                                
                                case "YoutubeLink":
                                    YoutubeLink = fieldList.1.string!
                                
                                case "PodcastEpisode":
                                    PodcastEpisode = fieldList.1.string!
                                
                                case "Podcast Date":
                                    PodcastDate = fieldList.1.string!.formatAirTableStringToDate
                                
                                case "PodcastURL":
                                    PodcastURL = fieldList.1.string!
                                
                                case "PostedServices":
                                    for item in fieldList.1 {
                                        postedServices.append(item.1.string!)
                                    }
                                
                                case "Asana":
                                    for item in fieldList.1 {
                                        asanaCourse.append(item.1.string!)
                                    }
                                
                                case "Asana Status":
                                    for item in fieldList.1 {
                                        asanaStatus.append(item.1.string!)
                                    }
                                
                                case "Notes":
                                    Notes = fieldList.1.string!
                                
                                case "VideoText":
                                    VideoText = fieldList.1.string!
                                
                                case "NonVideoText":
                                    NonVideoText = fieldList.1.string!
                                
                                case "TwitterText":
                                    TwitterText = fieldList.1.string!
                                
                                case "Thumbnail":
                                    Thumbnail = nil
                                
                                case "PodcastText":
                                    PodcastText = fieldList.1.string!
                                
                                case "PodcastTextTwitter":
                                    PodcastTextTwitter = fieldList.1.string!
                                
                                default:
                                    print("scheduleclass - unknown item - record = \(recordID) - \(fieldList.0) - \(fieldList.1)")
                                
                            }
                        }
                    }
                    
                    let newEntry = story(newRecordID: recordID,
                                  newStory: Story,
                                  newMenuName: MenuName,
                                  newMediaType: MediaType,
                                  newStatus: Status,
                                  newDateScheduled: DateScheduled,
                                  newPostType: PostType,
                                  newYoutubeLink: YoutubeLink,
                                  newPodcastEpisode: PodcastEpisode,
                                  newPodcastDate: PodcastDate,
                                  newPodcastURL: PodcastURL,
                                  newPostedServices: postedServices,
                                  newAsana: asanaCourse,
                                  newAsanaStatus: asanaStatus,
                                  newNotes: Notes,
                                  newVideoText: VideoText,
                                  newNonVideoText: NonVideoText,
                                  newTwitterText: TwitterText,
                                  newThumbnail: Thumbnail,
                                  newPodcastText: PodcastText,
                                  newPodcastTextTwitter: PodcastTextTwitter)
                    
                    self.fullStoryList.append(newEntry)
                }
                
                sem.signal()
            } else  {
                print("Failed to connect")
                sem.signal()
            }
        }
        task.resume()
        
        sem.wait()
        
        fullStoryList.sort {
            return $0.DateScheduled < $1.DateScheduled
        }
        
        setFilter(viewTypeAll)
    }
    
    var storyList : [story] {
        get {
            return processedStoryList
        }
    }
    
    func setFilter(_ filter: String) {
        switch filter {
            case viewTypeDrafting :
                processedStoryList = fullStoryList.filter { $0.Status == "Drafted" || $0.Status == "Drafting" }
            
            case viewTypeNoPodcast:
                processedStoryList = fullStoryList.filter { $0.PodcastURL == "" && $0.Status == "Posted" }
            
            case viewTypeNoYoutube:
                processedStoryList = fullStoryList.filter { $0.YoutubeLink == "" && $0.Status == "Posted"}
            
            case viewTypeReadyToStart:
                processedStoryList = fullStoryList.filter { $0.Status == "Ready To Start" }
            
            case viewTypePosted:
                processedStoryList = fullStoryList.filter { $0.Status == "Posted"}
                
            case viewTypeReadyToPost:
                processedStoryList = fullStoryList.filter { $0.Status == "Ready To Record"}
            
            default:
                processedStoryList = fullStoryList
        }
    }
}

class story: NSObject, ObservableObject, Identifiable {
    var recordID: String = ""
    @Published var Story: String = ""
    var MenuName: String = ""
    var MediaType: String = "Video"
    @Published var Status: String = "Ready To Start"
    var DateScheduled = Date().add(.year, amount: 1)
    var PostType: String = ""
    @Published var YoutubeLink: String = ""
    var PodcastEpisode: String = ""
    var PodcastDate: Date?
    @Published var PodcastURL: String = ""
    var PostedServices: [String] = Array()
    var Asana: [String] = Array()
    var AsanaStatus: [String] = Array()
    @Published var Notes: String = defaultNoteText
    @Published var VideoText: String = ""
    var NonVideoText: String = ""
    var TwitterText: String = ""
    var Thumbnail: Data?
    var PodcastText: String = ""
    var PodcastTextTwitter: String = ""
    
    override init() {
        
    }
    
    init(newRecordID: String,
        newStory: String,
         newMenuName: String,
         newMediaType: String,
         newStatus: String,
         newDateScheduled: Date?,
         newPostType: String,
         newYoutubeLink: String,
         newPodcastEpisode: String,
         newPodcastDate: Date?,
         newPodcastURL: String,
         newPostedServices: [String],
         newAsana: [String],
         newAsanaStatus: [String],
         newNotes: String,
         newVideoText: String,
         newNonVideoText: String,
         newTwitterText: String,
         newThumbnail: Data?,
         newPodcastText: String,
         newPodcastTextTwitter: String) {
        
       // super.init()
        
        recordID = newRecordID
        Story = newStory
        MenuName = newMenuName
        MediaType = newMediaType
        Status = newStatus
        DateScheduled = newDateScheduled!
        PostType = newPostType
        YoutubeLink = newYoutubeLink
        PodcastEpisode = newPodcastEpisode
        PodcastDate = newPodcastDate
        PodcastURL = newPodcastURL
        PostedServices = newPostedServices
        Asana = newAsana
        AsanaStatus = newAsanaStatus
        Notes = newNotes
        VideoText = newVideoText
        NonVideoText = newNonVideoText
        TwitterText = newTwitterText
        Thumbnail = newThumbnail
        PodcastText = newPodcastText
        PodcastTextTwitter = newPodcastTextTwitter
    }
    
    func save() {
        if MenuName == "" {
            MenuName = Story
        }
       
        if recordID == "" {
             // this is a new record so we POST
            
            let jsonObject: NSMutableDictionary = NSMutableDictionary()

            if Story != "" {
                jsonObject.setValue(Story, forKey: "Story")
              
            }
            
            if MenuName != "" {
                jsonObject.setValue(MenuName, forKey: "MenuName")
            }
            
            if MediaType != "" {
                jsonObject.setValue(MediaType, forKey: "Type")
            }
            
            if Status != "" {
                jsonObject.setValue(Status, forKey: "Status")
            }
            
            if PostType != "" {
                jsonObject.setValue(PostType, forKey: "PostType")
            }
            
            if YoutubeLink != "" {
                jsonObject.setValue(YoutubeLink, forKey: "YoutubeLink")
            }
            
            if PodcastURL != "" {
                jsonObject.setValue(PodcastURL, forKey: "PodcastURL")
            }
            
            if Notes != "" {
                jsonObject.setValue(Notes, forKey: "Notes")
            }
            
            if VideoText != "" {
                jsonObject.setValue(VideoText, forKey: "VideoText")
            }
            
            if NonVideoText != "" {
                jsonObject.setValue(NonVideoText, forKey: "NonVideoText")
            }
            
            if TwitterText != "" {
                jsonObject.setValue(TwitterText, forKey: "TwitterText")
            }
            
            if PodcastText != "" {
                jsonObject.setValue(PodcastText, forKey: "PodcastText")
            }
            
            if PodcastEpisode != "" {
                jsonObject.setValue(PodcastEpisode, forKey: "PodcastEpisode")
            }
            
            if PodcastTextTwitter != "" {
                jsonObject.setValue(PodcastTextTwitter, forKey: "PodcastTextTwitter")
            }
            
            jsonObject.setValue(DateScheduled.formatDateToString, forKey: "Date Scheduled")

            if PodcastDate != nil {
                jsonObject.setValue(PodcastDate!.formatDateToString, forKey: "Podcast Date")
            }
            
            let jsonObject2: NSMutableDictionary = NSMutableDictionary()
            
            jsonObject2.setValue(jsonObject, forKey: "fields")
            
            let jsonObject4: NSMutableArray = NSMutableArray()
            
            jsonObject4.add(jsonObject2)
            
            let jsonObject3: NSMutableDictionary = NSMutableDictionary()
            
            jsonObject3.setValue(jsonObject4, forKey: "records")
            
            let jsonData: Data

            do {
                jsonData = try JSONSerialization.data(withJSONObject: jsonObject3, options: JSONSerialization.WritingOptions()) as Data
//                let jsonString = NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue)! as String
//
//                print("Garry String = \(jsonString)")
                
                 let urlString = "\(airtableDatabase)/\(scheduleTable)"
                 
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
                         let json = try? JSON(data: data!)
                    
                         for record in json!["records"] {
                            self.recordID = record.1["id"].string!
                        }
                       
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
            } else {
                    // this is a new record so we PATCH
                
                let jsonObject: NSMutableDictionary = NSMutableDictionary()

                if Story != "" {
                    jsonObject.setValue(Story, forKey: "Story")
                }
                
                if MenuName != "" {
                    jsonObject.setValue(MenuName, forKey: "MenuName")
                }
                
                if MediaType != "" {
                    jsonObject.setValue(MediaType, forKey: "Type")
                }
                
                if Status != "" {
                    jsonObject.setValue(Status, forKey: "Status")
                }
                
                if PostType != "" {
                    jsonObject.setValue(PostType, forKey: "PostType")
                }
                
                if YoutubeLink != "" {
                    jsonObject.setValue(YoutubeLink, forKey: "YoutubeLink")
                }
                
                if PodcastURL != "" {
                    jsonObject.setValue(PodcastURL, forKey: "PodcastURL")
                }
                
                if Notes != "" {
                    jsonObject.setValue(Notes, forKey: "Notes")
                }
                
                if VideoText != "" {
                    jsonObject.setValue(VideoText, forKey: "VideoText")
                }
                
                if NonVideoText != "" {
                    jsonObject.setValue(NonVideoText, forKey: "NonVideoText")
                }
                
                if TwitterText != "" {
                    jsonObject.setValue(TwitterText, forKey: "TwitterText")
                }
                
                if PodcastText != "" {
                    jsonObject.setValue(PodcastText, forKey: "PodcastText")
                }
                
                if PodcastEpisode != "" {
                    jsonObject.setValue(PodcastEpisode, forKey: "PodcastEpisode")
                }
                
                if PodcastTextTwitter != "" {
                    jsonObject.setValue(PodcastTextTwitter, forKey: "PodcastTextTwitter")
                }
                
                jsonObject.setValue(DateScheduled.formatDateToString, forKey: "Date Scheduled")

                if PodcastDate != nil {
                    jsonObject.setValue(PodcastDate!.formatDateToString, forKey: "Podcast Date")
                }
            
                let jsonObject2: NSMutableDictionary = NSMutableDictionary()
                
                jsonObject2.setValue(recordID, forKey: "id")
                jsonObject2.setValue(jsonObject, forKey: "fields")
                
                let jsonObject4: NSMutableArray = NSMutableArray()
                
                jsonObject4.add(jsonObject2)
                
                let jsonObject3: NSMutableDictionary = NSMutableDictionary()
                
                jsonObject3.setValue(jsonObject4, forKey: "records")
                
                let jsonData: Data

                do {
                    jsonData = try JSONSerialization.data(withJSONObject: jsonObject3, options: JSONSerialization.WritingOptions()) as Data
//                    let jsonString = NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue)! as String
//
//                    print("Garry2 String = \(jsonString)")
                    
                    let urlString = "\(airtableDatabase)/\(scheduleTable)"
                    
                    let requestURL = URL(string: urlString)
                    
                    var urlRequest = URLRequest(url: requestURL!)
                    
                    urlRequest.httpMethod = "PATCH"
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
                           sem.signal()
                        } else  {
                            print("Failed to connect")
                            print("statusCode = \(statusCode)")
                            if error !=  nil {
                                print("Error : \(error!.localizedDescription)")
                            }
                            
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
    
    func createOmniFocusTasks() {
        
        var actionString = "\(Story) @parallel(false) @autodone(true) @tags(No Actions) :"
        
        if MediaType == "Video" {
            actionString += "\n    - Script video @parallel(false) @autodone(false) @tags(Important, Urgent, Mac, Medium Energy)"
            actionString += "\n    - Review script @parallel(false) @autodone(false) @tags(Important, Urgent, Mac, Medium Energy)"
            actionString += "\n    - Film video @parallel(false) @autodone(false) @tags(Important, Urgent, Mac, Medium Energy)"
            actionString += "\n    - Add the music track @parallel(false) @autodone(false) @tags(Important, Urgent, Mac, Medium Energy)"
            actionString += "\n    - Edit video @parallel(false) @autodone(false) @tags(Important, Urgent, Mac, Medium Energy)"
            actionString += "\n    - Upload video to Youtube @parallel(false) @autodone(false) @tags(Important, Urgent, Mac, Medium Energy)"
            actionString += "\n    - In description out in links to other videos @parallel(false) @autodone(false) @tags(Important, Urgent, Mac, Medium Energy)"
            actionString += "\n    - Upload video and schedule in Facebook @parallel(false) @autodone(false) @tags(Important, Urgent, Mac, Medium Energy)"
            actionString += "\n    - Archive project in LumaFusion @parallel(false) @autodone(false) @tags(Important, Urgent, Mac, Medium Energy)"
            actionString += "\n    - Copy archive to backup drive @parallel(false) @autodone(false) @tags(Important, Urgent, Mac, Medium Energy)"
            actionString += "\n    - Schedule post in Youtube, Instagram, LinkedIn and Twitter @parallel(false) @autodone(false) @tags(Important, Urgent, Mac, Medium Energy)"
            actionString += "\n    - Post video and script to website @parallel(false) @autodone(false) @tags(Important, Urgent, Mac, Medium Energy)"
            actionString += "\n    - Cleanup LumaFusion and iPad file system @parallel(false) @autodone(false) @tags(Important, Urgent, Mac, Medium Energy)"
            actionString += "\n    - Cleanup Filmic Pro @parallel(false) @autodone(false) @tags(Important, Urgent, Mac, Medium Energy)"
            actionString += "\n    - Cleanup Mac filesystem @parallel(false) @autodone(false) @tags(Important, Urgent, Mac, Medium Energy)"
            actionString += "\n    - Check Facebook page and share to my timeline @parallel(false) @autodone(false) @tags(Important, Urgent, Mac, Medium Energy)"
            actionString += "\n    - Check LinkedIn page and share to my timeline @parallel(false) @autodone(false) @tags(Important, Urgent, Mac, Medium Energy)"
            actionString += "\n    - Check Twitter @parallel(false) @autodone(false) @tags(Important, Urgent, Mac, Medium Energy)"
            actionString += "\n    - Schedule Friday re-posts @parallel(false) @autodone(false) @tags(Important, Urgent, Mac, Medium Energy)"
        } else if MediaType != "Podcast" {
            actionString += "\n    - Draft blog post @parallel(false) @autodone(false) @tags(Important, Urgent, Mac, Medium Energy)"
            actionString += "\n    - Run blog post through Grammarly @parallel(false) @autodone(false) @tags(Important, Urgent, Mac, Medium Energy)"
            actionString += "\n    - Run blog post through Hemingway @parallel(false) @autodone(false) @tags(Important, Urgent, Mac, Medium Energy)"
            actionString += "\n    - Re-read blog post @parallel(false) @autodone(false) @tags(Important, Urgent, Mac, Medium Energy)"
            actionString += "\n    - Upload blog post to website @parallel(false) @autodone(false) @tags(Important, Urgent, Mac, Medium Energy)"
            actionString += "\n    - Load pictures to website and include in post @parallel(false) @autodone(false) @tags(Important, Urgent, Mac, Medium Energy)"
            actionString += "\n    - Set header and title formatting @parallel(false) @autodone(false) @tags(Important, Urgent, Mac, Medium Energy)"
            actionString += "\n    - Add in links to existing articles where it makes sense @parallel(false) @autodone(false) @tags(Important, Urgent, Mac, Medium Energy)"
            actionString += "\n    - Tweak blog post for Yoast SEO @parallel(false) @autodone(false) @tags(Important, Urgent, Mac, Medium Energy)"
            actionString += "\n    - Tweak blog post for Yoast readability @parallel(false) @autodone(false) @tags(Important, Urgent, Mac, Medium Energy)"
            actionString += "\n    - Re-read blog post @parallel(false) @autodone(false) @tags(Important, Urgent, Mac, Medium Energy)"
            actionString += "\n    - Publish blog post @parallel(false) @autodone(false) @tags(Important, Urgent, Mac, Medium Energy)"
            actionString += "\n    - Update existing posts to link to new post, where it makes sense @parallel(false) @autodone(false)@tags(Important, Urgent, Mac, Medium Energy)"
            actionString += "\n    - Check Medium post and add in tags @parallel(false) @autodone(false) @tags(Important, Urgent, Mac, Medium Energy)"
            actionString += "\n    - Check Facebook page and share to my timeline @parallel(false) @autodone(false) @tags(Important, Urgent, Mac, Medium Energy)"
            actionString += "\n    - Check LinkedIn page and share to my timeline @parallel(false) @autodone(false) @tags(Important, Urgent, Mac, Medium Energy)"
            actionString += "\n    - Check Twitter @parallel(false) @autodone(false) @tags(Important, Urgent, Mac, Medium Energy)"
        }
        
        if MediaType == "Video" || MediaType == "Podcast" {
            actionString += "\n\nCreate Podcast for \(Story) @parallel(false) @autodone(true) @tags(No Actions) :"

            actionString += "\n    - Edit podcast audio @parallel(false) @autodone(false) @tags(Important, Urgent, Mac, Medium Energy)"
            actionString += "\n    - Create podcast in Anchor @parallel(false) @autodone(false) @tags(Important, Urgent, Mac, Medium Energy)"
            actionString += "\n    - Schedule release of podcast @parallel(false) @autodone(false) @tags(Important, Urgent, Mac, Medium Energy)"
            actionString += "\n    - Create and schedule social media posts for podcast @parallel(false) @autodone(false) @tags(Important, Urgent, Mac, Medium Energy)"
            
        }
        
        let urlString = "omnifocus:///paste?target=/folder/Next%20Actions&content=\(actionString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)"
        print(urlString)
       let requestURL = URL(string: urlString)
       
       if UIApplication.shared.canOpenURL(requestURL!) {
           UIApplication.shared.open(requestURL!, options: [:], completionHandler: nil)
       }
    }
}
