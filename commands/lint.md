# /lint - Run Linters

Run code linters for this project and report any issues.

## Instructions

1. Detect the project type and available linters:
   - Python: Use `ruff check .` (preferred) or `flake8`
   - JavaScript/TypeScript: Use `eslint .`
   - Go: Use `golint` or `staticcheck`

2. Run the linter on the entire project

3. Report findings:
   - List any lint errors or warnings
   - Group by file if there are many issues
   - Offer to fix auto-fixable issues

4. For auto-fixable issues, ask if I should fix them:
   - Python: `ruff check --fix .`
   - JS/TS: `eslint --fix .`
