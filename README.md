# Sleep Journal Project Challenge

Welcome to the Sleep Journal challenge.

You are provided with an intentionally imperfect iOS app where users can track their sleep and optionally attach weather context.

Weather context uses the US National Weather Service API:
- https://api.weather.gov/
- API docs: https://api.weather.gov/openapi.json

## Requirements

- Must compile.
- Swift only (no Objective-C).
- MVVM pattern should be used in meaningful parts of the app.
- Third-party libraries are allowed but should be used minimally and only when justified.
- Keep the app functional while improving quality.

## Acceptance Criteria

This is intentionally time-boxed. Please pick a subset of criteria to focus on and clearly explain your tradeoffs.

- App shows a timeline/list of sleep entries with key summary information.
- User can create a new journal entry with sleep quality, mood, notes, and optional tags.
- User can search and filter entries.
- User can open an entry detail view.
- App persists data locally and supports offline usage.
- Weather fetch can be attached to an entry (current location + fallback behavior).
- Weather/network failures have clear retry behavior.
- App includes meaningful unit tests and/or UI tests.
- SwiftLint integration is a bonus.

## Defects and Tech Debt

You are not expected to fix everything. Pick a few issues that best demonstrate your approach.

Examples of issue categories in this project:
- Search behavior defects and edge cases
- Unsafe force unwraps / crash-prone code paths
- Error handling and user messaging gaps
- Architecture coupling and testability concerns
- Caching and stale data behavior
- UI update inefficiencies and readability issues

You may also identify and fix other defects you find.

## Bonus

1. Add a MapKit context for journal location with clustering support
2. Replace weather.gov with Apple WeatherKit
3. Add a Widget showing recent journal entries/trends
4. Add the ability to attach a photo to a journal entry
5. Any other features/capabilities you think would enhance the user experience and/or ties into the Resmed experience/brand.

## Additional Questions

Please answer the relevant questions in a `CANDIDATE_NOTES.md` file and include it in your submission:

1. List all dependencies and why you used them.
2. List any reused code/snippets and sources (personal snippets, links, prior projects, etc.).
3. What part of your code should we review most closely, and why?
4. If you continued this project, what would you improve next?
5. Anything else you want us to know while reviewing?
6. How did you use AI in your investigation/fixes?  (Please include prompts/skills/agents/etc. used)

## Submission

- Please make incremental commits in the provided local git repository.
- Submit a zipped folder that preserves `.git`
- Ensure your code builds with clear run instructions.
