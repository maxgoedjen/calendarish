# Calendarish

Calendarish is a ([highly work in progress](https://github.com/maxgoedjen/calendarish/projects/1)) Apple Watch app that directly talks to Google Calendar. If your organization restricts granting OAuth access to iOS, the scopes and constraints of Calendarish may be slightly more palatable.

## Why This Exists

Organizations with [Google's Advanced Protection](https://landing.google.com/advancedprotection/) enabled may restrict OAuth access to certain whitelisted IDs. The built in Mail/Calendar app on iOS is fairly loose around how it handles data/keeps things around after tokens are invalidated, and some organizations blacklist the OAuth ID for iOS as a result. Calendarish aims to replicate most of the "on watch" calendar experience (list upcoming events, complications, etc) while being more palatable about data management.

## Key Restrictions

- Only asks for the neccessary readonly scopes for calendar.
- Only fetch data for a few days in advance.
- Will purge data immediately after request failing due to token invalidation/revocation.

## Getting Set Up

- Install the app on both your iPhone and Apple Watch.
- Open the app on your iPhone and Apple Watch
- Hit "Add Account" on the iPhone. You'll be guided through the Google Sign In flow. When you're done, the account will sync to the Watch. You may need to restart the Watch app to see events (https://github.com/maxgoedjen/calendarish/issues/19)
- You're set up. The Watch app will update on its own from now on, without going through the iPhone.
