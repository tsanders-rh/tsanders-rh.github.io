# 🚀 Deployment Guide - Get Your Blog Online in 5 Minutes

## Step 1: Create GitHub Repository (2 minutes)

1. **Go to GitHub:** https://github.com/new
2. **Repository settings:**
   - Repository name: `tsanders-rh.github.io` ⚠️ **Must exactly match your username**
   - Description: "Personal blog on migration automation and AI tooling"
   - Visibility: **Public** (required for free GitHub Pages)
   - ❌ Do NOT check "Initialize this repository with a README"
3. **Click "Create repository"**

## Step 2: Push Your Blog (1 minute)

```bash
# Navigate to your blog directory
cd /Users/tsanders/Workspace/tsanders-rh.github.io

# Add GitHub as remote
git remote add origin https://github.com/tsanders-rh/tsanders-rh.github.io.git

# Push to GitHub
git push -u origin main
```

**Expected output:**
```
Enumerating objects: 10, done.
Counting objects: 100% (10/10), done.
...
To https://github.com/tsanders-rh/tsanders-rh.github.io.git
 * [new branch]      main -> main
Branch 'main' set up to track remote branch 'main' from 'origin'.
```

## Step 3: Enable GitHub Pages (1 minute)

1. **Go to your repository:** https://github.com/tsanders-rh/tsanders-rh.github.io
2. **Click "Settings"** (top right, near the "⚙️" icon)
3. **Click "Pages"** in the left sidebar
4. **Under "Build and deployment":**
   - Source: Select **"Deploy from a branch"**
   - Branch: Select **"main"** and **"/ (root)"**
   - Click **"Save"**

You should see a message:
> "Your site is ready to be published at https://tsanders-rh.github.io/"

## Step 4: Wait for Deployment (1 minute)

GitHub Pages will automatically build and deploy your site.

**Check deployment status:**
1. Go to the "Actions" tab in your repository
2. You'll see a workflow called "pages build and deployment"
3. Wait for the green checkmark ✅

**First deployment takes:** ~1-2 minutes

## Step 5: Visit Your Blog! 🎉

**Your blog is now live at:** https://tsanders-rh.github.io

**What you'll see:**
- ✅ Home page with introduction
- ✅ Your first blog post about AI-Powered Migration Rules
- ✅ About page with your bio and projects

## Next Steps

### Add Screenshots to Your First Post

1. **Follow the demo script** to capture screenshots:
   ```bash
   # In analyzer-rule-generator repo
   cat blog-demo-script.md
   ```

2. **Save screenshots** to your blog:
   ```bash
   # Example: Copy screenshots
   cp screenshot-1-generating-rules.png /Users/tsanders/Workspace/tsanders-rh.github.io/assets/images/
   cp screenshot-2-rule-viewer.png /Users/tsanders/Workspace/tsanders-rh.github.io/assets/images/
   cp screenshot-3-test-data.png /Users/tsanders/Workspace/tsanders-rh.github.io/assets/images/
   ```

3. **Update the blog post** to include images:
   ```markdown
   ### Step 1: Generate Rules

   ![Rule Generation in Progress](/assets/images/screenshot-1-generating-rules.png)

   ### Step 2: Preview the Rules

   ![Rule Viewer](/assets/images/screenshot-2-rule-viewer.png)

   ### Step 3: Generated Test Data

   ![Test Data in VS Code](/assets/images/screenshot-3-test-data.png)
   ```

4. **Commit and push:**
   ```bash
   cd /Users/tsanders/Workspace/tsanders-rh.github.io
   git add assets/images/ _posts/
   git commit -m "Add screenshots to first blog post"
   git push
   ```

Changes appear in ~30 seconds!

### Write Your Second Post

```bash
cd /Users/tsanders/Workspace/tsanders-rh.github.io

# Create new post (use today's date)
cat > _posts/2025-01-25-my-second-post.md << 'EOF'
---
layout: post
title: "My Second Post Title"
date: 2025-01-25
categories: [migration, tools]
excerpt: "A brief description of what this post is about"
---

Your content here in Markdown...
EOF

# Push to publish
git add _posts/2025-01-25-my-second-post.md
git commit -m "Add second blog post"
git push
```

### Test Locally (Optional)

Preview changes before pushing:

```bash
# Install Jekyll (one time)
gem install bundler jekyll
bundle install

# Run local server
bundle exec jekyll serve

# Visit: http://localhost:4000
```

## Troubleshooting

### "Your site is having trouble building"

Check the Actions tab for error details. Common issues:
- **YAML syntax error** in `_config.yml` - check indentation
- **Invalid date format** in post filename - must be `YYYY-MM-DD`
- **Missing front matter** in post - must have `---` delimiters

### Site not updating after push

- Wait 30-60 seconds for GitHub to rebuild
- Hard refresh browser: `Cmd+Shift+R` (Mac) or `Ctrl+Shift+R` (Windows)
- Check Actions tab for build status

### Want to use a custom domain?

1. Add CNAME file:
   ```bash
   echo "blog.yourdomain.com" > CNAME
   git add CNAME
   git commit -m "Add custom domain"
   git push
   ```

2. Configure DNS (at your domain registrar):
   ```
   Type: CNAME
   Name: blog
   Value: tsanders-rh.github.io
   ```

3. In GitHub Settings → Pages → Custom domain:
   - Enter: `blog.yourdomain.com`
   - Wait for DNS check
   - Enable "Enforce HTTPS"

## Sharing Your Blog

### Social Media

**LinkedIn:**
```
Just launched my blog on migration automation and AI tooling! 🚀

First post: How we're using LLMs to transform migration guides into Konveyor analyzer rules.

Check it out: https://tsanders-rh.github.io

#Migration #AI #DevOps #Konveyor
```

**Twitter/X:**
```
New blog post: AI-Powered Migration Rules 🤖

Transforming migration guides into static analysis rules using LLMs.

Read more: https://tsanders-rh.github.io

#konveyor #migration #ai
```

### Dev.to Cross-Post

1. Go to https://dev.to/new
2. Paste your Markdown content
3. Add at the top:
   ```yaml
   canonical_url: https://tsanders-rh.github.io/2025/01/18/ai-powered-migration-rules/
   ```
4. Add tags: `#konveyor` `#migration` `#ai` `#java`

## Success! 🎉

Your blog is now live and you can:
- ✅ Write posts in Markdown
- ✅ Publish instantly with `git push`
- ✅ Share your knowledge with the community
- ✅ Build your personal brand

**Questions?** Check the README.md or Jekyll docs: https://jekyllrb.com/docs/

Happy blogging! 📝
