# LinkedIn Content Writer

A reusable Codex skill for researching, drafting, editing, and—when explicitly requested—publishing LinkedIn posts. It helps turn technical ideas and longer articles into useful posts with a clear point of view, supported claims, natural language, relevant hashtags, and truthful examples.

The skill separates documented LinkedIn guidance from guesses about reach or AI detection. It does not promise viral reach or undetectable AI writing. Platform references are dated starting points; the skill asks Codex to verify current guidance when relevant.

## Install

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
- `tests/test_install.py`: isolated installer regression tests.

Run tests with `python -m unittest discover -s tests -v`. This project is independent of LinkedIn and OpenAI.
