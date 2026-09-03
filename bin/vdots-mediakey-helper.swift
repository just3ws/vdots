// vdots-mediakey-helper — register as the macOS "Now Playing" app while Neovim
// is reading a Markdown file aloud, so the hardware media keys (F7/F8/F9), the
// Touch Bar, AirPods and Control Center transport control the read-aloud.
//
// Spawned by lua/vdots/readaloud/mediakeys.lua with $VDOTS_NVIM_ADDR set to the
// Neovim RPC address. Each transport command shells back:
//   nvim --server $VDOTS_NVIM_ADDR --remote-expr "v:lua.require('vdots.readaloud').rpc('<cmd>')"
//
// Best-effort: macOS gives the media keys to whichever media app played most
// recently. Compiled on demand to $XDG_CACHE_HOME/vdots/ — never committed.
//
//   swiftc -O -o vdots-mediakey-helper vdots-mediakey-helper.swift

import AppKit
import MediaPlayer

let addr = ProcessInfo.processInfo.environment["VDOTS_NVIM_ADDR"] ?? ""

func nvim(_ cmd: String) {
    guard !addr.isEmpty else { return }
    let p = Process()
    p.executableURL = URL(fileURLWithPath: "/usr/bin/env")
    p.arguments = [
        "nvim", "--server", addr, "--remote-expr",
        "v:lua.require('vdots.readaloud').rpc('\(cmd)')",
    ]
    p.standardOutput = FileHandle.nullDevice
    p.standardError = FileHandle.nullDevice
    try? p.run()
}

let app = NSApplication.shared
app.setActivationPolicy(.accessory)

let center = MPRemoteCommandCenter.shared()
center.togglePlayPauseCommand.isEnabled = true
center.togglePlayPauseCommand.addTarget { _ in nvim("toggle_pause"); return .success }
center.playCommand.isEnabled = true
center.playCommand.addTarget { _ in nvim("resume"); return .success }
center.pauseCommand.isEnabled = true
center.pauseCommand.addTarget { _ in nvim("pause"); return .success }
center.nextTrackCommand.isEnabled = true
center.nextTrackCommand.addTarget { _ in nvim("next"); return .success }
center.previousTrackCommand.isEnabled = true
center.previousTrackCommand.addTarget { _ in nvim("prev"); return .success }
center.stopCommand.isEnabled = true
center.stopCommand.addTarget { _ in nvim("stop"); return .success }

let info = MPNowPlayingInfoCenter.default()
info.nowPlayingInfo = [
    MPMediaItemPropertyTitle: "Reading aloud",
    MPMediaItemPropertyArtist: "Neovim · vdots",
    MPNowPlayingInfoPropertyPlaybackRate: 1.0,
]
info.playbackState = .playing

// Exit cleanly when Neovim kills us.
let sig = DispatchSource.makeSignalSource(signal: SIGTERM, queue: .main)
sig.setEventHandler {
    MPNowPlayingInfoCenter.default().playbackState = .stopped
    exit(0)
}
sig.resume()
signal(SIGTERM, SIG_IGN)

app.run()
