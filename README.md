# README.txt

## 📚 Project Overview
This is a Flutter-based project named `se_380_project`. The app includes several features such as book search, user registration, profile management, and integration with the Google Books API. It is structured to support multiple platforms, including Android, iOS, web, and desktop.

## 🔧 Requirements
- **Flutter SDK**: Version 3.24.5
- **Dart SDK**: Version 3.5.4
- **IDE**: Visual Studio Code, Android Studio, or any preferred Flutter-supported editor.

## 📁 Project Directory Structure
- **`lib/`**: Contains the main application code.
  - **`assets/`**: Stores static resources like images or fonts.
  - **`screens/`**: Includes all the Dart files for the different screens in the app, such as `home_screen.dart`, `profile_screen.dart`, and more.
  - **`main.dart`**: Entry point of the Flutter application.
- **`android/`, `ios/`, `macos/`, `windows/`, `web/`**: Platform-specific directories for building the app on respective platforms.
- **`test/`**: Contains unit and widget tests.

## 🚀 Setup Instructions
Follow these steps to set up and run the project on your local machine:

1. **Install Flutter**
   - Ensure Flutter SDK version 3.24.5 is installed on your machine.
   - You can download it from [Flutter's official website](https://flutter.dev/).

2. **Clone the Repository**
   - Clone this project from the repository or download it as a ZIP file and extract it.
   - Navigate to the project directory.

3. **Open the Project**
   - Open the project folder (`se_380_project`) in your preferred IDE (e.g., Visual Studio Code or Android Studio).

4. **Install Dependencies**
   - Run the following command in the terminal to fetch all dependencies:
     ```bash
     flutter pub get
     ```

5. **Run the Application**
   - Connect a device (physical or emulator) to your machine.
   - Use the following command to run the app:
     ```bash
     flutter run
     ```
   - Alternatively, use the **Run** button in your IDE.

6. **Testing** (Optional)
   - Run the following command to execute unit and widget tests:
     ```bash
     flutter test
     ```

## 🧭 Navigation (Step-by-Step Instructions)

### 🌟 Introduction Screens
When you open the app, you will see three introduction screens:
- These screens explain the main features of the app.
- Swipe through these screens to continue.

### 🔑 Login or Register
- After the introduction, you will go to the Login screen.
- If you already have an account, enter your email and password to log in.
- If you do not have an account, tap **Register** to create one:
  - Enter your email, password, and a username.
  - Tap **Register** to finish.

### 🎨 Choose Your Favorite Genres
- After logging in, you will see a screen to select your favorite book genres (e.g., Mystery, Fiction).
- Choose your genres to get personalized recommendations.

### 🏠 Home Page
On the Home Page, you will see:
- **📖 Book of the Day**: A highlighted book with details like its title, author, and cover.
- **🌟 Recommended Books**: Books based on your favorite genres.
- **🔥 Popular Books**: A list of trending books.
- You can also search for books by typing their title in the search bar.

### 📚 Book Details
- Tap on any book to see its details.
- On the Book Details page, you can:
  - Read more about the book (author, description, ratings).
  - Open the book’s PDF on Google.
  - Add the book to your favorites by tapping **Add to Favorites**.

### ❤️ Favorites Page
- Go to the Favorites Page to see all the books you have added as favorites.
- Tap on any book to see its details.
- You can remove a book from favorites if you no longer want it there.

### 📖 Library Page
On the Library Page, you can:
- Select a book from your favorites to track your reading progress.
- Enter:
  - How many pages you read.
  - How much time (in minutes) you spent reading.

### 📊 Analytics Page
The Analytics Page shows your reading progress and achievements:
- **📈 Weekly Reading Graph**: Shows how much you read daily.
- **🔥 Streaks**:
  - **🏆 Best Streak**: The longest streak of consecutive reading days.
  - **🌟 Current Streak**: Your ongoing reading streak.
- View trophies you earned based on your reading habits.
- Track how far you are in each book.

## ✨ Features Included
- **Splash Screen**: The app starts with a splash screen (`splash_screen.dart`).
- **Authentication**: Registration and login functionality (`register_screen.dart`, `login_screen.dart`).
- **Book Management**: Search, view, and manage favorite books (`book_search_screen.dart`, `favorites_screen.dart`, `library_screen.dart`).
- **Google Books API**: Integration for fetching book details (`google_books_service.dart`).
- **User Profile**: View and manage user information (`profile_screen.dart`).

## 📝 Notes
- If you encounter issues with dependencies or platform-specific builds, ensure that your Flutter and Dart versions match the requirements.
- For any platform-specific setup (e.g., iOS or Android), refer to the official Flutter documentation: https://docs.flutter.dev.

## 🎥 YouTube Demo
You can view a demo of the app on [YouTube](https://youtube.com/).



