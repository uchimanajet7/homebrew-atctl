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
2. Run the `Update Formula PR` workflow in this tap with the release tag.
3. Open the generated Formula pull request and review its exact head commit.
4. If GitHub displays **Approve workflows to run**, approve it and wait for
   **Formula CI** to succeed. This approval only permits CI to run; it does not
   publish bottles or merge the pull request.
5. To publish bottles, use the pull request's **Bottle publication** section:
   open its **Publish Bottles** link and copy the displayed `pull_request` and
   full 40-character `head_sha` values into **Run workflow**.
6. Do not manually merge the Formula pull request first. A successful
   **Publish Bottles** run verifies the reviewed head SHA, publishes its bottle
   artifacts, and pushes the Formula and bottle metadata to `main`.
7. If the pull request head changes, review the new commit and rerun
   **Update Formula PR** to refresh the publication values before continuing.

If bottle publication is intentionally not needed, manually merge the reviewed
Formula pull request after its checks succeed.

This follows Homebrew's tap-maintenance flow: review the pull request and its
checks, then run `brew pr-pull` with the reviewed head SHA so publication fails
safely if the pull request changed.

- [Homebrew: How to Create and Maintain a Tap](https://docs.brew.sh/How-to-Create-and-Maintain-a-Tap)

## License

This tap is licensed under the MIT License. `atctl` itself is licensed in the main repository.
