# homebrew-atctl

Homebrew tap for [atctl](https://github.com/uchimanajet7/atctl), a CLI/TUI AT command controller for USB cellular modems.

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
3. Review the Formula update pull request and confirm the tap CI result.
4. If bottle publication is needed, run the `Publish Bottles` workflow with the reviewed pull request number and head SHA.
5. If bottle publication is not needed, merge the reviewed Formula update pull request.

## License

This tap is licensed under the MIT License. `atctl` itself is licensed in the main repository.
