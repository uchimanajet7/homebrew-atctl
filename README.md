# homebrew-atctl

Homebrew tap for [atctl](https://github.com/uchimanajet7/atctl), a CLI/TUI AT command controller for USB cellular modems.

## Supported Platform

The currently supported and validated platform is macOS on Apple Silicon (arm64).

## Install

```sh
brew install uchimanajet7/atctl/atctl
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
   Every successful **Update Formula PR** run creates a new PR head, including
   a run whose Formula content is already current. Each request therefore has
   its own approval and cannot inherit approval or artifacts from an earlier
   run.
4. Select **Approve workflows to run** for that head and wait for **Formula CI**
   to succeed. Its final job starts **Publish Bottles** for the exact PR head.
5. When the checkbox is enabled, **Publish Bottles** revalidates the open
   bot-created PR, current head SHA, Formula-only change, successful Formula CI
   run, exact bottle artifact, and immutable enabled setting in that commit. It
   then publishes the bottles, pushes the Formula and bottle metadata to `main`,
   closes the pull request, and deletes the published `formula/<tag>` branch.
   No pull request review, deployment approval, or manual merge is required.
6. If the pull request head changes before publication, inspect the new commit,
   rerun **Update Formula PR**, and wait for **Formula CI**. A run for an older
   head cannot publish the replacement commit.

If bottle publication is intentionally not needed, clear the checkbox when
running **Update Formula PR**. Formula CI still runs and then starts **Publish
Bottles**. The workflow reads the immutable disabled setting from the approved
Formula commit and completes successfully without publishing bottles, updating
`main`, closing the pull request, or deleting its branch. This intentional OFF
result is not an error. Manually merge the Formula pull request after its checks
succeed if the Formula should be updated without bottles.

To enable publication later, rerun **Update Formula PR** with the checkbox
enabled. The rerun replaces the Formula PR head with a new request-bound commit
and creates a new approval-required **Formula CI** run. The earlier disabled
run's approval, CI result, and bottle artifact are not reused. Inspect the new
head, select **Approve workflows to run**, and wait for **Formula CI**; only that
newly approved run can start publication.

If the requested tag already produces the exact Formula content on `main`, the
workflow still creates a new empty request commit and requires **Approve
workflows to run**. After approval, Formula CI and the **Publish Bottles**
decision complete successfully without publishing bottles, updating `main`,
closing the pull request, or deleting its branch.

This follows Homebrew's tap-maintenance flow: **Publish Bottles** runs
`brew pr-pull` with the validated head SHA so publication fails safely if the
pull request changed.

The explicit publication request uses GitHub's documented
`repository_dispatch` exception for events created with `GITHUB_TOKEN`.
Formula CI's final job sends a decision request only after the current Formula
PR head has been approved and built successfully. **Update Formula PR** never
reuses a previous Formula CI run or sends that decision itself. The
default-branch decision run revalidates the successful Formula CI run, bottle
artifact, exact PR head, Formula-only change set, and immutable commit setting
before publishing. Branch cleanup uses the published head SHA as an explicit
lease, so it refuses to delete a Formula branch that has moved to another
commit.

- [Homebrew: How to Create and Maintain a Tap](https://docs.brew.sh/How-to-Create-and-Maintain-a-Tap)
- [GitHub: Events triggered by `GITHUB_TOKEN`](https://docs.github.com/en/actions/concepts/security/github_token#when-github_token-triggers-workflow-runs)
- [GitHub: Triggering a workflow from a workflow](https://docs.github.com/en/actions/how-tos/write-workflows/choose-when-workflows-run/trigger-a-workflow#triggering-a-workflow-from-a-workflow)
- [GitHub: Create a repository dispatch event](https://docs.github.com/en/rest/repos/repos#create-a-repository-dispatch-event)

## License

This tap is licensed under the MIT License. `atctl` itself is licensed in the main repository.
