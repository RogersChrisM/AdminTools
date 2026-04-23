# AdminTools

A supplementary shell + Python toolkit for handling general, repetitive, and administrative tasks in a way that integrates cleanly into bioinformatics and data science pipelines.

Developed and tested in a genomics and data science research context (macOS + HPC/SLURM environments).

**Author:** Christopher M. Rogers — [github.com/RogersChrisM](https://github.com/RogersChrisM/)  
**Language breakdown:** ~72% Shell (Bash) · ~28% Python  

---

## Contents

| Module | Description |
|---|---|
| [`cleanup/`](./cleanup) | Directory renaming, file archiving, temp sweeping, and old-file removal |
| [`cron/`](./cron) | Cron job generation and wrapping utilities |
| [`data_sci/`](./data_sci) | Data summary tools and a launcher for the plotting module |
| [`plotting/`](./plotting) | Python-based plot generators (bar, pie, dot, Venn diagrams) |
| [`debug/`](./debug) | Test runner and shared debug utilities |
| [`env/`](./env) | Environment validation and dependency checking |
| [`file/`](./file) | File backup, sync, copy, and remote transfer tools |
| [`inputs/`](./inputs) | Input validation, format checking, sanitization, and batch template generation |
| [`jobs/`](./jobs) | Job submission, monitoring, parallelism, remote execution, and retry logic |
| [`utils/`](./utils) | General-purpose utilities: logging, locking, signing, checksums, archiving, SSH, and more |

---

## Quick Start

### Requirements

- Bash 4.0+ (macOS ships with 3.x — install via `brew install bash`)
- Python 3.9+
- `shasum` (pre-installed on macOS; `sha256sum` on Linux — see note in `utils/sign.sh`)
- Standard Unix tools: `awk`, `find`, `rsync`, `ssh`

### Installation

```bash
git clone https://github.com/RogersChrisM/AdminTools.git
cd AdminTools
bash setup.sh
source ~/.zshrc   # or ~/.bashrc depending on your shell
```

`setup.sh` will:
1. Register the `admin_tools` dispatcher function in your shell config, resolving the repo root dynamically — no hardcoded paths
2. Install the pre-commit git hook so all staged `.sh` and `.py` files are automatically re-signed on every commit

### After forking — re-sign all scripts

After cloning or forking, re-stamp every script with your own identity and today's date:

```bash
admin_tools sign --all
```

This strips the original SHA256 signature blocks and replaces them with freshly computed hashes, so `admin_tools verify_signature <script>` works correctly against your local copies.

---

## Usage

Once set up, all scripts are accessible through the `admin_tools` dispatcher:

```bash
admin_tools <script_name> [args...]
```

The dispatcher searches all subdirectories automatically — no need to remember which module a tool lives in.

### Examples

```bash
# Validate an input file format
admin_tools check_input_format mydata.tsv

# Submit a job with retry logic
admin_tools submit_job myjob.sh
admin_tools retry_job myjob.sh --attempts 3

# Archive a directory
admin_tools archive_recursive /path/to/dir

# Generate a bar chart
admin_tools plot_launcher bar --input data.csv --output fig.png

# Sign a single script
admin_tools sign utils/my_script.sh

# Sign all scripts at once (e.g. after a fork)
admin_tools sign --all

# Verify a script's integrity
admin_tools verify_signature utils/my_script.sh

# Check running jobs
admin_tools job_status
admin_tools monitor_job_queue
```

---

## Script Integrity & Signing

Every script in this repo carries a trailing SHA256 signature block:

```bash
# --- Signature ---
# Author: CM Rogers (https://github.com/RogersChrisM/)
# Date: 2026-04-22
# SHA256: <hash>
```

The hash is computed against the file content **above** the signature block, so the block itself is excluded from the hash. This means:

- You can verify any script hasn't been tampered with using `admin_tools verify_signature <script>`
- After forking, run `admin_tools sign --all` to re-sign everything under your own name and date
- The pre-commit hook (installed by `setup.sh`) automatically re-signs any staged `.sh` or `.py` file on every commit, keeping signatures current

> **Note:** `sign.sh` uses `shasum -a 256` (macOS). On Linux, you may need to swap this for `sha256sum` in `utils/sign.sh`.

---

## Notes on HPC / SLURM Environments

Tools in `jobs/` were developed for use on SLURM-managed HPC clusters. Scripts like `submit_job.sh`, `wait_jobs.sh`, `run_parallel.sh`, and `remote_exec.sh` assume a SLURM environment is available. They will require adaptation for PBS, LSF, or other schedulers.

---

## License

MIT License — see [`LICENSE`](./LICENSE) for details.

---

## Contributing

This is a personal toolkit, but issues and PRs are welcome. If you adapt any tools for a different HPC scheduler or add new plotting types, feel free to open a pull request.
