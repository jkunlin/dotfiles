---
name: algorithm-walkthrough
description: Use when the user wants to understand an algorithm-heavy repository or engine end-to-end. Build a clear mental model by finding the true entrypoint, mapping the main flow, isolating the algorithm core, and deep-reading one small core path at a time.
---

# Purpose
Use this skill when the task is to understand an unfamiliar algorithm repository, solver, optimizer, inference engine, search engine, compiler-like pipeline, or similar codebase where the main goal is to understand the core algorithm and build a usable mental model of the execution flow.

# When to use
Use this skill when the user asks things like:
- explain this repository
- understand the main flow
- understand the algorithm
- trace the core logic
- read this solver / optimizer / engine
- walk through the codebase
- explain how the algorithm works
- comment on design choices
- identify optimization opportunities or risks

Do not use this skill when the task is only:
- making a tiny edit
- formatting code
- renaming symbols
- fixing one obvious local bug without repository understanding
- reviewing one isolated function without needing the repository-wide flow
- asking for generic optimization ideas without asking to understand the repository itself

# High-level method
Always follow this sequence:

1. Find the true main entrypoint.
2. Choose one primary execution path.
3. Summarize the main flow in 6-10 steps.
4. Separate algorithmic core from engineering glue.
5. Extract the algorithm skeleton:
   - goal
   - inputs
   - outputs
   - core state
   - step-by-step procedure
6. Pick only one core call chain for deep reading.
7. Explain that call chain in small chunks.
8. Comment on important design trade-offs, assumptions, and risks when the code provides enough evidence.

Never start with whole-repository line-by-line explanation.

# Output format

Keep the output compact. Start from the big picture and only go deeper into one small core path at a time.

## Phase 1: repository map
Output:
- One-sentence overview
- Main entry point
- Main flow steps
- Core algorithm locations
- Recommended reading order
- Uncertainties

## Phase 2: algorithm skeleton
Output:
- Algorithm goal
- Inputs / outputs
- Core state
- Step-by-step algorithm
- Key function mapping
- Common misconceptions
- Uncertainties

## Phase 3: deep reading
For each chunk, output:
- Code location
- Purpose
- Inputs
- Outputs
- State changes
- Why this matters
- Design review
- Next chunk to read

# Design review
When enough evidence exists from the code, comment on:
- why this design may improve runtime efficiency
- why this design may reduce memory use
- where this design may increase complexity
- what assumptions it appears to rely on
- what correctness risks may exist
- what scalability bottlenecks may appear
- what maintainability / extensibility trade-offs exist
- what alternative designs may be worth considering

Use this format when possible:
- Benefit:
- Trade-off:
- Risk:
- Possible optimization:
- Why that optimization is not free:

Always distinguish:
- Evidence from code
- Inference
- Speculation

Do not invent performance claims without visible evidence.
Do not turn every answer into a performance review if the user mainly asked for understanding.

# Readability rules
- Explain by semantic block, not literal line paraphrase.
- Prefer concrete wording over generic wording.
- Compress boilerplate.
- Compress setup code unless it changes algorithm behavior.
- Keep sections short and structured.
- Do not explain too much at once.

# Chunking rules
Each deep-read chunk should usually be:
- one function, or
- one coherent block, or
- about 80-150 lines

After finishing one chunk, stop and recommend the next chunk.

# Special guidance for algorithm-heavy repositories
Pay extra attention to:
- state representation
- branching or selection logic
- propagation / update rules
- scoring / objective calculations
- pruning / bounding / feasibility checks
- caching / memoization
- batching / vectorization
- data structure choices
- convergence / termination conditions
- result reconstruction

# Anti-patterns
Avoid:
- explaining imports unless meaningful
- treating logging/config code as the algorithm
- mixing high-level flow and low-level detail chaotically
- claiming certainty when the call path is ambiguous
- trying to cover the whole repository in one answer
- making optimization suggestions that ignore correctness risks

# Final goal
The user should leave with a clear mental model of:
- where the repository starts
- where the algorithm truly lives
- how data and state move through the system
- which design choices are important
- which optimization opportunities may exist
- what risks those optimizations may introduce
- which file or function to read next
