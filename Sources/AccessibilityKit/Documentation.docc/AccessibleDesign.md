# Getting Started with Accessible Design using Scribble Accessibility Kit

What is accessible UI/UX design and how can developers provide a rich UX for people that rely on assistive technologies?

@Metadata {
    @Available(AccessibilityKit, introduced: "1.0")
    @Available(Xcode, introduced: "16.0")
    @SupportedLanguage(swift)
}

## Overview

Accessible UI/UX design refers to creating user interfaces and experiences that are usable by as many people as possible, including those who rely on assistive technologies like screen readers (VoiceOver, TalkBack), switch controls, and haptic feedback systems. Accessible design ensures that everyone, regardless of ability, can interact with applications in meaningful ways. For developers, it means considering various impairments such as vision, hearing, motor, or cognitive limitations and addressing them through thoughtful design.

Incorporating accessibility into apps improves usability for all users and ensures compliance with accessibility standards and guidelines like WCAG (Web Content Accessibility Guidelines) and ADA (Americans with Disabilities Act) requirements.

![A banner showing the accessibility icon with a blue background gradient](accessibility-header)

### How Developers Can Provide a Rich UX for People Relying on Assistive Technologies

Creating accessible apps ensures that users who rely on assistive technologies, such as screen readers, haptic feedback, and dynamic text, can have an equally rich user experience. Here are key ways developers can achieve this:

##### 1. Use Semantic Labels and Traits

Assigning meaningful labels and accessibility traits to UI elements is essential for ensuring assistive technologies like VoiceOver can provide users with accurate descriptions of on-screen content. Labels should:

- Be concise but descriptive enough to give context to the element’s purpose.
- Avoid redundant phrases like "button" if the trait already defines the element as such.
- Include dynamic content descriptions where necessary (e.g., “5 unread messages”).

###### Best Practices:

- Use accessibility APIs to set labels for all interactive elements, especially for custom controls.
- Ensure buttons and form elements are clearly labeled to indicate their function.

##### 2. Custom Accessibility Actions

By adding custom accessibility actions, developers can enhance the interactivity of their UI elements beyond basic touch inputs. For example, a button could offer additional context through a long press, or a list item might allow swipe-based actions.

###### Best Practices:

- Always ensure that custom actions are intuitive and make the app easier to use for those with assistive needs.
- Avoid overloading UI elements with too many actions, which could overwhelm users.

##### 3. VoiceOver Support

VoiceOver provides spoken feedback, allowing users to interact with their devices even without visual cues. Developers should ensure their app is fully navigable using VoiceOver by:

- Testing that all UI elements are reachable and announce correctly.
- Ensuring the navigation order makes sense, following the visual layout of the interface.
- Labeling custom views with accessibility elements and using containers where appropriate.

###### Best Practices:

- Group related elements together for logical VoiceOver navigation.
- Use meaningful, user-friendly labels rather than relying on internal variable names.

##### 4. Dynamic Text and Layout Adaptation

Supporting Dynamic Type allows users to scale text sizes system-wide. When users adjust their preferred reading size, the app should adapt its layout gracefully without breaking the design. Ensure that:

- Text does not truncate or overlap when larger sizes are selected.
- All text elements, including labels, buttons, and text fields, support dynamic type.
- Minimum tappable areas (44x44 points) are maintained for interactive elements.

###### Best Practices:

- Use Auto Layout to ensure that your layout responds to text size changes.
- Avoid fixed-size fonts for key content areas like paragraphs or labels.

##### 5. Color Contrast and Visual Alternatives

Color contrast plays a crucial role in readability, especially for users with low vision or color blindness. Apple's guidelines recommend maintaining a contrast ratio of at least 4.5:1 for standard text and 3:1 for larger text.

In addition, avoid relying on color alone to convey meaning. For example, if an error is indicated with red text, ensure there's a text or icon indicator so that users who can’t distinguish color differences can still understand.

###### Best Practices:

- Test your app with various color blindness simulators and contrast-checking tools.
- Use text, symbols, or patterns alongside color changes to communicate status.

##### 6. Haptic Feedback and Gestures

Haptic feedback provides tactile responses that help users without visual or auditory cues feel the interface’s responses. This is particularly important for users with visual impairments. Custom gestures or haptic patterns should follow intuitive and user-friendly behaviors.

###### Best Practices:

- Integrate haptics to reinforce actions like selections, errors, or state changes.
- Use subtle, consistent feedback to indicate interactive elements (e.g., tapping a button, performing a drag gesture).

> Note:
> In platforms that don’t play haptics, use other ways to provide feedback when people interact with custom objects, such as sound.

##### 7. Clear and Concise Language

For users with cognitive impairments or those who prefer simpler language, it’s essential to:

- Use clear and straightforward language in labels and instructions.
- Break down complex interactions into smaller, more manageable steps.
- Ensure consistency in language and structure across the app to reduce confusion.

###### Best Practices:

- Avoid jargon and overly technical terms unless absolutely necessary.
- Use actionable phrases for button labels (e.g., “Submit” instead of “OK”).

##### 8. Keyboard and Switch Control Navigation

For users who rely on external input devices like keyboards, switch controls, or other assistive technologies, ensure that:

- All interactive elements are accessible via keyboard navigation.
- Focus indicators are visible and intuitive as users tab through the interface.
- Custom gestures can be triggered using switch control or keyboard shortcuts.

###### Best Practices:

- Implement keyboard accessibility for all navigable UI elements, using focus states to make the flow clear.
- Consider how multi-step interactions can be simplified for switch control users.

##### 9. Reduce Motion and Animation Options

While animations and transitions can add visual flair, they can also overwhelm users with vestibular disorders or motion sensitivity. Offer an option to reduce motion in settings and ensure the app remains usable when animations are disabled.

###### Best Practices:

- Follow system settings for reduced motion, and opt for minimal transitions when necessary.
- Use subtle animations for essential feedback, ensuring they don’t disorient users.


### Accessible Design With Accessibility Kit

The Scribble Accessibility Kit provides developers with powerful tools to create accessible apps. By using layers such as SAAccessibilityLayer for VoiceOver management and SLAHapticLayer for haptic feedback, developers can significantly improve the experience for users relying on assistive technologies.

With accessible design principles and technologies, developers can create inclusive experiences that cater to a diverse range of users, ensuring their apps are usable and enjoyable for everyone.
