# Court Click Movies

A Netflix-styled movie discovery app built in Flutter on top of [TMDB](https://www.themoviedb.org/)'s API.

The basic architecture, layering and core logic (BLoC wiring, API layer, DI setup, screen composition) in this project were designed and hand-written from scratch to a Figma reference, rather than pulled from a template or boilerplate generator.

## Screens

1. Splash
2. Profile Select ("Who's watching")
3. Home
4. Search
5. Coming Soon
6. Downloads
7. More

## APK

A prebuilt release APK is included at [`release/court-click-movies.apk`](release/court-click-movies.apk) — install it directly on any Android device.

## Screenshots

<table>
<tr>
<td width="33%">

**Splash**

<img src="screenshots/01_splash.png" width="260"/>

The Netflix wordmark on a pure black background, auto-advancing to Profile Select after 2 seconds.

</td>
<td width="33%">

**Profile Select**

<img src="screenshots/02_profile_select.png" width="260"/>

"Who's watching" style profile picker — 4 hardcoded profiles plus an Add Profile action, tap any avatar to enter.

</td>
<td width="33%">

**Home**

<img src="screenshots/03_home_top.png" width="260"/>

Full-bleed collapsing banner (`SliverAppBar` + `FlexibleSpaceBar`) with a gradient scrim, Play/My List/Info actions, and a circular "Previews" rail underneath.

</td>
</tr>
<tr>
<td width="33%">

**Home — loading shimmer**

<img src="screenshots/03b_home_loading_shimmer.png" width="260"/>

Skeleton placeholders (`shimmer` package) shown on first load instead of a bare spinner, matching the shape of the banner and movie rows.

</td>
<td width="33%">

**Home — rows**

<img src="screenshots/03c_home_rows.png" width="260"/>

Scrolled further down: Popular on Netflix, Trending Now, Top Rated and Now Playing, each an independent horizontally-scrolling rail pulling from a different TMDB endpoint.

</td>
<td width="33%">

**Search — empty state**

<img src="screenshots/04_search_empty.png" width="260"/>

Autofocused search field with a "Start typing to search" placeholder before any query is entered.

</td>
</tr>
<tr>
<td width="33%">

**Search — loading**

<img src="screenshots/04b_search_loading.png" width="260"/>

A ~400ms debounce delays each keystroke's API call; a spinner shows while the in-flight request resolves.

</td>
<td width="33%">

**Search — results**

<img src="screenshots/05_search_results.png" width="260"/>

"Top Searches" list rendered from the live TMDB response, each row with a poster thumbnail, "N" badge and play affordance.

</td>
<td width="33%">

**Search — typing**

<img src="screenshots/05b_search_typing.png" width="260"/>

Live results updating in place as the query narrows, keyboard and results visible together.

</td>
</tr>
<tr>
<td width="33%">

**Search — no results**

<img src="screenshots/05c_search_no_results.png" width="260"/>

Graceful empty state for a query that matches nothing on TMDB, instead of a blank screen.

</td>
<td width="33%">

**Coming Soon**

<img src="screenshots/06_coming_soon.png" width="260"/>

Full detail card per upcoming release: backdrop image, Remind Me/Share actions, formatted release date, synopsis and genre tags pulled from `/movie/upcoming`. The list paginates automatically as you scroll near the bottom.

</td>
<td width="33%">

**Downloads**

<img src="screenshots/07_downloads.png" width="260"/>

Static "Smart Downloads" promo screen with a Setup call-to-action, matching the reference design (no downloads API was in scope).

</td>
</tr>
<tr>
<td width="33%">

**More**

<img src="screenshots/08_more.png" width="260"/>

Profile switcher, a referral/share block with social icons, and a settings menu list (My List, App Settings, Account, Help, Sign Out).

</td>
</tr>
</table>

## Demo Video

A short screen recording of the app running end-to-end — navigating Home, searching, and browsing Coming Soon, Downloads and More.

<video src="screenshots/demo.mp4" controls width="300"></video>

*(If the player above doesn't render, download/view the file directly at [`screenshots/demo.mp4`](screenshots/demo.mp4).)*
