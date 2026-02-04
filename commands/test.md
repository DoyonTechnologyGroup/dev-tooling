# /test - Run Project Tests

Run the test suite for this project. Detect the test framework and execute tests.

## Instructions

1. Detect the project type:
   - Python: Look for `pytest.ini`, `pyproject.toml`, or `setup.py`
   - Node.js: Look for `package.json` with a test script
   - Rust: Look for `Cargo.toml`

2. Run the appropriate test command:
   - Python: `pytest -v`
   - Node.js: `npm test` or `yarn test` (check for yarn.lock)
   - Rust: `cargo test`

3. Report test results including:
   - Number of tests passed/failed
   - Any error messages from failed tests
   - Summary of what was tested
