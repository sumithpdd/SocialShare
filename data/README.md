# SocialShare Firestore Seeder

A comprehensive Node.js seeding script for populating Firestore database with GDG London SocialShare app data. This project provides structured data seeding for organizations, campaigns, team members, tags, platforms, and posts with **bidirectional sync** capabilities.

## 🏗️ Architecture

### Project Structure
```
├── data/                    # Seed data files
│   ├── organization.json    # GDG London organization data
│   ├── campaign.json        # Google I/O Extended 2025 campaign
│   ├── team_members.json    # GDG London team members
│   └── tags.json           # Content categorization tags
├── posts/                   # Social media posts (existing)
├── downloads/               # Downloaded data from Firestore
│   ├── organization.json    # Downloaded organization data
│   ├── campaigns.json       # Downloaded campaigns
│   ├── team_members.json    # Downloaded team members
│   ├── tags.json           # Downloaded tags
│   └── posts/              # Individual post files
├── models/                  # Flutter app data models
├── firestore_seeder.js      # Main seeding script
├── package.json            # Node.js dependencies
└── serviceAccountKey.example.json # Firebase service account template
```

### Technology Stack
- **Node.js**: Runtime environment
- **Firebase Admin SDK**: Firestore database operations
- **Batch Operations**: Efficient data insertion
- **JSON Data Files**: Structured seed data
- **Bidirectional Sync**: Upload and download capabilities

## 🚀 Quick Setup

### Prerequisites
- Node.js (v16 or higher)
- Firebase project with Firestore enabled
- Firebase Admin SDK service account key

### 1. Install Dependencies
```bash
npm install
```

### 2. Configure Firebase
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project (or create a new one)
3. Go to Project Settings > Service Accounts
4. Click "Generate new private key"
5. Download the JSON file and rename it to `serviceAccountKey.json`
6. Place it in the same directory as `firestore_seeder.js`

### 3. Update Configuration
Edit `firestore_seeder.js` and replace:
```javascript
databaseURL: 'https://your-project-id.firebaseio.com'
```
with your actual Firebase project URL.

### 4. Run Sync Operations
```bash
# Upload data to Firestore
npm run upload

# Download data from Firestore
npm run download
```

## 🔄 Sync Operations

### Upload (Seed) Data to Firestore
```bash
# Upload all data
npm run upload

# Upload specific collections
npm run seed:org          # Organizations
npm run seed:campaigns    # Campaigns
npm run seed:team         # Team Members
npm run seed:tags         # Tags
npm run seed:platforms    # Platforms
npm run seed:posts        # Posts
```

### Download Data from Firestore
```bash
# Download all data
npm run download

# Download specific collections
npm run download:org      # Organizations
npm run download:campaigns # Campaigns
npm run download:team     # Team Members
npm run download:tags     # Tags
npm run download:posts    # Posts
```

### Command Line Usage
```bash
# Direct command line usage
node firestore_seeder.js upload   # Upload data
node firestore_seeder.js download # Download data
node firestore_seeder.js          # Default: upload data
```

## 📊 What Gets Seeded

### Collections Created:
1. **organizations** - GDG London organization data
2. **campaigns** - Google I/O Extended 2025 campaign
3. **team_members** - GDG London team members
4. **tags** - Content categorization tags
5. **platforms** - Social media platform configurations
6. **posts** - All social media posts from JSON files

## 📊 Model Structure

### Organizations Collection

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| id | String | Yes | Unique identifier (gdg-london) |
| name | String | Yes | Organization name |
| description | String | Yes | Organization description |
| email | String | Yes | Contact email |
| linkedinUrl | String | Yes | LinkedIn profile URL |
| twitterUrl | String | Yes | Twitter/X profile URL |
| websiteUrl | String | Yes | Official website URL |
| logoUrl | String | No | Organization logo URL |
| location | String | Yes | Organization location |

