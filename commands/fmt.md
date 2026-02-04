# /fmt - Format All Files

Format all source files in this project using the appropriate formatters.

## Instructions

1. Detect the project type:
   - Python: Use `ruff format .` (preferred) or `black .`
   - JavaScript/TypeScript: Use `prettier --write .`
   - Go: Use `gofmt -w .`
   - Rust: Use `cargo fmt`

2. Run the formatter on the entire project

3. Report what was formatted:
   - List files that were modified
   - Confirm formatting completed successfully
