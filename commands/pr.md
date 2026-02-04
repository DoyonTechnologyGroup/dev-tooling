# /pr - Create Pull Request

Create a pull request for the current branch with a generated summary.

## Instructions

1. First, check the current git state:
   - Verify we're not on main/master branch
   - Check for uncommitted changes
   - Get the list of commits since branching from main

2. Generate a PR title and description:
   - Analyze the commits and changed files
   - Write a clear, concise title (under 70 chars)
   - Write a summary of what changed and why
   - Include a test plan section

3. Create the PR using GitHub CLI:
   ```bash
   gh pr create --title "title" --body "description"
   ```

4. Report the PR URL when complete

## PR Description Template
```
## Summary
- Brief bullet points of what changed

## Test plan
- How to verify the changes work

Generated with Claude Code
```
