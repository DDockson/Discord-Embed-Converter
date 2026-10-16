# Discord-Embed-Converter
Automatically converts copied X and Instagram links into Discord-friendly embed URLs.

## Features

- Converts `x.com` and `twitter.com` links to `fixupx.com`
- Converts Instagram Reel, post, and TV links to `oginstagram.com`
- Automatically detects URLs copied to the clipboard
- Runs in the background
- Starts automatically when you log in to Windows

## Examples

**X / Twitter**

Before:
```text
https://x.com/username/status/123456789?s=20
```

After:
```text
https://fixupx.com/username/status/123456789
```

**Instagram**

Before:
```text
https://www.instagram.com/reel/example/?srtk=example2
```

After:
```text
https://www.oginstagram.com/reel/example
```

## Installation

1. Download `converter.bat`.
2. Run the file.
3. Select **Install** from the menu.
4. Choose whether to start the converter immediately.

The installer creates the required files in `C:\Skripts` and adds a shortcut to the Windows Startup folder.

## Uninstallation

1. Run `converter.bat` again.
2. Select **Uninstall** from the menu.

The converter and its startup shortcut will be removed.

## Notes

- The converter monitors your clipboard while running.
- Only supported X/Twitter and Instagram URLs are converted.
- This project is not affiliated with Discord, X, Twitter, or Instagram.
- This project was built with the assistance of AI tools through vibe coding.

## Credits

- [FxEmbed/FxEmbed](https://github.com/FxEmbed/FxEmbed) for X/Twitter embed support
- [seirenkr/OGInstagram](https://github.com/seirenkr/OGInstagram) for Instagram embed support

## License

This project is licensed under the [MIT License](https://github.com/DDockson/Discord-Embed-Converter?tab=MIT-1-ov-file).
