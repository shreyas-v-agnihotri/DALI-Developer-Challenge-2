# DALI Developer Challenge #2
An iOS app created for my application to Dartmouth's DALI Lab.

## Demo
[Click here to view the app in an iOS simulator](https://appetize.io/app/vpuyv5kr8ptvxu4fkmvykx04jm?device=iphonex&scale=75&orientation=portrait&osVersion=12.1&deviceColor=black)

## The Challenge
My goal was to create a dashboard of DALI Lab members with information about their backgrounds and projects.

>At DALI, we have over 50 students per term working on a variety of cool projects. Things can get pretty chaotic. It would help if we had an app or a site that displayed a DALI Dashboard! This dashboard could show active and past members, profiles, skillsets, and current projects for DALI Members. You should parse the JSON data http://mappy.dali.dartmouth.edu/members.json in your app and display at least some of it.

## Features
* Interactive map with markers on member hometowns (made with Apple Mapkit)
* Member listing with profile picture, name, and message preview
  * JSON data fetched live from github (using Alamofire and SwiftyJSON)
  * Pictures loaded and cached asynchronously (using Kingfisher)
* Search bar to filter by any info from profile
* Member detail view
  * Clickable link to open member website in-app
  * Member hometown converted from geo-coordinates
* Animated landing page with DALI logo and color scheme
* Progress bar to alert user of time-intensive operations
* Alert notification for failure to load data

## Languages and Skills Used
This app was built in Xcode using Swift. I only recently began teaching myself Swift, so I'm very proud that I was able to create a functioning multi-view application that parses and displays internet data.
