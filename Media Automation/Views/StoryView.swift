//
//  StoryView.swift
//  Media Automation
//
//  Created by Garry Eves on 15/1/20.
//  Copyright © 2020 Garry Eves. All rights reserved.
//

import SwiftUI

class StoryViewVariables: ObservableObject {
    
    var rememberedIntPostType = -1
    var rememberedIntMediaType = -1
}

struct StoryView: View {
    
    @ObservedObject var storyItem: story
    @Binding var showChild: Bool
    
    @ObservedObject var workingVariables = StoryViewVariables()
    
    @State var showModalPostType = pickerComms()
    @State var showPickerPostType = false
    
    @State var showModalMediaType = pickerComms()
    @State var showPickerMediaType = false
    
    var body: some View {
        var postTypeMessage = "Select Post Type"

        if workingVariables.rememberedIntPostType > -1 {
            storyItem.PostType = videoTypeArray[workingVariables.rememberedIntPostType]
            workingVariables.rememberedIntPostType = -1
        }
        
        if workingVariables.rememberedIntMediaType > -1 {
            storyItem.MediaType = mediaTypes[workingVariables.rememberedIntMediaType]
            workingVariables.rememberedIntMediaType = -1
        }
        
        if storyItem.PostType != "" {
            postTypeMessage = storyItem.PostType
        }
        
        var words: [Substring] = []
        storyItem.Notes.enumerateSubstrings(in: storyItem.Notes.startIndex..., options: .byWords) { _, range, _, _ in
            words.append(self.storyItem.Notes[range])
        }
        
        return VStack {
            HStack {
                Spacer()
                Button("Close") {
                    self.showChild.toggle()
                }
            }
            .padding()
            
            TextField("Name", text: $storyItem.Story)
                .padding()
            
            if storyItem.Story == "" {
                Spacer()
            } else {
                HStack {
                    Button(storyItem.MediaType) {
                        self.workingVariables.rememberedIntMediaType = -1
                        self.showModalMediaType.displayList.removeAll()
                          
                        for item in mediaTypes {
                            self.showModalMediaType.displayList.append(displayEntry(entryText: item))
                          }
                        
                          self.showPickerMediaType = true
                    }
                    .sheet(isPresented: self.$showPickerMediaType, onDismiss: { self.showPickerMediaType = false }) {
                        pickerView(displayTitle: "Select Media Type", rememberedInt: self.$workingVariables.rememberedIntMediaType, showPicker: self.$showPickerMediaType, showModal: self.$showModalMediaType)
                        }
                    
                    Spacer()
                    
                    Button(postTypeMessage) {
                        self.workingVariables.rememberedIntPostType = -1
                        self.showModalPostType.displayList.removeAll()
                          
                        for item in videoTypeArray {
                            self.showModalPostType.displayList.append(displayEntry(entryText: item))
                          }
                        
                          self.showPickerPostType = true
                    }
                    .sheet(isPresented: self.$showPickerPostType, onDismiss: { self.showPickerPostType = false }) {
                        pickerView(displayTitle: "Select Post Type", rememberedInt: self.$workingVariables.rememberedIntPostType, showPicker: self.$showPickerPostType, showModal: self.$showModalPostType)
                        }
                }
                .padding()
     
                HStack {
                    Text(storyItem.Status)
                    Spacer()
                    Text(storyItem.DateScheduled.formatDateToString)
                }
                .padding()
                
                Text(storyItem.YoutubeLink)
                .padding()

                Text(storyItem.PodcastURL)
                .padding()
                
                Text("Script is \(words.count) words")
                TextView(text: $storyItem.Notes)
                .padding()
                
                Button("Ready To Record") {
                    self.storyItem.Status = "Ready To Record"
                    self.storyItem.save()
                }
                .padding()
                
                Spacer()
                
                if storyItem.MediaType != "" && storyItem.PostType != "" {
                    Button("Save") {
                        self.storyItem.save()
                    }
                    .padding()
                }
            }
        }
    }
}

//struct StoryView_Previews: PreviewProvider {
//    static var previews: some View {
//        StoryView()
//    }
//}