### Campaigns Collection

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| id | String | Yes | Unique identifier |
| name | String | Yes | Campaign name |
| description | String | Yes | Campaign description |
| startDate | Timestamp | Yes | Campaign start date |
| endDate | Timestamp | No | Campaign end date |
| status | String | Yes | active/completed/draft/archived |
| tags | Array<String> | Yes | Associated tags |
| createdBy | String | Yes | Creator name |
| createdAt | Timestamp | Yes | Creation timestamp |
| updatedAt | Timestamp | Yes | Last update timestamp |
| postCount | Number | Yes | Number of posts in campaign |
| imageUrl | String | No | Campaign image URL |

### Team Members Collection

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| id | String | Yes | Unique identifier |
| name | String | Yes | Member full name |
| email | String | Yes | Member email address |
| role | String | Yes | Member role (Organizer) |
| avatarUrl | String | No | Profile picture URL |
| permissions | Array<String> | Yes | User permissions |
| isActive | Boolean | Yes | Account status |
| createdAt | Timestamp | Yes | Account creation date |
| updatedAt | Timestamp | Yes | Last update date |
| postCount | Number | Yes | Posts created by member |

### Tags Collection

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| id | String | Yes | Unique identifier |
| name | String | Yes | Tag display name |
| color | String | Yes | Tag color hex code |
| createdAt | Timestamp | Yes | Creation timestamp |
| updatedAt | Timestamp | Yes | Last update timestamp |
| usageCount | Number | Yes | Number of posts using tag |

### Platforms Collection

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| id | String | Yes | Platform identifier |
| name | String | Yes | Platform display name |
| color | String | Yes | Brand color hex code |
| icon | String | Yes | Icon identifier |
| description | String | Yes | Platform description |
| isActive | Boolean | Yes | Platform availability |

### Posts Collection

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| id | String | Yes | Unique post identifier |
| title | String | Yes | Post title |
| content | String | Yes | Post content |
| date | Timestamp | Yes | Scheduled/posted date |
| isPosted | Boolean | Yes | Post status |
| postedBy | String | Yes | Author name |
| imageUrl | String | No | Image URL |
| videoUrl | String | No | Video URL |
| tags | Array<String> | Yes | Associated tags |
| platforms | Array<String> | Yes | Target platforms |
| additionalLinks | Array<String> | Yes | Related links |
| postedAt | Timestamp | No | Actual posting time |
| postUrl | String | No | Published post URL |
| campaign | String | No | Associated campaign |
| mentions | Array<String> | Yes | Tagged users/organizations |

## 🔧 Usage

### Full Database Sync
```bash
# Upload all data to Firestore
npm run upload

# Download all data from Firestore
npm run download
```

### Individual Collection Sync
```bash
# Upload specific collections
npm run seed:org          # Organizations
npm run seed:campaigns    # Campaigns
npm run seed:team         # Team Members
npm run seed:tags         # Tags
npm run seed:platforms    # Platforms
npm run seed:posts        # Posts

# Download specific collections
npm run download:org      # Organizations
npm run download:campaigns # Campaigns
npm run download:team     # Team Members
npm run download:tags     # Tags
npm run download:posts    # Posts
```

### Customization
1. **Modify Seed Data**: Edit JSON files in the `data/` directory
2. **Add New Posts**: Create JSON files in the `posts/` directory
3. **Update Configuration**: Modify `firestore_seeder.js` for custom logic

## 🛠️ Customization

### Adding New Posts
1. Create a new JSON file in the `posts/` directory
2. Follow the existing structure
3. Run `npm run seed:posts` to add only the new posts

### Modifying Organization Data
Edit the `data/organization.json` file and run:
```bash
npm run seed:org
```

### Adding New Campaigns
Edit the `data/campaign.json` file and run:
```bash
npm run seed:campaigns
```

### Adding New Team Members
Edit the `data/team_members.json` file and run:
```bash
npm run seed:team
```

### Adding New Tags
Edit the `data/tags.json` file and run:
```bash
npm run seed:tags
```

### Adding New Platforms
Edit the `seedPlatforms()` function and run:
```bash
npm run seed:platforms
```

