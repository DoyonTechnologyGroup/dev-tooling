# /deps - Check Dependency Freshness

Check for outdated dependencies and security issues. Works with any project type.

## Instructions

### Step 1: Detect Package Manager

Look for these files to determine the stack:

| File | Stack | Tool |
|------|-------|------|
| `package-lock.json` | Node | npm |
| `yarn.lock` | Node | yarn |
| `pnpm-lock.yaml` | Node | pnpm |
| `bun.lockb` | Node | bun |
| `pyproject.toml` | Python | pip/uv |
| `requirements.txt` | Python | pip |
| `Pipfile.lock` | Python | pipenv |
| `go.mod` | Go | go |
| `Cargo.toml` | Rust | cargo |
| `Gemfile.lock` | Ruby | bundler |
| `composer.lock` | PHP | composer |

### Step 2: Check for Outdated Dependencies

Run the appropriate command:

**Node (npm)**
```bash
npm outdated
```

**Node (yarn)**
```bash
yarn outdated
```

**Node (pnpm)**
```bash
pnpm outdated
```

**Python (pip)**
```bash
pip list --outdated
```

**Python (uv)**
```bash
uv pip list --outdated
```

**Go**
```bash
go list -u -m all 2>/dev/null | grep '\[' 
```

**Rust**
```bash
cargo outdated 2>/dev/null || echo "Install with: cargo install cargo-outdated"
```

### Step 3: Check for Security Vulnerabilities

Run security audit if available:

**Node**
```bash
npm audit
```

**Python**
```bash
pip-audit 2>/dev/null || echo "Install with: pip install pip-audit"
```

**Rust**
```bash
cargo audit 2>/dev/null || echo "Install with: cargo install cargo-audit"
```

### Step 4: Report Findings

Summarize:

1. **Critical updates** (major versions behind or security issues)
   - List each with current → latest version
   - Note any breaking changes to be aware of

2. **Recommended updates** (minor/patch versions)
   - Group by category if many

3. **Suggested commands** to update:
   - Node: `npm update` or `npm install package@latest`
   - Python: `pip install --upgrade package`
   - Go: `go get -u ./...`
   - Rust: `cargo update`

### Step 5: Offer to Update

Ask the user:
- "Want me to update all patch/minor versions?" (safe)
- "Want me to update major versions one at a time?" (needs testing)

If they say yes, run the appropriate update commands and verify the project still builds/tests.
