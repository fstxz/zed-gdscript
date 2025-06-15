"""Release script for creating a new version of the extension.

Updates the version in Cargo.toml and extension.toml, creates a new git tag, and generates a changelog.
"""

import sys
import subprocess
import re
import toml
import pyperclip
from packaging.version import Version

if len(sys.argv) != 2 or sys.argv[1] in ["-h", "--help"]:
    MESSAGE = "\n".join(
        [
            "Release script for creating a new version of the extension.",
            "Updates the version in Cargo.toml and extension.toml, creates a new git tag, and generates a changelog.",
            "",
            "Usage: python release.py <new_version>",
            "For example, python release.py 0.5.1",
        ]
    )
    print(MESSAGE)
    sys.exit(0)

new_version = sys.argv[1]
if not re.match(r"^\d+\.\d+\.\d+$", new_version):
    print(
        f"Error: '{new_version}' is not a valid semantic version. It should have the form major.minor.patch, e.g. 0.5.1."
    )
    sys.exit(1)

tag_current = subprocess.run(
    ["git", "describe", "--tags", "--exact-match"], capture_output=True, text=True
).stdout.strip()
if tag_current != "":
    print(
        "Error: There's already a tag on the current commit. Please make new commits before releasing."
    )
    sys.exit(1)

tag_last = subprocess.run(
    ["git", "describe", "--tags", "--abbrev=0"], capture_output=True, text=True
).stdout.strip()
if tag_last == "":
    print(
        "Error: No tags found. Please create a tag manually for the first version before using the script."
    )
    sys.exit(1)

if Version(new_version) <= Version(tag_last):
    print(
        f"Error: New version '{new_version}' must be greater than the last version '{tag_last}'"
    )
    sys.exit(1)

with open("Cargo.toml", "r") as f:
    cargo_toml = toml.load(f)
cargo_toml["package"]["version"] = new_version
with open("Cargo.toml", "w") as f:
    toml.dump(cargo_toml, f)
print(f"Updated Cargo.toml to version {new_version}")

with open("extension.toml", "r") as f:
    extension_toml = toml.load(f)
extension_toml["version"] = new_version
with open("extension.toml", "w") as f:
    toml.dump(extension_toml, f)
print(f"Updated extension.toml to version {new_version}")

subprocess.run(["git", "tag", new_version])
print(f"Created new git tag: {new_version}")

changelog = subprocess.run(
    ["git", "shortlog", f"{tag_last}..HEAD"], capture_output=True, text=True
).stdout.strip()
print("\nChangelog:")
print(changelog)
pyperclip.copy(changelog)
print("\nChangelog has been copied to the clipboard.")
