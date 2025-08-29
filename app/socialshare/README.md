# SocialShare - GDG London

A modern Flutter web application for managing social media posts across multiple platforms for GDG London (Google Developer Group London). Built with Flutter Web, Material Design 3, and modern state management.

![SocialShare App](https://via.placeholder.com/800x400/4285F4/FFFFFF?text=SocialShare+App)

## 🚀 Features

### Core Functionality
- **📅 Post Calendar**: Interactive monthly calendar view with post scheduling
- **📝 Post Management**: Create, edit, and manage social media content
- **🎯 Multi-Platform Support**: LinkedIn, Twitter/X, Facebook, Instagram, YouTube
- **📱 Rich Content**: Support for text, images, videos, tags, and additional links
- **📋 Copy Functionality**: One-click copy post content to clipboard
- **🎨 Modern UI**: Material Design 3 with Google's brand colors

### Organization Integration
- **🏢 GDG London Header**: Prominent display with organization branding
- **🔗 Social Links**: Direct access to LinkedIn and Twitter profiles
- **🌐 Website Integration**: Links to official GDG London website

## 🖥️ Screens & Navigation

### 1. **Home Dashboard**
- Overview statistics (Upcoming Posts, Posted, Platforms)
- Quick action buttons for common tasks
- Welcome message and app description

### 2. **Calendar View**
- Monthly calendar with color-coded dates
- Green borders indicate dates with posts
- Click dates to view scheduled content
- Navigate between months easily

### 3. **Post Detail Screen**
- Comprehensive post information display
- Media preview (images/videos)
- Platform indicators with brand colors
- Tags and additional links
- Status management (Scheduled/Posted)

### 4. **Create Post Screen**
- Form-based post creation
- Required fields validation
- Platform multi-selection
- Tag management system
- Media URL inputs

## 🏗️ Architecture & Technology

### State Management
- **Provider Pattern**: Clean state management using the Provider package
- **ChangeNotifier**: Efficient UI updates and state synchronization

### Navigation
- **Go Router**: Modern routing solution with deep linking support
- **Navigation Rail**: Desktop-optimized side navigation

### UI/UX
- **Material Design 3**: Latest Google design system
- **Responsive Design**: Optimized for all screen sizes
- **Custom Theme**: Google brand colors and typography

### Folder Structure
```
lib/
├── models/          # Data models (Post, Organization)
├── providers/       # State management (PostProvider)
├── screens/         # Main application screens
├── widgets/         # Reusable UI components
├── services/        # Business logic and data services
├── utils/           # Utilities, theme, and router configuration
└── repository/      # Data persistence layer (ready for future use)
```

## 📊 Data Models

### Post Model
```dart
class Post {
  String id, title, content;
  DateTime date;
  bool isPosted;
  String postedBy;
  String? imageUrl, videoUrl;
  List<String> tags;
  List<SocialPlatform> platforms;
  List<String> additionalLinks;
  DateTime? postedAt;
  String? postUrl;
}
```

### Social Platforms
- **LinkedIn**: Professional networking
- **Twitter/X**: Microblogging and updates
- **Facebook**: Social media engagement
- **Instagram**: Visual content sharing
- **YouTube**: Video content platform

## 🛠️ Getting Started

### Prerequisites
- **Flutter SDK**: 3.2.3 or higher
- **Dart SDK**: Latest stable version
- **Web Browser**: Chrome, Firefox, Safari, or Edge
- **Firebase CLI**: For hosting and deployment
- **Node.js**: Required for Firebase tools

### Installation
1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd socialshare
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Install Firebase CLI and FlutterFire**
   ```bash
   npm install -g firebase-tools
   dart pub global activate flutterfire_cli
   ```

4. **Configure Firebase for your project**
   ```bash
   firebase login
   flutterfire configure --project=
   ```

5. **Run the application locally**
   ```bash
   flutter run -d chrome
   ```

6. **Access the app**
   - Open your browser and navigate to `http://localhost:8080`
   - The app will automatically reload when you make changes

## 📦 Dependencies

### Core Packages
- **`provider`**: State management solution
- **`go_router`**: Navigation and routing
- **`intl`**: Internationalization and date formatting
- **`url_launcher`**: Opening external URLs

### UI & Media
- **`flutter_svg`**: SVG icon support
- **`image_picker`**: Image selection functionality
- **`file_picker`**: File selection capabilities

### Firebase Integration
- **`firebase_core`**: Core Firebase functionality
- **`firebase_analytics`**: Analytics and user behavior tracking
- **`firebase_hosting`**: Web hosting and deployment

## 🎯 Usage Guide

### Creating Posts
1. Navigate to **Create Post** from the navigation rail
2. Fill in required fields:
   - **Title**: Post headline
   - **Content**: Main post text
   - **Date**: Scheduled posting date
   - **Posted By**: Author/team name
   - **Platforms**: Select target social media platforms
3. Add optional elements:
   - **Media URLs**: Images or videos
   - **Tags**: Categorization labels
   - **Additional Links**: Related URLs
4. Click **Create Post** to save

### Managing Posts
1. **View Calendar**: See all scheduled and posted content
2. **Post Details**: Click on posts for comprehensive information
3. **Status Updates**: Toggle between Scheduled and Posted
4. **Content Copy**: Use copy icon to copy post content
5. **Edit/Delete**: Manage existing posts

### Calendar Navigation
- **Month View**: Navigate between months with arrow buttons
- **Date Selection**: Click dates to view associated posts
- **Visual Indicators**: Green borders show dates with content
- **Post Preview**: Right panel displays posts for selected dates

## 🔧 Development

### Firebase Configuration
The app is configured to use Firebase for hosting and analytics. The configuration files are automatically generated when you run `flutterfire configure`.

**Important Files:**
- `lib/firebase_options.dart` - Firebase configuration options
- `.firebaserc` - Firebase project configuration
- `firebase.json` - Firebase hosting and deployment settings

### Running Tests
```bash
flutter test
```

### Code Analysis
```bash
flutter analyze
```

### Building for Production
```bash
flutter build web
```

### Firebase Hosting Deployment
1. **Build the web app**
   ```bash
   flutter build web
   ```

2. **Deploy to Firebase Hosting**
   ```bash
   firebase deploy --only hosting
   ```

3. **Access your live app**
   - Your app will be available at the Firebase hosting URL
   - Check the Firebase console for your hosting URL

### Hot Reload
- Save any file to trigger automatic reload
- Use `r` in terminal for manual reload
- Use `R` for hot restart

## 🌟 Key Features in Detail

### Post Calendar System
- **Interactive Grid**: 7-column weekly layout
- **Month Navigation**: Easy switching between months
- **Visual Feedback**: Color-coded dates and selection states
- **Post Indicators**: Small dots show dates with content

### Multi-Platform Management
- **Platform Selection**: Multi-select chips for target platforms
- **Brand Colors**: Platform-specific color coding
- **Icon Integration**: Recognizable platform icons
- **Flexible Publishing**: Schedule for multiple platforms simultaneously

### Content Management
- **Rich Text Support**: Multi-line content with formatting
- **Media Integration**: Image and video URL support
- **Tag System**: Categorization and organization
- **Link Management**: Multiple additional links per post

## 🤝 Contributing

This is a demo application for GDG London. We welcome contributions and improvements:

1. **Fork the repository**
2. **Create a feature branch**
3. **Make your changes**
4. **Test thoroughly**
5. **Submit a pull request**

### Development Guidelines
- Follow Flutter best practices
- Maintain consistent code style
- Add tests for new features
- Update documentation as needed

## 📱 Platform Support

### Web
- **Chrome**: Full support (recommended)
- **Firefox**: Full support
- **Safari**: Full support
- **Edge**: Full support
- **Firebase Hosting**: Production deployment and hosting

### Future Platforms
- **Mobile**: iOS and Android support planned
- **Desktop**: Windows, macOS, and Linux applications
- **PWA**: Progressive Web App capabilities

## 🔮 Roadmap

### Phase 1 (Current)
- ✅ Basic post management
- ✅ Calendar view
- ✅ Multi-platform support
- ✅ Modern UI/UX
- ✅ Firebase hosting setup

### Phase 2 (Planned)
- 🔄 Analytics dashboard
- 🔄 Bulk post operations
- 🔄 Advanced scheduling
- 🔄 Team collaboration

### Phase 3 (Future)
- 📋 AI-powered content suggestions
- 📋 Social media API integration
- 📋 Performance analytics
- 📋 Mobile applications

## 📄 License

This project is for educational and demonstration purposes. Feel free to use, modify, and distribute according to your needs.

## 🏢 About GDG London

**Google Developer Group London** is a vibrant community of developers, designers, and tech enthusiasts in London who share knowledge and build amazing things together.

### Community Activities
- **Meetups**: Regular technical meetups and workshops
- **Events**: Google I/O Extended, DevFest, and more
- **Learning**: Hands-on workshops and skill development
- **Networking**: Connect with fellow developers and industry professionals

### Get Involved
- **LinkedIn**: [GDG London](https://www.linkedin.com/company/google-developers-london/)
- **Twitter/X**: [@gdg_london](https://x.com/gdg_london)
- **Website**: [gdg.community.dev/gdg-london/](https://gdg.community.dev/gdg-london/)
- **Events**: Check our calendar for upcoming meetups and workshops

## 🙏 Acknowledgments

- **Flutter Team**: For the amazing framework
- **Google**: For Material Design and developer tools
- **GDG Community**: For inspiration and support
- **Open Source Contributors**: For the packages that make this possible

---

**Built with ❤️ for the GDG London community**

*For questions, suggestions, or contributions, please reach out to our team or open an issue on this repository.*
