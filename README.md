# Portfolio Website

Flutter portfolio for **Mustafa Q. Yassin**.

**Live site:** https://m.dev97.github.io

## Social
- GitHub: https://github.com/m.dev97
- LinkedIn: https://www.linkedin.com/in/m.dev97
- Instagram: https://www.instagram.com/m.dev97

## Deploy (GitHub Pages)

1. Create a public repository named **`m.dev97.github.io`** under the GitHub account **`m.dev97`**.
2. Push this project to the `main` branch.
3. Repo → **Settings** → **Pages** → Source: **GitHub Actions**.
4. The workflow `.github/workflows/deploy.yml` builds and publishes the site automatically.

Or publish manually:

```bash
flutter build web --release --base-href "/"
# then upload the contents of build/web to the Pages source
```
