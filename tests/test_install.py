import os
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest

INSTALLER = Path(__file__).resolve().parents[1] / "install.py"
NAME = "linkedin-content-writer"


class InstallerTests(unittest.TestCase):
    def run_installer(self, root, *args):
        env = dict(os.environ, CODEX_HOME=str(root))
        return subprocess.run([sys.executable, str(INSTALLER), *args], env=env,
                              capture_output=True, text=True)

    def test_install_refusal_and_backup(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary) / "codex home"
            self.assertEqual(self.run_installer(root).returncode, 0)
            target = root / "skills" / NAME
            self.assertTrue((target / "agents" / "openai.yaml").is_file())
            marker = target / "custom.txt"
            marker.write_text("keep my edits", encoding="utf-8")
            self.assertNotEqual(self.run_installer(root).returncode, 0)
            self.assertEqual(marker.read_text(), "keep my edits")
            self.assertEqual(self.run_installer(root, "--replace").returncode, 0)
            backups = list(target.parent.glob(NAME + ".backup-*"))
            self.assertEqual(len(backups), 1)
            self.assertEqual((backups[0] / "custom.txt").read_text(), "keep my edits")
            self.assertFalse(marker.exists())

    def test_dry_run_and_custom_directory(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary) / "codex"
            custom = Path(temporary) / "custom skills"
            result = self.run_installer(root, "--skills-dir", str(custom), "--dry-run")
            self.assertEqual(result.returncode, 0)
            self.assertFalse(custom.exists())
            self.assertEqual(self.run_installer(root, "--skills-dir", str(custom)).returncode, 0)
            self.assertTrue((custom / NAME / "SKILL.md").is_file())
            self.assertFalse(root.exists())


if __name__ == "__main__":
    unittest.main()
