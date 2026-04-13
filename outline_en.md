# From Talking to Doing: Building Task-Specific Harnesses for Coding Agents like Claude Code

Subtitle: When prompts alone aren't enough — how to build task-specific working environments for Coding Agents
Using Claude Code as the example, but the method applies to all Coding Agents (Codex, etc.)

---

## Outline

**Core question**: Why are general-purpose Coding Agents already so capable, yet so many tasks still feel "unstable"?

**Main thread**: Talking → Doing → Doing Stably → Extending On Demand

**Narrative arc**:
- First half (Talking → Doing → Doing Stably): use the same task in three environments to build intuition
- Second half (Extending On Demand): use cases from different domains to show how a harness grows in different directions based on task needs

### 1. From "Talking" to "Doing": Conversational AI vs Coding Agent

- Conversational AI (ChatGPT web, etc.): gives advice, code snippets — you paste, run, and check yourself
- Coding Agent (Claude Code, Codex, etc.): reads the codebase, edits files, runs commands, sees results, decides the next step
- The essential difference isn't that the model got smarter — it's that the agent can act in a dynamic environment and get feedback
- But being able to do things ≠ being able to do them stably. Common instability in general agents: random directory structure, no sense of what "done" means, can't resume halfway work, repeats the same mistakes

### 2. From "Doing" to "Doing Stably": What is a Harness

- Definition: a harness is everything outside the model that lets an agent work stably (Agent = Model + Harness)
- Four questions: What can the AI see? What can it do? How does it know it's correct? How does it resume next time?
- Prompt vs harness: a prompt governs what to do *this turn*; a harness governs how *this kind of task* gets done reliably
- The four components of a minimal harness:
  - **Structure**: directories, naming, templates
  - **Actions**: run / build / test scripts
  - **Judge**: validators, checkers, benchmarks
  - **Memory**: progress, iterations, logs
- A harness is never written in one shot: build → use → observe failures → write them back → use again (iterative loop)
- Core principle: once an error keeps recurring, don't just tweak the prompt — write it into the harness

### 3. How Harnesses Grow: Two Directions of Extension

The minimal harness gave you the intuition. But different tasks demand different harnesses, and the extensions go in different directions — not a linear progression, but two parallel directions you can combine as needed:

- **Solidify workflow**: fix repetitive processes in place; humans remain the main judge
  - CP_problems: standard directories + CLAUDE.md + pipeline + testlib
  - paper-toolkit: paper repo layout + meta.yaml + phases + pt CLI
- **Solidify evaluation loop**: when the task has a clear metric, the harness doesn't just stabilize the workflow — it lets the agent iterate and improve itself
  - AKO4ALL: setup → profile → iterate → track, ITERATIONS.md, trajectory

Essence: how much of the work that used to live in your head, do you outsource to the external system

### 4. Boundaries and Outlook

**When it's worth building:**
- Worth it: repeated, long-running, has external feedback, high failure cost, needs cross-session resume
- Not worth it: one-off, no clear judge, faster to do by hand
- Find the simplest thing that works first; add complexity only as needed

**What if we push this further:**
- Some people are already building "auto-research systems": ARIS (lightweight Markdown-only skill set, cross-agent), AI Scientist-v2 (end-to-end automated paper generation)
- But the boundaries are clear: AI Scientist-v2 itself admits low success on open-ended exploration and requires sandboxed execution; independent evaluations point out weak novelty assessment and high code-error rates
- My take: no system will reliably replace researchers in the short term, but verifiable, recordable, resumable sub-tasks in research will be harness-ified fast. For most of us, the realistic path isn't chasing a universal auto-scientist — it's identifying which parts of your work can be outsourced to structure, scripts, evaluation, and memory

### Key lines

- The model sets the ceiling; the harness sets the floor
- A prompt governs this turn; a harness governs this kind
- Stability doesn't come from longer prompts — it comes from a better repo environment

---

## Timeline

Pacing rule: every 8–12 minutes, something new should happen on the screen

### First half: one task, one continuous story (0–58 min)

Running task: create a competitive programming problem (statement + model solution + generator + validator + test data + pipeline)

