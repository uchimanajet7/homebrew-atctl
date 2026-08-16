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

1. Create and review an `atctl` release in the main repository.
2. Run the `Update Formula PR` workflow from `main`. Enter the release tag and
   leave **Publish bottles after Formula CI succeeds** checked to request bottle
   publication; the checkbox is checked by default.
3. Open the generated Formula pull request and review its exact head commit.
4. If GitHub displays **Approve workflows to run**, approve it and wait for
   **Formula CI** to succeed. This approval only permits CI to run; it does not
   publish bottles or merge the pull request. After CI succeeds, its final job
   starts a **Publish Bottles** decision run for the exact PR head.
5. When the checkbox was enabled, open **Files changed**, select **Review
   changes**, choose **Approve**, and submit the review once. As soon as
   successful **Formula CI** and that exact-head approval both exist, **Publish
   Bottles** publishes; no deployment approval or manual merge is required. The
   approval may be submitted before or after CI finishes. If CI finishes first,
   its decision run completes successfully while waiting for that approval.
6. **Publish Bottles** revalidates the open bot-created PR, current head SHA,
   Formula-only change, repository-owner approval, successful Formula CI run,
   and exact bottle artifact. It then publishes the bottles and pushes the
   Formula and bottle metadata to `main`.
7. If the pull request head changes before publication, review the new commit,
   rerun **Update Formula PR**, wait for **Formula CI**, and approve the new head
   once. An approval for an older head cannot publish the replacement commit.

If bottle publication is intentionally not needed, clear the checkbox when
running **Update Formula PR**. Formula CI still runs and then starts **Publish
Bottles**. Its **Decide bottle publication** job records **disabled** and
completes successfully, while **Publish bottles and update main** is skipped. No
bottle publication or automatic `main` update occurs. Manually merge the
reviewed Formula pull request after its checks succeed.

To enable publication later without changing the Formula commit, rerun **Update
Formula PR** with the checkbox enabled. When that exact pull request head already
has both a repository-owner approval and a successful **Formula CI** run with an
unexpired bottle artifact, the updater starts **Publish Bottles** immediately.
Otherwise, wait for Formula CI and approve that exact head once. Approval may be
submitted before Formula CI finishes; successful CI then starts publication.

The separate manual path remains available: open **Publish Bottles**, select
`main`, copy the `pull_request` number and full 40-character `head_sha` from the
generated PR's **Bottle publication** section, and run the workflow. Manual
publication treats that explicit workflow run as authorization and starts after
exact-head validation without another approval step.

This follows Homebrew's tap-maintenance flow: review the pull request and its
checks, then run `brew pr-pull` with the reviewed head SHA so publication fails
safely if the pull request changed.

The explicit publication request uses GitHub's documented
`repository_dispatch` exception for events created with `GITHUB_TOKEN`.
Formula CI's final job always sends a decision request after a successful bot PR
build. A repository-owner PR approval also sends a decision request. The
default-branch decision run revalidates the current
repository-owner approval, successful Formula CI run, bottle artifact, exact PR
head, Formula-only change set, and enabled marker before publishing.

- [Homebrew: How to Create and Maintain a Tap](https://docs.brew.sh/How-to-Create-and-Maintain-a-Tap)
- [GitHub: Pull request review workflow event](https://docs.github.com/en/actions/reference/workflows-and-actions/events-that-trigger-workflows#pull_request_review)
- [GitHub: Events triggered by `GITHUB_TOKEN`](https://docs.github.com/en/actions/concepts/security/github_token#when-github_token-triggers-workflow-runs)
- [GitHub: REST API endpoints for pull request reviews](https://docs.github.com/en/rest/pulls/reviews)
- [GitHub: Triggering a workflow from a workflow](https://docs.github.com/en/actions/how-tos/write-workflows/choose-when-workflows-run/trigger-a-workflow#triggering-a-workflow-from-a-workflow)
- [GitHub: Create a repository dispatch event](https://docs.github.com/en/rest/repos/repos#create-a-repository-dispatch-event)

## License

This tap is licensed under the MIT License. `atctl` itself is licensed in the main repository.
