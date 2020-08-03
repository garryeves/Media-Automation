//
//  automationGeneral.swift
//  Media Automation
//
//  Created by Garry Eves on 15/1/20.
//  Copyright © 2020 Garry Eves. All rights reserved.
//

import Foundation

let airtableDatabase = "https://api.airtable.com/v0/appMUcrerFMVdJbSi"
let secretKey = "keyTuRCceCsEU0EmX"

let scheduleTable = "EditSchedule"
let publishTable = "Published"

let mediaTypes = ["Video", "Podcast", "Blog Post"]
let videoTypeArray = ["Business Tips", "Tech Tips"]

let viewTypeAll = "All"
let viewTypeReadyToStart = "Ready To Start"
let viewTypeDrafting = "Drafting"
let viewTypeNoYoutube = "No Youtube"
let viewTypeNoPodcast = "No Podcast"
let viewTypeReadyToPost = "Ready To Record"
let viewTypePosted = "Posted"

let viewTypes = [viewTypeAll, viewTypeReadyToStart, viewTypeDrafting, viewTypeNoYoutube, viewTypeNoPodcast, viewTypeReadyToPost, viewTypePosted]
