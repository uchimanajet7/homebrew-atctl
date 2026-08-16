# homebrew-atctl

Homebrew tap for [atctl](https://github.com/uchimanajet7/atctl), a CLI/TUI AT command controller for USB cellular modems.

## Supported Platform

The currently supported and validated platform is macOS on Apple Silicon (arm64).

## Install

```sh
brew install uchimanajet7/atctl/atctl
```

You can also tap the repository first:

```sh
brew tap uchimanajet7/atctl
brew install atctl
```

## Repository Scope

This repository owns the Homebrew tap files for `atctl`:

- `Formula/atctl.rb`
- tap CI
- manual Formula update PR workflow
- bottle build and publish workflow

The main `atctl` source code, product documentation, source releases, and release notes live in [uchimanajet7/atctl](https://github.com/uchimanajet7/atctl).

## Release Update Flow

Homebrew publication is separate from the main `atctl` release.

1. Create and verify an `atctl` release in the main repository.
2. Run the `Update Formula PR` workflow from `main`. Enter the release tag and
   leave **Publish bottles after Formula CI succeeds** checked to request bottle
   publication; the checkbox is checked by default.
3. Open the generated Formula pull request and inspect its exact head commit.
4. If GitHub displays **Approve workflows to run**, approve it and wait for
   **Formula CI** to succeed. Its final job starts **Publish Bottles** for the
   exact PR head.
5. When the checkbox is enabled, **Publish Bottles** revalidates the open
   bot-created PR, current head SHA, Formula-only change, successful Formula CI
   run, exact bottle artifact, and enabled marker. It then publishes the bottles
   and pushes the Formula and bottle metadata to `main` automatically. No pull
   request review, deployment approval, manual **Publish Bottles** run, or
   manual merge is required.
6. If the pull request head changes before publication, inspect the new commit,
   rerun **Update Formula PR**, and wait for **Formula CI**. A run for an older
   head cannot publish the replacement commit.

If bottle publication is intentionally not needed, clear the checkbox when
running **Update Formula PR**. Formula CI still runs and then starts **Publish
Bottles**. Its **Decide bottle publication** job records **disabled** and
completes successfully, while **Publish bottles and update main** is skipped. No
bottle publication or automatic `main` update occurs. Manually merge the
Formula pull request after its checks succeed.

To enable publication later without changing the Formula commit, rerun **Update
Formula PR** with the checkbox enabled. When that exact pull request head already
has a successful **Formula CI** run with an unexpired bottle artifact, the
updater starts **Publish Bottles** immediately. Otherwise, successful Formula CI
starts publication automatically.

An optional separate manual path remains available: open **Publish Bottles**,
select `main`, copy the `pull_request` number and full 40-character `head_sha`
from the generated PR's **Bottle publication** section, and run the workflow.
Manual publication starts after exact-head validation.

This follows Homebrew's tap-maintenance flow: **Publish Bottles** runs
`brew pr-pull` with the validated head SHA so publication fails safely if the
pull request changed.

The explicit publication request uses GitHub's documented
`repository_dispatch` exception for events created with `GITHUB_TOKEN`.
Formula CI's final job sends a decision request after a successful bot PR build.
When an unchanged PR head already has successful Formula CI, **Update Formula
PR** sends the same request after updating the Enabled/Disabled setting. The
default-branch decision run revalidates the successful Formula CI run, bottle
artifact, exact PR head, Formula-only change set, and marker before publishing.

- [Homebrew: How to Create and Maintain a Tap](https://docs.brew.sh/How-to-Create-and-Maintain-a-Tap)
- [GitHub: Events triggered by `GITHUB_TOKEN`](https://docs.github.com/en/actions/concepts/security/github_token#when-github_token-triggers-workflow-runs)
- [GitHub: Triggering a workflow from a workflow](https://docs.github.com/en/actions/how-tos/write-workflows/choose-when-workflows-run/trigger-a-workflow#triggering-a-workflow-from-a-workflow)
- [GitHub: Create a repository dispatch event](https://docs.github.com/en/rest/repos/repos#create-a-repository-dispatch-event)

## License

This tap is licensed under the MIT License. `atctl` itself is licensed in the main repository.
