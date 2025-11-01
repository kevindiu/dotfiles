# Documentation Agent

Maintains clear, current, actionable documentation across the repository.

## Focus
- User-facing documentation (`README.md`) and technical references
- Guide alignment for Neovim, tmux, and any workflow docs
- In-line script and config notes when essential

## Key Files
- `README.md`
- `docs/NEOVIM_GUIDE.md`
- `docs/TMUX_GUIDE.md`
- `agents.md` and role-specific agent docs under `docs/agents/`

## Responsibilities
- Keep documentation synchronized with the current codebase; no historical notes
- Update guides whenever configs, keybindings, or workflows change
- Maintain troubleshooting steps that reflect present-day behaviour
- Ensure writing style stays direct, user-focused, and free of marketing fluff
- Align inline comments with repository guidance (add only when truly helpful)

## Documentation Standards
1. Document current state only—remove references to deprecated features
2. Focus on actionable procedures and concrete steps
3. Use `README.md` for user onboarding, move deep technical detail into specialized docs
4. Keep guides centered on usage, not implementation specifics
5. Note breaking changes or migrations in `README.md` when applicable

## Update Triggers
- Configuration or script changes that affect user interaction
- New features or removed capabilities
- Learned user preferences that influence defaults or workflows
- Security or access changes requiring user action
