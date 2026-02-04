# /ralph - Smart Ralph Workflow

Context-aware workflow command. Detects project state and does the right thing.

## Instructions

### Step 1: Detect Context

Check what state the project is in:

1. **No scaffold?** (no `docs/ralph-workflow.md`)
   → Run BOOTSTRAP flow

2. **Scaffold exists, no tasks?** (`docs/prd.json` has empty tasks array)
   → Run PLANNING flow

3. **Tasks exist, `current_task_id` is set?**
   → Run RESUME flow

4. **Tasks exist, none in progress?**
   → Run EXECUTE flow

5. **User says "lesson" or something just failed?**
   → Run LESSON flow

---

### BOOTSTRAP Flow

You are setting up Ralph workflow for the first time in this project.

#### Phase 0: Detect Stack & Check Dependencies

1. Find repo root (where .git lives). If no git, use current directory.
2. Detect stack:
   - `package.json` → Node/TypeScript
   - `go.mod` → Go
   - `pyproject.toml` or `requirements.txt` → Python
   - `Cargo.toml` → Rust
   - None → Unknown
3. **Check dependency freshness:**
   - Node: Run `npm outdated` or `yarn outdated`
   - Python: Run `pip list --outdated` (if in venv) or check against pypi
   - Go: Run `go list -u -m all`
   - Rust: Run `cargo outdated` (if installed)
4. Report any significantly outdated dependencies (major versions behind) and recommend updating before proceeding.

#### Phase 1: Create Scaffold Files

Create these files at repo root. Match structure exactly.

**A) CLAUDE.md** (short, always in context)

