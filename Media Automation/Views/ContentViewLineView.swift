//
//  ContentViewLineView.swift
//  Media Automation
//
//  Created by Garry Eves on 17/1/20.
//  Copyright © 2020 Garry Eves. All rights reserved.
//

import SwiftUI

struct ContentViewLineView: View {
    
    @ObservedObject var item: story
    
    @State var showCourseDetails = false
    @State var showEnrichDetails = false
    @State var showPublished = false
    @State var publishedType = ""
    
    
    var body: some View {
      return VStack {
            Text(item.Story)
               .padding()
                .font(.headline)
           
            HStack {
                Text("\(item.MediaType) : ")
                Text(item.PostType)
                
                Spacer()
                
                Text("Status : ")
                Text(item.Status)
           }
            .padding()
        
        Text("Schedule date : \(item.DateScheduled.formatDateToString)")
            .padding()
        
        Spacer()
        
        Text("")
        .sheet(isPresented: self.$showEnrichDetails, onDismiss: { self.showEnrichDetails = false }) {
            enrichDataView(storyItem: self.item, showChild: self.$showEnrichDetails) }
        
        Text("")
        .sheet(isPresented: self.$showCourseDetails, onDismiss: { self.showCourseDetails = false }) {
            StoryView(storyItem: self.item, showChild: self.$showCourseDetails) }
        
        Text("")
        .sheet(isPresented: self.$showPublished, onDismiss: { self.showPublished = false }) {
            publishView(storyItem: self.item, services: self.publishedType, showChild: self.$showPublished) }
       }
       .contextMenu {
            VStack {
                Button("Details") {
                    self.showCourseDetails = true
                }
            
                if item.Status == "Posted" || item.Status == "Ready To Record" {
                    Button("Media Hosting Details") {
                        self.showEnrichDetails = true
                    }
                }
            
                if item.Status == "Ready To Start" {
                    Button("Start A Post") {
                        self.item.createOmniFocusTasks()
                        self.item.Status = "Drafting"
                        self.item.save()
                    }
                }
            
                if item.YoutubeLink != "" && item.VideoText != "" {
                    Button("Publish To Social Media") {
                        self.publishedType = "Social"
                        self.showPublished = true
                    }
                }

                if item.PodcastURL != "" && item.PodcastText != "" {
                    Button("Publish Podcast") {
                        self.publishedType = "Podcast"
                        self.showPublished = true
                    }
                }
            }
        }
    }
}
