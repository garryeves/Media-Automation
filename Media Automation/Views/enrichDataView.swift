//
//  enrichDataView.swift
//  Media Automation
//
//  Created by Garry Eves on 16/1/20.
//  Copyright © 2020 Garry Eves. All rights reserved.
//

import SwiftUI

struct enrichDataView: View {
    @ObservedObject var storyItem: story
    @Binding var showChild: Bool
    
    @State var advertisingtext = "Do You want someone to ?????\n\nAre you struggling with ????"
    
    var body: some View {
        return VStack {
            HStack {
                Spacer()
                Button("Close") {
                    self.showChild.toggle()
                }
            }
            .padding()
            
            HStack {
                Text("Youtube Link")
                TextField("Youtube link", text: $storyItem.YoutubeLink)
            }
            .padding()
            
            HStack {
                Text("Podcast Link")
                TextField("Podcast link", text: $storyItem.PodcastURL)
            }
            .padding()
                                
            if self.storyItem.PodcastURL != "" && self.storyItem.PodcastText == "" {
                Button("Generate Podcast Text") {
                    self.storyItem.PodcastText = "\(self.storyItem.Story)\n\nThis weeks podcast on \(self.storyItem.Story) is now available for your listening pleasure.\n\nSubscribe to 'Next Actions For Business' in your podcatcher of choice.\n\nAlternatively you can find it on anchor.fm\n\n\(self.storyItem.PodcastURL)\n\nIsn’t it time to start getting the results you deserve!\n\nWhy not email Garry to see how he can help you with your business problems.  Drop him an email at garry@nextactions.com.au.\n\nAlternatively contact Garry on your social platform of choice.\n\nFaceBook - https://www.facebook.com/nextactions\nTwitter - https://twitter.com/garryeves\nLinkedIn - https://www.linkedin.com/company/next-actions\nInstagram - https://www.instagram.com/garryeves\n\nCheck out nextactions.com.au where you can book a free introductory call."

                    self.storyItem.PodcastTextTwitter = "\(self.storyItem.Story)\n\nThis weeks podcast on \(self.storyItem.Story) is now available.\n\nSubscribe to 'Next Actions For Business' in your podcatcher.\n\n\(self.storyItem.PodcastURL)."
                    
                    self.storyItem.save()
                }
            }
            
            if storyItem.YoutubeLink != "" {
                if storyItem.VideoText == "" {
                    
                    Text("Advertising Text")
                        .padding()
                    TextView(text: $advertisingtext)
                    .padding()
                    
                    Spacer()
                    
                    Button("Generate Advertisement Text") {
                        self.storyItem.VideoText = "\(self.storyItem.Story)\n\n\(self.advertisingtext)\n\nJoin me to talk about \(self.storyItem.Story).  See how it can help you deliver results.\n\nIsn’t it time to start getting the results you deserve!\n\nWhy not email Garry to see how he can help you with your business problems.  Drop him an email at garry@nextactions.com.au.\n\nAlternatively contact Garry on your social platform of choice.\n\nFaceBook - https://www.facebook.com/nextactions\n\nTwitter - https://twitter.com/garryeves\n\nLinkedIn - https://www.linkedin.com/company/next-actions\n\nInstagram - https://www.instagram.com/garryeves\n\nCheck out nextactions.com.au where you can book a free introductory call."
                        
                        self.storyItem.NonVideoText = "\(self.storyItem.Story)\n\n\(self.advertisingtext)\n\nJoin me to talk about \(self.storyItem.Story).  See how it can help you deliver results.\n\nCheck out the video at \(self.storyItem.YoutubeLink)\n\nIsn’t it time to start getting the results you deserve!\n\nWhy not email Garry to see how he can help you with your business problems.  Drop him an email at garry@nextactions.com.au.\n\nAlternatively contact Garry on your social platform of choice.\n\nFaceBook - https://www.facebook.com/nextactions\n\nTwitter - https://twitter.com/garryeves\n\nLinkedIn - https://www.linkedin.com/company/next-actions\n\nInstagram - https://www.instagram.com/garryeves\n\nCheck out nextactions.com.au where you can book a free introductory call."
                        
                        self.storyItem.TwitterText = "\(self.storyItem.Story)\n\nStart getting the results you deserve\n\nEmail Garry at garry@nextactions.com.au\n\n\(self.storyItem.YoutubeLink)."
                        
                        self.storyItem.save()
                        
                    }
                    .padding()
                } else {
                    VStack {
                        Text("Video Text")
                            .font(.headline)
                        
                        TextView(text: $storyItem.VideoText)
                        
                        Text("Non-Video Text")
                        .font(.headline)
                        
                        TextView(text: $storyItem.NonVideoText)
                        
                        Text("Twitter Text")
                        .font(.headline)
                        
                        TextView(text: $storyItem.TwitterText)
                        
                        Text("Podcast Text")
                        .font(.headline)
                        
                        TextView(text: $storyItem.PodcastText)
                        
                        Text("Podcast Text For Twitter")
                        .font(.headline)
                        
                        TextView(text: $storyItem.PodcastTextTwitter)
                    }
                    .padding()
                    
                    Spacer()
                    
                    Button("Save") {
                        self.storyItem.save()
                    }
                    .padding()
                }
            } else {
                Spacer()
            }
        }
    }
}
