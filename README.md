# DisplayLink Terminal Launcher

A small macOS launcher that starts DisplayLink Manager through Apple Terminal.

This allows macOS Screen Recording permission to be granted to Terminal rather than directly to DisplayLink Manager.

## Requirements

- Apple silicon Mac
- macOS 13 or later
- DisplayLink Manager installed in `/Applications`
- Screen Recording permission granted to Terminal

## Installation

1. Download and extract the release ZIP.
2. Move `DisplayLink Starter.app` to `/Applications`.
3. Open `DisplayLink Starter.app`.
4. When prompted, allow Terminal under `System Settings > Privacy & Security > Screen & System Audio Recording`.
5. Open `DisplayLink Starter.app` again after granting permission.

## How it works

The application opens a bundled command in Terminal. The command:

1. Stops an existing `DisplayLinkUserAgent`.
2. Starts a detached `screen` session named `displaylink`.
3. Launches the Apple silicon DisplayLink user agent inside that session.

The detached session allows DisplayLink Manager to continue running after the Terminal window closes.

## Verify

Check the detached session with `screen -ls`.

Check the DisplayLink process with `pgrep -af DisplayLinkUserAgent`.

## Uninstall

Remove `/Applications/DisplayLink Starter.app`.

The launcher does not uninstall DisplayLink Manager.

To stop the detached session, run `screen -S displaylink -X quit`.

## Build

Building requires the Xcode command-line tools. Run `zsh build.zsh`.

The generated application is written to `build/DisplayLink Starter.app`.

The local build uses ad-hoc code signing. Public release artifacts are not Apple-notarized.

## Limitations

- The current build targets Apple silicon only.
- DisplayLink Manager must use its standard application path.
- Starting the launcher interrupts and restarts the existing DisplayLink user agent.
- macOS privacy behavior can change between macOS releases.

## License

MIT
