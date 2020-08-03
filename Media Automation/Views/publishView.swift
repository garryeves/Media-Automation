//
//  publishView.swift
//  Media Automation
//
//  Created by Garry Eves on 17/1/20.
//  Copyright © 2020 Garry Eves. All rights reserved.
//

import SwiftUI

struct publishView: View {
    @ObservedObject var storyItem: story
    var services: String
    @Binding var showChild: Bool
    
    @State var publishDate = Date()
    
    var body: some View {
        return VStack {
            HStack {
                Spacer()
                Button("Close") {
                    self.showChild.toggle()
                }
            }
            .padding()
            
            DatePicker("", selection: $publishDate)
                .padding()
            
            Button("Publish on \(publishDate.formatDateAndTimeString)") {
                let temp = socialMediaTargets()
                
                if self.services == "Social" {
                    temp.publishSocialMedia(publishDate: self.publishDate, sourceRecord: self.storyItem.recordID)
                } else if self.services == "Podcast" {
                    temp.publishPodcast(publishDate: self.publishDate, sourceRecord: self.storyItem.recordID)
                } else {
                    print("Incorrect publishing title.  Can not publish")
                }
                
                self.storyItem.Status = "Posted"
                self.storyItem.save()
                
            }
                .padding()
            .font(.title)
            
            Spacer()
        }
    }
}

