#!/usr/bin/env bash


read -r -d '' usage <<USAGE
usage: git-issues.sh [options]

Required options:

    -g GITHUB_URL   Fully qualified github URL
    -r REPOSITORY

Other options:

    -a ASSIGNEE
    -m MILESTONE
    -s STATUS       Can be 'open' or 'closed'
    -t TYPE         Can be 'issue' or 'pr'
USAGE


# https://github.palantir.build/elements/compass/issues?q=is:open+is:issue+assignee:michaelwu+milestone:1.6

github_url=''
milestone=''
repository=''
status=''
issue_type=''
assignee=''

while getopts ":a:g:m:r:s:t:" option; do
    case "$option" in
        a)
            assignee="$OPTARG"
            ;;
        g)
            github_url="$OPTARG"
            ;;
        m)
            milestone="$OPTARG"
            ;;
        r)
            repository="$OPTARG"
            ;;
        s)
            status="${OPTARG,,}"
            ;;
        t)
            issue_type="${OPTARG,,}"
            ;;
        \?)
            echo "invalid option: -$OPTARG" >&2
            echo ''
            echo "$usage"
            exit 1
            ;;
        :)
            echo "option -$OPTARG requires an argument"
            echo ''
            echo "$usage"
            exit 1
            ;;
    esac
done

if [ -z "$github_url" ] || [ -z "$repository" ]; then
    echo "$usage"
fi

parts=("$github_url" "$repository" 'issues?q=')
url=$(printf '%s/' "${parts[@]%/}")
url=${url%/}

if [ ! -z "$assignee" ]; then
    url="${url}assignee:${assignee}+"
fi

if [ ! -z "$milestone" ]; then
    url="${url}milestone:${milestone}+"
fi

if [ ! -z "$status" ]; then
    url="${url}is:${status}+"
fi

if [ ! -z "$issue_type" ]; then
    url="${url}is:${issue_type}+"
fi

open "${url%+}"
