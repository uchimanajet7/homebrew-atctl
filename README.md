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

## One-time Publication Approval Setup

Configure the publication approval before enabling automatic bottle
publication:

1. Open **Settings → Environments** and create an environment named
   `homebrew-publication`.
2. Add `uchimanajet7` as a required reviewer. Keep **Prevent self-review**
   disabled so the repository owner can also approve a manually dispatched
   publication.

The workflow reads the current Environment configuration and refuses to request
or perform publication if the environment, required reviewer, or manual-run
self-review setting does not match this contract.

## Release Update Flow

Homebrew publication is separate from the main `atctl` release.

1. Create and review an `atctl` release in the main repository.
2. Run the `Update Formula PR` workflow from `main`. Enter the release tag and
   leave **Publish bottles after Formula CI succeeds** checked to request bottle
   publication; the checkbox is checked by default.
3. Open the generated Formula pull request and review its exact head commit.
4. If GitHub displays **Approve workflows to run**, approve it and wait for
   **Formula CI** to succeed. This approval only permits CI to run; it does not
   publish bottles or merge the pull request.
5. When the checkbox was enabled, the successful **Formula CI** run's final
   **Request bottle publication** job sends an explicit publication request and
   starts **Publish Bottles**. Open that run, review the pull request, successful
   Formula CI run, and exact head SHA shown for the `homebrew-publication`
   deployment, then select **Approve and deploy**.
6. Do not manually merge the Formula pull request first. After approval,
   **Publish Bottles** revalidates the open PR, current head SHA, changed files,
   and publication request; it then publishes the bottle artifacts and pushes
   the Formula and bottle metadata to `main`.
7. If the pull request head changes before publication, review the new commit,
   rerun **Update Formula PR**, and approve the new **Formula CI** run. An older
   pending publication is rejected during post-approval revalidation.

If bottle publication is intentionally not needed, clear the checkbox when
running **Update Formula PR**. Formula CI still runs and records that publication
is disabled, but it does not start **Publish Bottles**. No publication approval,
bottle publication, or `main` update is requested. Manually merge the reviewed
Formula pull request after its checks succeed.

To enable publication later without changing the Formula commit, rerun **Update
Formula PR** with the checkbox enabled. When that exact pull request head already
has a successful **Formula CI** run and an unexpired bottle artifact, the updater
reuses that run and starts **Publish Bottles** immediately; Formula CI does not
need another approval. If no usable successful run exists, run or rerun Formula
CI for the exact head first.

The separate manual path remains available: open **Publish Bottles**, select
`main`, copy the `pull_request` number and full 40-character `head_sha` from the
generated PR's **Bottle publication** section, and run the workflow. Manual
publication uses the same `homebrew-publication` approval and post-approval
validation.

This follows Homebrew's tap-maintenance flow: review the pull request and its
checks, then run `brew pr-pull` with the reviewed head SHA so publication fails
safely if the pull request changed.

The explicit publication request uses GitHub's documented
`repository_dispatch` exception for events created with `GITHUB_TOKEN`. The
receiving workflow still revalidates the successful Formula CI run, its bottle
artifact, the exact PR head, the Formula-only change set, and the enabled marker
before requesting deployment approval.

- [Homebrew: How to Create and Maintain a Tap](https://docs.brew.sh/How-to-Create-and-Maintain-a-Tap)
- [GitHub: Triggering a workflow from a workflow](https://docs.github.com/en/actions/how-tos/write-workflows/choose-when-workflows-run/trigger-a-workflow#triggering-a-workflow-from-a-workflow)
- [GitHub: Create a repository dispatch event](https://docs.github.com/en/rest/repos/repos#create-a-repository-dispatch-event)
- [GitHub: Managing environments for deployment](https://docs.github.com/en/actions/how-tos/deploy/configure-and-manage-deployments/manage-environments)
- [GitHub: Reviewing deployments](https://docs.github.com/en/actions/how-tos/managing-workflow-runs-and-deployments/managing-deployments/reviewing-deployments)

## License

This tap is licensed under the MIT License. `atctl` itself is licensed in the main repository.
