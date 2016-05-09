# git-issues

A small command line tool that generates a link to Github issues and opens it
in your default browser.

## Usage

```
usage: git-issues.sh [options]

Required options:

    -g GITHUB_URL   Fully qualified github URL
    -r REPOSITORY

Other options:

    -a ASSIGNEE
    -m MILESTONE
    -s STATUS       Can be 'open' or 'closed'
    -t TYPE         Can be 'issue' or 'pr'
```