```markdown
# CLAUDE.md

Project-specific guidance for AI assistants.

## Core Principles

- **Simplicity First:** Make every change as simple as possible. Minimal code impact.
- **No Laziness:** Find root causes. No temporary fixes. Senior developer standards.
- **Minimal Impact:** Changes touch only what's necessary. Don't introduce bugs.
- **Lint Baseline:** If repo-wide lint already fails, do not introduce NEW lint errors in files you touch.

## Workflow Files

These files are NOT application code and may be freely created or edited:
`CLAUDE.md`, `README.md`, `docs/**`, `lessons/**`, `checks.yml`

## Planning Mode

Enter plan mode for ANY non-trivial task (3+ steps or architectural decisions).

- Write `docs/plan.md` + update `docs/prd.json` BEFORE writing any application code
- If something goes sideways, STOP and re-plan immediately
- If stuck after 2 retries, stop and revise the plan

### Plan Template (docs/plan.md)

Every plan must include:
- **Goal** — what we're building and why
- **Non-goals** — what we're explicitly not doing
- **Approach** — how we'll build it
- **Task list** — Ralph tasks (see Task Schema in `docs/ralph-workflow.md`)
- **Risks and mitigations**
- **Fast checks** — exact commands to validate

## Ralph Workflow

**Before executing any task**, read `docs/ralph-workflow.md` for the full execution loop.

## Language-Specific Rules

<!-- Populated during bootstrap based on detected stack -->
```

**B) docs/ralph-workflow.md** - Create the full workflow spec from the Ralph documentation. Include:
- Task Schema (id, desc, acceptance_criteria, files, fast_checks, dependencies, priority, done)
- Execution Loop (all 13 steps)
- Plan Revision Protocol
- Review Gate
- Compounding System (lessons)
- Lesson Graduation
- checks.yml schema and behavior
- Verification Standards
- Elegance Check
- Autonomous Bug Fixing
- Subagent Strategy

**C) docs/prd.json**
```json
{
  "goal": "",
  "fast_checks_default": [],
  "current_task_id": null,
  "last_completed_task_id": null,
  "iteration": 0,
  "tasks": []
}
```

**D) docs/plan.md**
```markdown
# Plan

<!-- Use this file to write detailed plans before coding -->
<!-- See CLAUDE.md for the required plan template -->
```

**E) docs/progress.md**
```markdown
# Progress

<!-- Execution log. Each entry records timestamp, task id, result, commands with exit codes, and outcome. -->
```

**F) lessons/README.md**
```markdown
# Lessons

Compounding knowledge from mistakes and surprises.

## Format

Each lesson file follows this structure:
- **Problem** — what went wrong or was surprising
- **Symptom** — how it manifested
- **Prevention** — what rule or check would prevent it
- **Where to apply** — which files, configs, or workflows
- **Reference** — paths, PRs, or links

## Graduation

When the same lesson pattern recurs 3+ times, it gets promoted to a permanent rule in CLAUDE.md.
```

**G) checks.yml**
```yaml
version: 1

# Active checks: hard constraints verified during execution.
checks: []

# Proposals: candidate gates from lessons. Not enforced until promoted.
proposals: []
```

#### Phase 2: Configure Language

Based on detected stack, update:

1. `docs/prd.json` - Set `fast_checks_default` based on available tooling
2. `CLAUDE.md` - Replace Language-Specific Rules section with appropriate rules

See the Ralph documentation for language-specific configurations (Node/TypeScript, Python, Go, Rust).

#### Phase 3: Create Tool Pointer Files

**.cursorrules**
```
Read and follow CLAUDE.md and docs/ralph-workflow.md for all project rules and workflow.
```

**.github/copilot-instructions.md** (create .github/ dir if needed)
```
Read and follow CLAUDE.md and docs/ralph-workflow.md for all project rules and workflow.
```

#### Phase 4: Update README

Add a `## Ralph Workflow` section to README.md explaining the workflow.

#### Phase 5: Git Commit

If repo has git:
1. Create branch `chore/ralph-workflow` (if not already on feature branch)
2. Stage only: CLAUDE.md, docs/**, lessons/**, checks.yml, README.md, .cursorrules, .github/copilot-instructions.md
3. Commit: "Initialize Ralph workflow"
4. Show status

**STOP after bootstrap. Do not proceed to application code.**

---

### PLANNING Flow

Help the user plan a feature/task.

1. Ask what they want to build
2. Create/update `docs/plan.md` with:
   - Goal
   - Non-goals
   - Approach
   - Task list (break into small, one-iteration tasks)
   - Risks and mitigations
   - Fast checks
3. Update `docs/prd.json` with tasks
4. Each task needs: id, desc, acceptance_criteria, files, dependencies, priority

**Do NOT write application code during planning.**

---

### EXECUTE Flow

Run one task from the execution loop.

1. Read `docs/ralph-workflow.md`
2. Read `checks.yml` for active constraints
3. Read `lessons/README.md`, scan up to 3 relevant lesson files
4. Read `docs/prd.json`
5. If no undone tasks, output "All tasks complete" and STOP
6. Select next task (lowest priority among undone tasks with done dependencies)
7. Set `current_task_id`, increment `iteration`
8. Restate acceptance criteria
9. Implement ONLY that task
10. If `fast_checks_default` is empty, log warning and STOP (don't mark done)
11. Run fast checks
12. If checks fail: rollback, retry (up to 2 retries)
13. If still failing: clear current_task_id, log failure, write lesson, trigger plan revision, STOP
14. If checks pass: verify acceptance criteria, mark done, log success, STOP

**ONE task per run. Always STOP after completing or failing a task.**

---

### RESUME Flow

Continue an interrupted task.

1. Read `current_task_id` from `docs/prd.json`
2. Log "Detected interrupted run; resuming task {id}" in `docs/progress.md`
3. Continue the EXECUTE flow from where it left off

---

### LESSON Flow

Record a lesson from a failure or surprise.

1. Ask what happened (or use the recent failure context)
2. Create `lessons/{topic}-{YYYY-MM-DD}.md` with:
   - **Problem** — what went wrong
   - **Symptom** — how it manifested
   - **Prevention** — what rule would prevent it
   - **Where to apply** — which files/workflows
   - **Reference** — relevant paths or links
3. If lesson suggests an enforceable gate, add to `checks.yml` under `proposals`
4. Check if this lesson pattern has recurred 3+ times → if so, graduate it to CLAUDE.md

---

### REVIEW Flow (after task completion)

Run review gate:

1. Find `last_completed_task_id` in `docs/prd.json`
2. Summarize what changed
3. Verify acceptance criteria are satisfied
4. Flag risks (security, reliability, performance)
5. Confirm fast checks passed
6. Output review notes only — do NOT change code
