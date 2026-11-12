# Duckpad Mermaid

Optional native Mermaid preview plugin for Duckpad. **Version 0.1.0.**

Install **Mermaid** from **Plugins Admin → Available Plugins**, or download the
[release ZIP](https://github.com/namJeongwan/duckpad-plugin-mermaid/releases/tag/v0.1.0),
extract it and select the `.duckpad-plugin` folder using **Install Plugin**.

Preview the active document or a chosen file, zoom/fit, open a larger preview
window and export PNG or SVG. Eight UI locales match Duckpad. Ctrl+W closes the
dock. Source is rendered locally and does not modify editor text or Undo.

Requires macOS 13+, native ABI v1 and host API **1.4.0** through 1.x.
Mermaid 12.0.0 is embedded in the signed native module, using the same pinned
dependency as Duckpad Markdown. No external runtime is needed after installation.
WebKit uses a nonpersistent page with strict Mermaid configuration and network
blocked. Supply Mermaid source directly, without Markdown fences.

## Build

Build against the Duckpad **v0.18.0** checkout containing `SDK/DiagramPreview`.
Run `npm ci --prefix /path/to/duckpad/scripts/markdown-preview --ignore-scripts`
first to install the existing pinned build dependencies.

```sh
bash scripts/build.sh native /path/to/duckpad
# Both Apple Silicon and Intel:
bash scripts/build.sh universal /path/to/duckpad
```

The output is `dist/com.duckpad.mermaid.duckpad-plugin`. Build output uses ad-hoc
Mach-O signing. Publisher signing requires an existing private key kept outside
the repository; scripts never generate or rotate it:

```sh
swift scripts/sign.swift dist/com.duckpad.mermaid.duckpad-plugin
swift scripts/verify.swift dist/com.duckpad.mermaid.duckpad-plugin
```

Install the signed folder using Plugins Admin → Install Plugin in a compatible
host. Distribution and local builds use ad-hoc Mach-O signing and publisher package
signatures, without Apple notarization.

## Verification and shared source

From the matching Duckpad checkout:

```sh
bash SDK/DiagramPreview/test.sh /path/to/duckpad-plugin-d2 /path/to/duckpad-plugin-mermaid
```

The shared UI/controller/WebKit sources compile into each plugin module and are
maintained in Duckpad's `SDK/DiagramPreview`; the host C ABI wrapper is compiled
from `SDK/DuckpadNative`. UI/lifecycle conventions derive from Duckpad PlantUML.
Native plugin installation is a code-trust boundary; it does not sandbox arbitrary
plugin code. Source is bounded to 512 KiB, SVG/PNG output to 32 MiB; PNG snapshots
are bounded to 8192 pixels per axis and 16 million pixels. Closing cancels work
and rejects late results.
