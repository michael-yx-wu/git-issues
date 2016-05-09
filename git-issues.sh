#!/usr/bin/env bash


read -r -d '' usage <<USAGE
usage: git-issues.sh [options]

Required options:

    -g GITHUB_URL   Fully qualified github URL
    -r REPOSITORY

Other options:

    -a ASSIGNEE
    -c AUTHOR
    -m MILESTONE
    -s STATUS       Can be 'open' or 'closed'
    -t TYPE         Can be 'issue' or 'pr'
USAGE


# https://github.palantir.build/elements/compass/issues?q=is:open+is:issue+assignee:michaelwu+milestone:1.6

github_url=''
milestone=''
assignee=''
author=''
repository=''
status=''
issue_type=''

while getopts ":a:c:g:m:r:s:t:" option; do
    case "$option" in
        a)
            assignee="assignee:${OPTARG}"
            ;;
        c)
            author="author:${OPTARG}"
            ;;
        g)
            github_url="$OPTARG"
            ;;
        m)
            milestone="milestone:${OPTARG}"
            ;;
        r)
            repository="$OPTARG"
            ;;
        s)
            status="is:${OPTARG,,}"
            ;;
        t)
            issue_type="is:${OPTARG,,}"
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

repo_parts=("$github_url" "$repository" 'issues?q=')
url=$(printf '%s/' "${repo_parts[@]%/}")
url=${url%/}

query_parts=("$assignee" "$author" "$milestone" "$status" "$issue_type")
query=$(printf '%s+' "${query_parts[@]}")

open "${url}${query%+}"
