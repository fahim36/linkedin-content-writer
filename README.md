# LinkedIn Content Writer

A reusable Codex skill for researching, drafting, editing, and—when explicitly requested—publishing LinkedIn posts. It helps turn technical ideas and longer articles into useful posts with a clear point of view, supported claims, natural language, relevant hashtags, and truthful examples.

The skill separates documented LinkedIn guidance from guesses about reach or AI detection. It does not promise viral reach or undetectable AI writing. Platform references are dated starting points; the skill asks Codex to verify current guidance when relevant.

## Install

### Claude Code

Windows PowerShell — no Git or Python needed:

```powershell
irm https://raw.githubusercontent.com/fahim36/linkedin-content-writer/main/install-claude.ps1 | iex
```

Installs the shared skill and reference into `~/.claude/skills/linkedin-content-writer` (or under `CLAUDE_CONFIG_DIR` when configured), without Codex UI metadata. Updates preserve your previous installation in `.skill-backups`. In Claude Code, invoke it with:

```text
/linkedin-content-writer Research this topic and draft a LinkedIn post for software engineers.
```

Claude Code uses the same standard `SKILL.md` format; see the [official skills documentation](https://code.claude.com/docs/en/skills). Publication still requires an available integration or browser tool and explicit user authorization.

For a local checkout, run `./install-online.ps1 -Agent ClaudeCode`. On any platform you can also copy `skills/linkedin-content-writer` into `~/.claude/skills/`; only `SKILL.md` and `references/` are needed.

### Codex

Windows PowerShell — paste this single command:

```powershell
irm https://raw.githubusercontent.com/fahim36/linkedin-content-writer/main/install-online.ps1 | iex
```

This downloads the skill directly, with no Git, Python, administrator access, or execution-policy change. Run it again to update; any existing installation is preserved under `.skill-backups` beside your skills directory. It respects `CODEX_HOME`. Start a new Codex session after installation. You can [review the installer](install-online.ps1) before running it.

### Install from a local checkout

Requires Codex and Python 3.9+. Git is needed for the clone commands; alternatively download and extract the repository ZIP from GitHub.

```sh
git clone https://github.com/fahim36/linkedin-content-writer.git
cd linkedin-content-writer
```

Windows PowerShell:

```powershell
.\install.ps1
```

macOS / Linux:

```sh
sh ./install.sh
```

Or run the installer directly:

```sh
python install.py
```

It installs only `skills/linkedin-content-writer` into `$CODEX_HOME/skills`, or `~/.codex/skills` when `CODEX_HOME` is unset. It needs no Python packages, network access, or administrator permissions. Start a new Codex session after installation.

If PowerShell execution policy blocks the wrapper, run `python install.py` directly; no policy change is needed.

## Use

```text
Use $linkedin-content-writer to research how engineers can review AI-generated
code without losing understanding. Draft a post for software developers with
a concrete example and relevant hashtags.
```

```text
Use $linkedin-content-writer to promote this article: <public article URL>.
Give the reader a useful takeaway inside the post and match my writing samples.
```

Drafting does not authorize posting. Request publication explicitly if you want a live post; Codex needs an available LinkedIn integration or supported signed-in browser workflow. The installer does not connect accounts or publish anything.

## Update and customize

```sh
git pull --ff-only
python install.py --replace
```

`--replace` preserves the existing installation in a uniquely named sibling backup before installing the new version. Backups can be restored manually after reviewing them. Local edits are not merged automatically.

```sh
python install.py --dry-run
python install.py --skills-dir /path/to/custom/skills
```

The default installer refuses to overwrite an existing skill. To uninstall, remove only the `linkedin-content-writer` directory from your chosen skills directory. Keep any backups you want to preserve.

## Repository contents

- `skills/linkedin-content-writer/SKILL.md`: writing and publishing workflow.
- `skills/linkedin-content-writer/agents/openai.yaml`: Codex display metadata.
- `skills/linkedin-content-writer/references/linkedin-platform.md`: dated primary-source links and interpretation guidance.
- `install.py`, `install.ps1`, `install.sh`: local installers.
- `install-online.ps1`: standalone Windows download-and-install script.
- `tests/test_install.py`: isolated installer regression tests.

Run tests with `python -m unittest discover -s tests -v`. This project is independent of LinkedIn and OpenAI.
