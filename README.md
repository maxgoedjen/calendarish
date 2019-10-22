# Calendarish

Calendarish is a ([highly work in progress](https://github.com/maxgoedjen/calendarish/projects/1)) Apple Watch app that directly talks to Google Calendar. If your organization restricts granting OAuth access to iOS, the scopes and constraints of Calendarish may be slightly more palatable.

## Key Restrictions

- Only asks for the neccessary readonly scopes for calendar.
- Only fetch data for a few days in advance.
- Will purge data immediately after request failing due to token invalidation/revocation.