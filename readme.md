<!--
SPDX-License-Identifier: MIT
Author: Mark Gutenberger <mark-gutenberger@outlook.com>
readme.md (c) 2022
Desc: description
Created:  2022-03-14T12:59:52.083Z
Modified:2022-03-14T13:00:45.642Z
-->

## Well hello there :wave:

Honestly there is probably only one other human who will read this, but that's okay because documentation is still important.
Alright lets' get right into this!

## Prerequisites:

-   [Git](https://git-scm.com/)
-   [Node.js](https://nodejs.org/)
-   [Yarn](https://yarnpkg.com/) _(optional...)_

Assuming we have all of that taken care of, Let's go.

## Getting Started:

cha cha cha, you've almost certainly done this before.

let's get a little bit of

```bash
git clone https://github.con/mark-gutenberger/game_app_development_2022_proj_1.git
```

and a leetle bit of

```bash
cd game_app_development_2022_proj_1
yarn # or npm install ...
yarn start # or npm run start
# (the start command automatically compiles all code that needs to be.)
```

and Boom.

Project structure:

```bash
.  # root
├── app.js
├── assets
│   ├── js # all client-side scripts
│   │   ├── autolink.js
│   │   ├── events.js
│   │   ├── helpers.js
│   │   └── rtc.js
│   └── style # all client-side styles
│       ├── index.css
│       └── main.less
├── etc # all non-code files
│   └── App Lab Final Project Making it the BEST with Feedback.odt
├── favicon.ico
├── index.html
├── package.json
├── readme.md
├── ws # server-side scripting for socket.io
│   ├── stream.coffee
│   ├── stream.js
│   └── stream.js.map
└── yarn.lock
```
