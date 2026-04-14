# From Talking to Doing: Building Task-Specific Harnesses for Coding Agents like Claude Code

Subtitle: When prompts alone aren't enough — how to build task-specific working environments for Coding Agents
Using Claude Code as the example, but the method applies to all Coding Agents (Codex, etc.)

---

## Outline

**Core question**: Why are general-purpose Coding Agents already so capable, yet so many tasks still feel "unstable"?

**Main thread**: Talking → Doing → Doing Stably → Extending On Demand

**Narrative arc**:

- Warmup (-3 → 0 min): two images to set up "AI has already changed the way I work myself", naturally introducing the division of labor between conversational AI and coding agents
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
  - **Observation**: what the AI can see — directories, naming, templates, CLAUDE.md
  - **Tools**: what the AI can invoke — run / build / test scripts
  - **Judge**: how to tell if it's correct — validators, checkers, benchmarks
  - **Memory**: how to resume next time — progress, iterations, logs, git history
- Another angle: break the harness down by task phase instead of by component
  - **Before / Information**: what info to gather? how to gather it? how to organize the info and structure?
  - **During / Tools**: which parts of the workflow to solidify? how to design tools (including SKILLs)?
  - **After / Evaluation**: how to evaluate? how to budget evaluation time? which metrics to pick?
  - **End / Memory**: how to design memory? how does experience accumulate? how observable should the system be?
- A harness is never written in one shot: build → use → observe failures → write them back → use again (iterative loop)
- Core principle: once an error keeps recurring, don't just tweak the prompt — write it into the harness

### 3. How Harnesses Grow: Two Directions of Extension

The minimal harness gave you the intuition. But different tasks demand different harnesses, and the extensions go in different directions — not a linear progression, but two parallel directions you can combine as needed:

- **Solidify workflow**: fix repetitive processes in place; humans remain the main judge
  - paper-toolkit: paper repo layout + meta.yaml + phases + pt CLI
- **Solidify evaluation loop**: when the task has a clear metric, the harness doesn't just stabilize the workflow — it lets the agent iterate and improve itself
  - autoresearch, autokernel
  - AKO4ALL: setup → profile → iterate → track, ITERATIONS.md, trajectory
  - Prerequisites: quantifiable metric, clear target, simple evaluation, narrow modification scope

Essence: how much of the work that used to live in your head do you outsource to the external system

### 4. Boundaries and Outlook

**When it's worth building:**
- Worth it: repeated, long-running, has external feedback, high failure cost, needs cross-session resume
- Not worth it: one-off, no clear judge, faster to do by hand
- Find the simplest thing that works first; add complexity only as needed
- As the model gets stronger, peel back complexity as needed
- **The essence: probing the boundary of the model's capability**

**What if we push this further:**

- Some people are already building "auto-research systems":
  - ARIS (lightweight Markdown-only skill set, cross-agent)
  - AI Scientist-v2 (end-to-end automated paper generation)
- But the boundaries are clear: AI Scientist-v2 itself admits low success on open-ended exploration and requires sandboxed execution; independent evaluations point out weak novelty assessment and high code-error rates
- My take: no system will reliably replace researchers in the short term, but verifiable, recordable, resumable sub-tasks in research will be harness-ified fast. For most of us, the realistic path isn't chasing a universal auto-scientist — it's identifying which parts of your work can be outsourced to structure, scripts, evaluation, and memory

### Key lines

- The model sets the ceiling; the harness sets the floor
- Stability doesn't come from longer prompts — it comes from a better harness
- A good harness doesn't constrain the model, it unleashes it — that is what probing the boundary of the model's capability really means

---

## Timeline

Pacing rule: every 8–12 minutes, something new should happen on the screen

### Warmup (-3 → 0 min)

#### -3 → 0 min | Warmup: two images + personal disclose [Talk]

1. Show image 1: web novel cover (`assets/warmup-novel.jpeg`)
   - One sentence: time-traveled to ancient times, the power grid is fully down, but you still have Opus 4.6 and GPT 5.4 in your head — one night of work outputs what others would write in five days
   - Let the laughter land

2. Show image 2: Hanchen Li's /life page screenshot (`assets/warmup-hanchen-life.png`, from https://hanchenli.github.io/life/)
   - Berkeley AI Systems PhD whose homepage literally says "I am a humble slave to Claude"
   - More laughter

3. Personal disclose (the real point of the warmup)
   - I resonate with both of these — most of my own work is now done by AI, or with AI in the loop
   - Daily chat and quick Q&A → ChatGPT
   - Coding, research, slide-making — anything that needs hands-on work in a real environment → Claude Code / Claude's Cowork mode
   - Today I want to share what I've learned from a while of seriously using these tools

