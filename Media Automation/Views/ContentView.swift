//
//  ContentView.swift
//  Media Automation
//
//  Created by Garry Eves on 15/1/20.
//  Copyright © 2020 Garry Eves. All rights reserved.
//

import SwiftUI

class contentViewVariables: ObservableObject {
        
    var rememberedIntDisplayData = -1
    
    var displayDataType = viewTypeAll
}

struct ContentView: View {
    
    @ObservedObject var storyList = stories()
    @ObservedObject var workingVariables = contentViewVariables()
    
    @State var showCourseDetails = false
  
    @State var passedStory = story()
    
    @State var showModalDisplayData = pickerComms()
    @State var showPickerDisplayData = false

    
    var body: some View {
        
        if workingVariables.rememberedIntDisplayData > -1 {
            workingVariables.displayDataType = viewTypes[workingVariables.rememberedIntDisplayData]
            
            workingVariables.rememberedIntDisplayData = -1
        }

        storyList.setFilter(workingVariables.displayDataType)

        return VStack {
            HStack {
                Text("Data To Display")
                    .font(.title)
            
                Button(workingVariables.displayDataType) {
                    self.workingVariables.rememberedIntDisplayData = -1
                    self.showModalDisplayData.displayList.removeAll()
                      
                    for item in viewTypes {
                        self.showModalDisplayData.displayList.append(displayEntry(entryText: item))
                      }
                    
                      self.showPickerDisplayData = true
                }
                .font(.title)
                .sheet(isPresented: self.$showPickerDisplayData, onDismiss: { self.showPickerDisplayData = false }) {
                    pickerView(displayTitle: "Select Role", rememberedInt: self.$workingVariables.rememberedIntDisplayData, showPicker: self.$showPickerDisplayData, showModal: self.$showModalDisplayData)
                    }
            }
            .padding()
            
            List {
                ForEach (storyList.storyList, id: \.self) { item in
                    ContentViewLineView(item: item)
                }
            }
            .sheet(isPresented: self.$showCourseDetails, onDismiss: { self.showCourseDetails = false }) {
                StoryView(storyItem: self.passedStory, showChild: self.$showCourseDetails) }
            
            Button("Add New Item") {
                self.passedStory = story()
                self.showCourseDetails = true
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
