<img src="Sources/ScribbleFoundation/Documentation.docc/Resources/ScribbleFoundation@1x.png" width="100" align="right">

# ScribbleFoundation

## Overview

ScribbleFoundation is a Swift library designed to provide a set of foundational utilities and protocols for iOS and macOS applications. It includes various components such as rate limiting, auditing, validation, and more, aimed at improving code organization, consistency, and functionality.

The ScribbleFoundation library offers a suite of protocols and utilities to help manage common tasks in software development. It includes protocols for rate limiting operations, auditing actions, validating data, and other essential functionalities that can be reused across different projects.

> [!WARNING]
> Please be aware that this project is still under active development. As such, it may contain bugs, incomplete features, and frequent changes. Use at your own risk and be prepared for potential issues.
>
> We appreciate your interest and welcome feedback and contributions. For any questions or issues, please refer to our [Issue Tracker](https://github.com/ScribbleLabApp/SFFileManagementKit/issues) or [Contact Us]().

## Requirements

Before building the ScribbleFoundation project, ensure you have the following tools and dependencies installed:

- **Swift**: Version 6.0 or higher
- **Xcode**: Version compatible with AppleClang and Swift 6.0 (for macOS users)
- **Command Line Tools**: Xcode 16 Command Line Tools installed

### Installation

#### Swift Package Manager (swift) (recommended)

You can integrate `ScribbleFoundation` into your project using Swift Package Manager (SPM). Here’s how:

1. In Xcode 16, open your project and navigate to File → Swift Packages → Add Package Dependency...
2. Paste the repository URL (https://github.com/ScribbleLabApp/ScribbleFoundation.git) and click Next.
3. For Version, verify it's Up to next major.
4. Click Next and select the `ScribbleFoundation` package.
5. Click Finish.

You can also add it to the dependencies of your `Package.swift` file:

```swift
dependencies: [
  .package(url: "https://github.com/ScribbleLabApp/ScribbleFoundation.git", .upToNextMajor(from: "0.1.0"))
]
```

## Contributing

Be part of the next revolution in note-taking by contributing to the project. This is a community-led effort, so we welcome as many contributors who can help. Read the [Contribution Guide](https://github.com/ScribbleLabApp/ScribbleLab/blob/main/CONTRIBUTING.md) for more information.

This project spans [multiple repositories]() so instead of browsing issues in the issues tab, it may be helpful to find an issue to get started on in our [project board](https://github.com/orgs/ScribbleLabApp/projects/1/views/1).

For issues we want to focus on that are most relevant at any given time, please see the issues scoped to our current iteration [here]().

## Support Us

Your support is valuable to us and helps us dedicate more time to enhancing and maintaining this repository. Here's how you can contribute:

⭐️ **Leave a Star:** If you find this repository useful or interesting, please consider leaving a star on GitHub. Your stars help us gain visibility and encourage others in the community to discover and benefit from this work.

✨ **Follow us on Social Media:** If you find this repository useful or interesting, please consider leaving a sub on YouTube or Instagram. Your sub help us gain visibility and encourage others in the community to discover and benefit from this work.

📲 **Share with Friends:** If you like the idea behind this project, please share it with your friends, colleagues, or anyone who might find it valuable.