# tsanders-rh.github.io

Personal blog on migration automation, AI-powered DevOps, and Konveyor tooling.

**Live at:** https://tsanders-rh.github.io (once deployed)

## Quick Start

### 1. Create GitHub Repository

1. Go to https://github.com/new
2. Repository name: **tsanders-rh.github.io** (must match your GitHub username)
3. Make it **Public**
4. Do NOT initialize with README (we already have one)
5. Click "Create repository"

### 2. Push This Code

```bash
cd /Users/tsanders/Workspace/tsanders-rh.github.io

# Add remote
git remote add origin https://github.com/tsanders-rh/tsanders-rh.github.io.git

# Add all files
git add .
git commit -m "Initial blog setup with first post"

# Push to GitHub
git branch -M main
git push -u origin main
```

### 3. Enable GitHub Pages

1. Go to your repo: https://github.com/tsanders-rh/tsanders-rh.github.io
2. Click **Settings** → **Pages** (left sidebar)
3. Under "Build and deployment":
   - Source: **Deploy from a branch**
   - Branch: **main** / **(root)**
   - Click **Save**

**Your blog will be live in 1-2 minutes at:** https://tsanders-rh.github.io

## Local Development (Optional)

To preview locally before pushing:

```bash
# Install Ruby and Bundler (if needed)
# Mac: Ruby comes pre-installed, just install bundler
gem install bundler

# Install dependencies
bundle install

# Run local server
bundle exec jekyll serve

# Visit http://localhost:4000
```

## Writing New Posts

Create a new file in `_posts/` with the format:

```
_posts/YYYY-MM-DD-title-with-hyphens.md
```

**Example:**
```markdown
---
layout: post
title: "My Second Post"
date: 2025-01-20
categories: [migration, tools]
excerpt: "A short description for previews"
---

Your content here in Markdown...
```

## Adding Images

1. Create `assets/images/` directory
2. Add your images
3. Reference in posts:

```markdown
![Screenshot](/assets/images/screenshot.png)
```

## Project Structure

```
tsanders-rh.github.io/
├── _config.yml              # Site configuration
├── _posts/                  # Blog posts (YYYY-MM-DD-title.md)
├── assets/
│   └── images/             # Images for posts
├── about.md                # About page
├── index.md                # Home page
├── Gemfile                 # Ruby dependencies
└── README.md               # This file
```

## Adding a Custom Domain (Optional)

If you have your own domain:

1. Add a `CNAME` file to the repository:
   ```bash
   echo "blog.yourdomain.com" > CNAME
   git add CNAME
   git commit -m "Add custom domain"
   git push
   ```

2. Configure DNS at your domain registrar:
   - Add CNAME record: `blog` → `tsanders-rh.github.io`

3. In GitHub Settings → Pages → Custom domain:
   - Enter: `blog.yourdomain.com`
   - Click Save
   - Wait for DNS check to pass

## Upgrading the Theme (Optional)

The default `minima` theme is simple. For a more professional look, use **Minimal Mistakes**:

1. Update `_config.yml`:
   ```yaml
   # Comment out:
   # theme: minima

   # Add:
   remote_theme: "mmistakes/minimal-mistakes@4.24.0"
   ```

2. Update front matter in posts to use Minimal Mistakes layouts

3. See: https://mmistakes.github.io/minimal-mistakes/docs/quick-start-guide/

## Current Posts

- **2025-01-18:** AI-Powered Migration Rules: Turning Documentation into Konveyor Rulesets

## Next Steps

1. ✅ Create GitHub repository
2. ✅ Push code
3. ✅ Enable GitHub Pages
4. ⏳ Take screenshots for first post
5. ⏳ Add images to `assets/images/`
6. ⏳ Update first post with images
7. ⏳ Share on social media

## Resources

- **Jekyll Documentation:** https://jekyllrb.com/docs/
- **GitHub Pages Docs:** https://docs.github.com/en/pages
- **Minimal Mistakes Theme:** https://mmistakes.github.io/minimal-mistakes/
- **Markdown Guide:** https://www.markdownguide.org/

## License

Content is licensed under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/).
Code is licensed under [MIT License](https://opensource.org/licenses/MIT).
