# How to Upload These Wiki Pages

Since I cannot push directly to the GitHub wiki, please follow these steps to manually upload the pages:

## Option 1: Manual Copy-Paste (Recommended)

1. Go to https://github.com/shadowdevnotreal/universal-docker/wiki

2. For each `.md` file in this directory, create a corresponding wiki page:

   **Home.md** → Create/Edit the "Home" page
   - Click "Edit" on the Home page
   - Copy content from `wiki-pages/Home.md`
   - Paste and save

   **Architecture.md** → Create "Architecture" page
   - Click "New Page"
   - Title: "Architecture"
   - Copy content from `wiki-pages/Architecture.md`
   - Paste and save

   **Installation-Details.md** → Create "Installation-Details" page
   - Click "New Page"
   - Title: "Installation-Details"
   - Copy content from `wiki-pages/Installation-Details.md`
   - Paste and save

   **Security.md** → Create "Security" page
   - Click "New Page"
   - Title: "Security"
   - Copy content from `wiki-pages/Security.md`
   - Paste and save

   **Script-Specifications.md** → Create "Script-Specifications" page
   - Click "New Page"
   - Title: "Script-Specifications"
   - Copy content from `wiki-pages/Script-Specifications.md`
   - Paste and save

   **Troubleshooting.md** → Create "Troubleshooting" page
   - Click "New Page"
   - Title: "Troubleshooting"
   - Copy content from `wiki-pages/Troubleshooting.md`
   - Paste and save

   **Advanced-Configuration.md** → Create "Advanced-Configuration" page
   - Click "New Page"
   - Title: "Advanced-Configuration"
   - Copy content from `wiki-pages/Advanced-Configuration.md`
   - Paste and save

   **Contributing.md** → Create "Contributing" page
   - Click "New Page"
   - Title: "Contributing"
   - Copy content from `wiki-pages/Contributing.md`
   - Paste and save

   **API-Reference.md** → Create "API-Reference" page
   - Click "New Page"
   - Title: "API-Reference"
   - Copy content from `wiki-pages/API-Reference.md`
   - Paste and save

## Option 2: Using Git (If you have wiki access)

```bash
# Clone the wiki repository
git clone https://github.com/shadowdevnotreal/universal-docker.wiki.git

# Copy the pages
cp wiki-pages/*.md universal-docker.wiki/

# Push to wiki
cd universal-docker.wiki
git add .
git commit -m "Add comprehensive wiki pages"
git push origin master
```

## After Uploading

Once you've uploaded all the wiki pages, you can:
1. Delete this `wiki-pages` directory
2. Verify the wiki looks good at https://github.com/shadowdevnotreal/universal-docker/wiki

## Page Structure

The wiki has been organized as follows:
- **Home** - Main landing page with navigation
- **Architecture** - System design and flows
- **Installation-Details** - Platform-specific installation info
- **Security** - Security implementation details
- **Script-Specifications** - Error handling and code style
- **Troubleshooting** - Common issues and solutions
- **Advanced-Configuration** - Customization options
- **Contributing** - Development guidelines
- **API-Reference** - Function and variable documentation

All pages are interlinked for easy navigation.