## 📋 Data Summary

| Collection | Count | Description |
|------------|-------|-------------|
| Organizations | 1 | GDG London organization |
| Campaigns | 1 | Google I/O Extended 2025 |
| Team Members | 6 | GDG London organizers |
| Tags | 20 | Content categorization |
| Platforms | 5 | Social media platforms |
| Posts | 10+ | Sample social media posts |

The seeder will create:
- **1 Organization**: GDG London with updated contact information
- **1 Campaign**: Google I/O Extended 2025 (Aug 15 - Sep 13, 2025)
- **6 Team Members**: Sumith, Renuka, Christos, Goran, Stefan, Mihaela
- **20 Tags**: Flutter, Google I/O, AI/ML, Workshop, Community, etc.
- **5 Social Platforms**: LinkedIn, Twitter, Facebook, Instagram, YouTube
- **10+ Posts**: Sample social media posts from the posts directory

## 🔒 Security

### Firestore Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow read access to all collections
    match /{document=**} {
      allow read: if true;
    }
    
    // Allow write access only to authenticated users
    match /posts/{postId} {
      allow write: if request.auth != null;
    }
    
    match /organizations/{orgId} {
      allow write: if request.auth != null;
    }
    
    match /campaigns/{campaignId} {
      allow write: if request.auth != null;
    }
    
    match /team_members/{memberId} {
      allow write: if request.auth != null;
    }
    
    match /tags/{tagId} {
      allow write: if request.auth != null;
    }
  }
}
```

### Service Account Security
- Store `serviceAccountKey.json` securely
- Never commit to version control
- Use environment variables in production

## 🚨 Troubleshooting

### Common Issues
1. **Service Account Key Missing**: Ensure `serviceAccountKey.json` exists
2. **Firebase Project URL**: Update with correct project ID
3. **Firestore Not Enabled**: Enable Firestore in Firebase Console
4. **Permission Errors**: Check service account permissions
5. **Data Directory Missing**: Ensure `data/` directory exists

### Debug Mode
```javascript
// Add to firestore_seeder.js for detailed logging
process.env.DEBUG = 'firebase-admin:*';
```

## 📈 Performance

- **Batch Operations**: Uses Firestore batch writes for efficiency
- **Date Conversion**: Automatic ISO string to Timestamp conversion
- **Idempotent**: Safe to run multiple times
- **Error Handling**: Comprehensive error logging and recovery
- **Bidirectional Sync**: Upload and download capabilities

## 🔄 Maintenance

### Updating Existing Data
```javascript
// Change batch.set to batch.update for existing documents
batch.update(docRef, data);
```

### Adding New Data
1. Create new JSON files in appropriate directories
2. Update seeder functions if needed
3. Run individual seeding commands

### Sync Workflow
1. **Upload**: `npm run upload` - Push local data to Firestore
2. **Download**: `npm run download` - Pull Firestore data to local files
3. **Edit**: Modify downloaded files in `downloads/` directory
4. **Re-upload**: Run upload again to sync changes

## 📈 Monitoring

After seeding, you can monitor your data in:
- [Firebase Console](https://console.firebase.google.com/) > Firestore
- [Firebase Analytics](https://console.firebase.google.com/) > Analytics

## 📝 Notes

- The script uses batch writes for better performance
- All dates are converted to Firestore Timestamps
- The script is idempotent - running it multiple times won't create duplicates
- Make sure to backup your data before running the seeder in production
- The data structure matches the Flutter app models exactly
- **DateTime Handling**: Proper conversion between ISO strings and Firestore Timestamps
- **Sync Capabilities**: Full bidirectional sync between local files and Firestore

## 🆘 Support

If you encounter issues:
1. Check the Firebase Console for error messages
2. Verify your service account permissions
3. Ensure all dependencies are installed
4. Check the Node.js version compatibility
5. Verify all data files exist in the `data/` directory

## 📄 License

MIT License - Feel free to use, modify, and distribute.

---

**Built with ❤️ for GDG London**
