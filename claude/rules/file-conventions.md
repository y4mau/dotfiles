---
description: File handling, documentation, and Mermaid diagram conventions
globs:
---

# File Conventions

## Final Newline

All files must have a final newline. Check every created or updated file and add it if missing.

## Documentation

- Use Mermaid diagrams to visualize flows, architectures, and relationships
- Choose appropriate diagram type (flowchart, sequence, class, ER, state, etc.)
- Use code blocks (not Mermaid) for directory structures
- Use toggled blocks for large code blocks on issues/PRs

## Mermaid Rules

- Use `<br/>` instead of `\n` for line breaks in node labels
- Use dark-mode-friendly colors (`#2d333b`, `#58a6ff`, `#3fb950`, `#d29922`, `#f85149`)
- **Width control:**
  - Prefer `TD` over `LR` to avoid horizontal overflow
  - Keep node labels under 4 words; use `<br/>` for longer text
  - Maximum 4 nodes at the same depth level; split into subgraphs if more
  - Keep edge labels under 3 words or omit
