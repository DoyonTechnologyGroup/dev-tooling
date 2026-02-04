# /deploy - Deploy Project

Deploy this project to its configured destination.

## Instructions

1. Look for deployment configuration:
   - Check for `vercel.json` (Vercel)
   - Check for `fly.toml` (Fly.io)
   - Check for `railway.json` (Railway)
   - Check for `Dockerfile` (container deployment)
   - Check for `.github/workflows/deploy.yml` (GitHub Actions)

2. If a deployment config is found:
   - Confirm the deployment target with the user
   - Run the appropriate deploy command
   - Report deployment status and URL

3. If no deployment config is found:
   - Ask the user where they want to deploy
   - Help set up deployment configuration

## Common Deploy Commands
- Vercel: `vercel --prod`
- Fly.io: `fly deploy`
- Railway: `railway up`
- Manual Docker: `docker build -t app . && docker push`
