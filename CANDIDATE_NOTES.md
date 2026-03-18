# Candidate Notes - Kevin Nguyen

## Acceptance Criteria

The criteria that I focused on was core functionality of the app as without the core features and ease of use for the user then more advanced features would fail to run correctly and fall by the wayside. I focused on these specifically. 

- App shows a timeline/list of sleep entries with key summary information
- User can create a new journal entry with sleep quality, mood, notes, and optional tags.
- User can search and filter entries.
- User can open an entry detail view.
- App persists data locally and supports offline usage.
- Weather fetch can be attached to an entry (current location + fallback behavior).
- Weather/network failures have clear retry behavior.

This subset of criteria is what I saw as most important since these are features and aspects of the app that the user would be interacting with on a daily basis. Therefore, it is of utmost importance that these features should work as intended. While I might be sacrifice the benefits that unit tests and UI tests would provide for this app, without a working UI/UX there would be no place for these tests to take place in the first place. I also chose to forego SwiftLint integration as it was a tool I am not familiar with yet and decided against it for the sake of overall stability.

## Defects and Tech Debt

Within this app I notice a couple glaring issues that I put on a high priority which needed fixing. Those included:

- Search behavior defects and edge cases
- Unsafe force unwraps / crash-prone code paths
- Error handling and user messaging gaps
- UI update inefficiencies and readability issues

These were the main focus of my efforts when it came to fixing defects as this threatened liveliness of the app if any of these errors were to happen. 

## Bonus

I implemented the following bonus features for the user: 

1. Add a MapKit context for journal location with clustering support
4. Add the ability to attach a photo to a journal entry

## Additional Questions

## 1. Dependencies and why I used them

### External / package dependencies 
- Charts
Used in SleepTrendsView to render the 7-day sleep bar chart since it provided a clean native charting API and was much faster to build a readable trends dashboard than building a custom chart from scratch

### Apple frameworks / system dependencies
- SwiftUI
I used SwiftUI where I would make forms and data summaries as it was easier to build and update

- UIKit
This was used because it made list screen, search, sharing, and moving between screens easier to build

- Foundation
I used it because it provides a base layer of functionality for data storage, persistence, and networking

- CoreLocation
I used this because it allowed an entry to include current location data and it could support weather lookup as well

- MapKit
I used it to store readable location context instead of only raw latitude/longitude

- PhotosUI
This was used because it allowed the user to optionally attach a photo to a sleep entry

### API dependency
- National Weather Service API
This was used so entries can optionally capture current weather context without requiring a custom backend

## 2. Reused code/snippets and sources

I had reused some code from a previous project of mine last semester in which me and a group mate built an iOS app that utilized PhotosUI and MapKit for photo uploads and location fetching. I used a similar logic for the implementation of MapKit into this file but required changes as I wanted to have it automatically fetch the location versus manually input the location.

I instead reused the button logic and behavior when I implemented location search and reused the photo attachment code from that project in this one to attach a photo to the sleep journal entry. Here is the link to the previous project: https://github.com/GinoGr/Reclaim-Lost-and-Found

I also relied on many outside sources to gain an understanding of the codebase in areas that I was not fully familiar with or had not worked on in some time. Here is the list of sources:

- https://stackoverflow.com/questions/43652830/how-store-json-response-and-save-into-json-file
- https://developer.apple.com/documentation/mapkit/mkaddressrepresentations
- https://developer.apple.com/documentation/foundation
- https://developer.apple.com/documentation/uikit/uilabel
- https://developer.apple.com/documentation/corelocation/cllocationmanager
- https://developer.apple.com/documentation/uikit/view-controllers
- https://developer.apple.com/documentation/charts/chart

## 3. What to review closely

The code I would like reviewed most closely is the code that I supplemented and strengthened on when it came to entry creation and expanded features specifically these files: 

- SleepEntryFormView where I implemented location and photo capabilities
- SleepDetailViewController where I implemented a new view structure and updated consistency
- SleepJournalListViewController and SleepListViewModel where I updated the search functionality and ease of readability for the user

Why:
- This is where most of the app's real behavior is, in collecting user input and allowing a smooth experience for the user to track and journal their sleep albeit able to search through their past entries
- These areas represent the parts of the project where I made the most substantial improvements in expanding core functionality, improving consistency between screens, and making the app easier for users to interact with.
- These changes added practical features that would be useful to people in their everyday lives by making the barrier of entry usage low with simplicity in search or ease of use in form entry for the user

## 4. Further Continuation

My next improvements would be:

1. Full UI Overall to declutter and spread out information and change the overall look to a more appealing scheme versus the simple scheme right now
2. Additional charts comparing sleep quality vs sleep hours
3. The ability to save favorite tags or routines
4. Sleep goal settings like a track that rewards streaks of healthy sleep habits
5. A system of sleep score that is based on quality, hours, and consistency of sleep
6. The ability to add voice notes to journal entries in the event the user does not want to type
7. Implementation of the Apple WeatherKit to replace weather.gov API

## 5. Additional Information

- This app was built with no usage of third-party libraries as I wanted to keep it close as possible to native iOS

## 6. Usage of AI

I used AI as a debugging assistant, code reviewer, and general Swift/iOS learning tool during development and while working through fixes. 

AI was used to explain framework behavior, debug implementation problems, and review and improve my overall code quality.

Prompts that were used: 
- "Explain how UISearchController behaves inside a UITableViewController"
- "Explain how CoreLocation permission flow works in an iOS app"
- "How does reverse geocoding work with MapKit and CLLocation?"
- "Help me debug why my search bar is not filtering entries correctly even though I have checked for case sensitivity"
- "review this implementation for edge cases such as nil state, canceled photo selection, denied location permission, and empty search text"
- "Identify the most fragile parts of this implementation from a maintainability standpoint and explain what should be refactored first"
- "Analyze whether this search implementation is readable and testable and suggest how to simplify it without reducing functionality"

Overall, AI was used to investigate issues, explain APIs/behaviors, and suggest fixes/refactors.