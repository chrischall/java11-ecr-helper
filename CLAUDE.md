# java11-ecr-helper

Dockerfile for a CI build image based on `eclipse-temurin:17-jdk-jammy` with `awscliv2`, `git`, `postgresql-client`, and `ssh` preinstalled. Pushed to a private ECR repo and used as a Bitbucket Pipelines build image.

## Status

Stale — last commit Feb 2022. Despite the repo name, the image now ships **Java 17** (was bumped from Java 11). No CI, no tags, no automated builds. Default branch: `master`.

## Repo contents

```
Dockerfile   # the entire project — see comments below
README.md    # build + push instructions
LICENSE
```

## Build & push

```bash
podman build . --tag 294686472773.dkr.ecr.us-east-1.amazonaws.com/bitbucket/jdk-build:17
aws ecr get-login-password | podman login --username AWS --password-stdin 294686472773.dkr.ecr.us-east-1.amazonaws.com
podman push 294686472773.dkr.ecr.us-east-1.amazonaws.com/bitbucket/jdk-build:17
```

`docker` works in place of `podman` if preferred. The tag `:17` tracks the JDK major version baked into the image.

## Image notes

- Base: `eclipse-temurin:17-jdk-jammy` (Ubuntu 22.04).
- `awscliv2` is installed by downloading the official zip (not via apt) so the latest v2 is available.
- `curl` and `unzip` are installed only to fetch awscliv2, then purged + `apt-get autoremove` to keep the image smaller.
- No `ENTRYPOINT`/`CMD` — the image is consumed as a Bitbucket Pipelines build image, which provides its own command.

## Pull requests & release notes

**Default workflow: branch + PR, even for solo work.** Direct pushes to `main` skip review *and* skip auto-generated release notes — GitHub's `generate_release_notes` (configured in `.github/release.yml`) only picks up merged PRs. Push directly to `main` only when the user explicitly asks for it (e.g. emergency hotfix).

For every PR, apply exactly one label so it lands in the right release-notes section:

| Label                | Section in release notes |
|----------------------|--------------------------|
| `enhancement`        | Features                 |
| `bug`                | Bug Fixes                |
| `security`           | Security                 |
| `refactor`           | Refactor                 |
| `documentation`      | Documentation            |
| `test`               | Tests                    |
| `dependencies`       | Dependencies             |
| `ci` / `github_actions` | CI & Build            |
| *(none / unmatched)* | Other Changes            |
| `ignore-for-release` | Hidden from notes        |

The **PR title** becomes the bullet — write it like a user-facing changelog entry (`ck_set_session: refuse stale refresh tokens`), not internal shorthand (`auth tweaks`). Conventional-commit prefixes (`feat:`, `fix:`, `chore:`) are still fine in commit messages, but the PR title should read clean.

Open with `gh pr create --label <label>` (or `--label ignore-for-release` for chores not worth a line), then **immediately** run `gh pr merge <num> --auto --squash` so the PR merges as soon as CI passes. The repo is squash-only — don't pass `--merge`/`--rebase` or the call will fail.

Note: this repo has no `.github/release.yml`, no CI, and the default branch is `master` (not `main`). The label conventions above still apply if/when release automation is added.

## Gotchas

- **Repo name vs reality**: `java11-ecr-helper` is misleading — the image now ships Java 17. Don't "fix" the name without a downstream rename plan; the ECR tag is `:17`.
- **Hard-coded ECR registry**: `294686472773.dkr.ecr.us-east-1.amazonaws.com/bitbucket/jdk-build` appears in the README only. Update both README and any consumer pipelines together.
- **x86_64 only**: awscliv2 is fetched from `awscli-exe-linux-x86_64.zip`. Building on arm64 hosts (Apple Silicon) requires either an explicit `--platform=linux/amd64` or swapping the URL for `aarch64`.
- **No pinned base digest**: `FROM eclipse-temurin:17-jdk-jammy` floats. Rebuilds are not reproducible. Pin to a digest for reproducibility.