#### 0–5 min | Opening [Talk]

Set up the question, announce the running task for the first half, don't unpack theory

#### 5–12 min | Demo 1: Conversational AI does the task [Demo]

Use ChatGPT web (can be pre-recorded) to do the task; expose the "it can talk, but you have to do the work" limitation

#### 12–22 min | Demo 2: Bare Claude Code does the same task [Demo]

In an empty directory, use Claude Code on the same task; expose "it can do things, but it's not stable"

#### 22–30 min | First abstraction: introducing the harness [Talk]

Anchor the discussion to the problems bare Claude Code just exposed — don't turn it into a concept intro:
- Why was it unstable? Because three things weren't externalized: rules (where to write), judge (what counts as correct), state (how to resume)
- These three together are the harness: everything outside the model that lets an agent work stably
- One-line comparison: a prompt governs this turn; a harness governs this kind

#### 30–37 min | Demo 3: reveal the harness + rerun [Demo+Talk]

Switch to `demos/with-harness/`. Don't read files one by one — focus on the three key differences:
- It now knows where to write (directory structure + CLAUDE.md)
- It now knows how to run (pipeline.sh)
- It now knows how to judge correctness (validator + pipeline checks)

Then rerun the same task on top of the harness and compare results

#### 37–50 min | Demo 4: iterating the harness [Demo]

Switch to a harder task that triggers a failure. Don't correct the agent verbally — edit CLAUDE.md / pipeline.sh live to show how a harness grows out of failures

#### 50–55 min | Second abstraction: the four components [Talk]

Distill the four components of a minimal harness from all previous demos: structure, actions, judge, memory

#### 55–58 min | Transition

> What I just showed is a teaching-sized minimal version — enough to see how a harness comes together. Now let me show you what a mature harness actually looks like, and whether the same idea transfers to other tasks.

### Second half: same idea, different domains (58–95 min)

#### 58–68 min | From teaching version to real version: the full CP_problems repo [Demo]

Core line: **what the minimal harness looks like once it matures**
Enter `repos/CP_problems`, contrast it with the teaching-sized version, run an existing problem end-to-end through the pipeline.

Transition:
> What we just solved is a single workflow. What if the task isn't 20 minutes, but a paper spanning days and many rounds?

#### 68–78 min | Case A: Solidify workflow — paper-toolkit [Demo]

Core line: **how the same harness idea transfers to long-running, cross-session tasks**
Enter `repos/paper-toolkit`, show the paper repo layout, phase mechanism, pt CLI. This isn't about automated paper writing — it's about harness migration.

Transition:
> Workflow alone isn't enough. When a task has a clear external metric — speed, accuracy, pass rate — can the harness not only stabilize it but let it keep getting better on its own?

#### 78–90 min | Case B: Solidify evaluation loop — AKO4ALL [Demo]

Core line: **when a task has a clear metric, how a harness solidifies the feedback loop**
Enter `repos/AKO4ALL`, show the setup → profile → iterate → track loop, ITERATIONS.md, trajectory/. Don't dive into kernel details — focus on the loop structure.

### Wrap-up (90–118 min)

#### 90–96 min | Wrap-up and boundaries [Talk]

Recap the two extension directions (solidify workflow / solidify evaluation loop); when it's worth building and when it isn't

#### 96–103 min | Outlook: from harnesses to auto-research systems [Talk]

Push today's topic one step further: if harnesses keep growing, what do they become?
- One line on ARIS and AI Scientist-v2: people are already trying to harness-ify the whole research process
- Be honest about the limits: low success on open-ended exploration, sandboxing requirement, unfavorable independent evaluations
- Land on your own take: no universal auto-scientist in the short term, but verifiable sub-tasks will be harness-ified quickly
- Pull it back to a general setting: not just research — homework, experiment reproduction, benchmark runs all face the same question: which parts can be outsourced to a harness, which still require human judgment

#### 103–112 min | Interactive [Interaction]

Invite a student to name a recurring task they do; discuss on the spot how to build a harness for it. Or open Q&A.

#### 112–118 min | Closing [Talk]

Three sentences + key line: the model sets the ceiling; the harness sets the floor
