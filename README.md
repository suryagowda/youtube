

# YouTube Shorts Clone

This is a Flutter application that replicates the functionality of YouTube Shorts. It allows users to browse and play short videos.

## Installation

1. Ensure that you have Flutter SDK installed. If not, follow the official Flutter installation guide: [Flutter Installation](https://flutter.dev/docs/get-started/install)

2. Clone the repository:
   ```bash
   git clone https://github.com/suryagowda/youtube.git
   
3. Navigate to the project directory:
   ```bash
   cd your-repo
   
4. Fetch the project dependencies:
   ```bash
   flutter pub get
   
## Running the App

1. Connect a physical device or start an emulator, and then run the app using the following command:
   ```bash
   flutter run
## Project code Structure :
```
├── lib/
│ ├── main.dart
│ ├── api/
│ │ └── api_service.dart
│ └── screens/
│ ├── video_list_screen.dart
│ └── video_player_screen.dart
├── android/
│ └── ...
├── ios/
│ └── ...
├── assets/
│ └── ...
├── test/
│ └── ...
├── pubspec.yaml
└── README.md


```
## Features:

* Browse and play short videos
* Infinite scrolling to load more videos
* Smooth video playback with play/pause functionality
* Video thumbnail preview

## Major Widgets Used:

* MaterialApp: Provides the app's theme and navigation structure.
* ListView.builder: Renders the video list and supports infinite scrolling.
* VideoPlayer: Displays the video content and handles playback.
* PageView: Enables swiping between videos in the VideoPlayerScreen.

## demo :

https://github.com/suryagowda/youtube/assets/73325552/82043151-069e-4287-8cbb-8cb06eb098c0