4. Throw out the main thread
   - Three things specifically: why conversational AI isn't enough, why bare coding agents aren't enough either, and how to build a task-specific working environment for a coding agent
   - Implicit (don't say it out loud): the very act of listing "for complex tasks I always use Claude Code" prompts students who still only use the web version to reflect on their own habits

### First half: one task, one continuous story (0–58 min)

Running task: create a competitive programming problem (statement + model solution + generator + validator + test data + pipeline)

#### 0–5 min | Opening [Talk]

Set up the question, announce the running task for the first half, don't unpack theory

#### 5–12 min | Demo 1: Conversational AI does the task [Demo]

Use ChatGPT web (can be pre-recorded) to do the task; expose the "it can talk, but you have to do the work" limitation

#### 12–20 min | Demo 2: Bare Claude Code does the same task [Demo]

In an empty directory, use Claude Code on the same task; expose "it can do things, but it's not stable"

#### 20–25 min | Demo 2.5: a task where the coding agent clearly wins [Demo]

Switch to a task where the coding agent obviously shines (e.g. reading an unfamiliar repo to answer a question, or making a small edit in existing code and running the tests). Quick beat:
- The essential difference isn't the model being smarter — it's that the agent directly interacts with your local environment, the process is transparent, and it can take on more complex tasks
- So the "instability" from Demo 2 isn't because coding agents are bad — give them the right task and they clearly win
- The problem is that the *general-purpose environment is too loose*, which is exactly the motivation for a harness
- Aside: today's web-based conversational AI is actually also an agent — it just runs in its internal sandbox. The coding agent's advantage is that it runs in *your* real environment

#### 25–32 min | First abstraction: introducing the harness [Talk]

Anchor the discussion to the problems bare Claude Code just exposed — don't turn it into a concept intro:
- Why was it unstable? Because three things weren't externalized: rules (where to write), judge (what counts as correct), state (how to resume)
- These three together are the harness: everything outside the model that lets an agent work stably
- One-line comparison: a prompt governs this turn; a harness governs this kind
- Hold on to those three for now — when we actually put the harness on screen in a moment, you'll find a fourth one hiding inside

#### 32–40 min | Demo 3: reveal the harness + rerun [Demo+Talk]

Switch to `demos/with-harness/`. Don't read files one by one — focus on the three key differences:
- It now knows where to write (directory structure + CLAUDE.md)
- It now knows how to run (pipeline.sh)
- It now knows how to judge correctness (validator + pipeline checks)

Then rerun the same task on top of the harness and compare results

#### 40–50 min | Demo 4: iterating the harness [Demo]

Switch to a harder task that triggers a failure. Don't correct the agent verbally — edit CLAUDE.md / pipeline.sh live to show how a harness grows out of failures

#### 50–55 min | Second abstraction: four components + needs-first view [Talk]

Distill the four components of a minimal harness from all previous demos: **Observation / Tools / Judge / Memory** (what the AI can see / do / use to judge / carry over).
Then flip to the other angle — "from the needs up", broken down by task phase: before (information) / during (tools, incl. SKILLs) / after (evaluation) / end (memory).
Stress: there's no single canonical harness decomposition. Both views are just lenses — what matters is externalizing recurring problems.

#### 55–58 min | Transition

> What I just showed is a teaching-sized minimal version — enough to see how a harness comes together. Now let me show you what a mature harness actually looks like, and whether the same idea transfers to other tasks.

### Second half: same idea, different domains (58–90 min)

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
Drop a concrete number to anchor it: on SOL-ExecBench L1-001 it hits an average **8.93×** speedup over **41 iterations** in **~2h** total — not to flex the result, but to show how far a fully automated evaluation loop can actually run on a real benchmark.
Briefly mention sibling systems: autoresearch (Karpathy) / autokernel (RightNow-AI) — to make clear this isn't a one-off, it's a class of ideas being validated.

### Wrap-up (90–118 min)

#### 90–96 min | Wrap-up and boundaries [Talk]

- Recap the two extension directions (solidify workflow / solidify evaluation loop)
- When it's worth building and when it isn't
- Adding complexity vs removing complexity: start with the simplest thing that works; as models get stronger, peel back the scaffolding that's no longer needed
- Zoom out one level: building a harness is fundamentally about probing the boundary of the model's capability

#### 96–103 min | Outlook: from harnesses to auto-research systems [Talk]

Push today's topic one step further: if harnesses keep growing, what do they become?
- One line on ARIS and AI Scientist-v2: people are already trying to harness-ify the whole research process
- Be honest about the limits: low success on open-ended exploration, sandboxing requirement, unfavorable independent evaluations
- Land on your own take: no universal auto-scientist in the short term, but verifiable sub-tasks will be harness-ified quickly
- Pull it back to a general setting: not just research — homework, experiment reproduction, benchmark runs all face the same question: which parts can be outsourced to a harness, which still require human judgment

#### 103–108 min | One level deeper: a few open questions [Talk]

Don't give answers — just put a few questions I'm chewing on out there, and let the audience carry them:
- **The SKILL shift**: SKILLs are becoming part of the harness — generated on demand, both solid and open, but inherently saddled with the unpredictability of natural language
- **AI assisting humans ↔ humans assisting AI**: the roles are flipping; watch not just the outputs but who is babysitting whom during the process
- **Automating harness optimization**: can an agent improve its own harness?
- **Meta-harness**: at a higher level, can the harness feed back into the model? The capability boundary we probe with a harness might end up re-ingested into the next generation of models

#### 108–114 min | Interactive [Interaction]

Invite a student to name a recurring task they do; discuss on the spot how to build a harness for it. Or open Q&A.

#### 114–118 min | Closing [Talk]

Three closing sentences:
1. From chat to agent: not smarter — but able to act in an environment
2. From agent to harness: not that the agent can't — but the general environment is too loose
3. Once an error keeps recurring, don't just tweak the prompt — write it into the harness

Three key lines:
- The model sets the ceiling; the harness sets the floor
- Stability doesn't come from longer prompts — it comes from a better harness
- A good harness doesn't constrain the model, it unleashes it — that is what probing the boundary of the model's capability really means
