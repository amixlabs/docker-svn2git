#!/bin/bash

eval "$(ssh-agent)"

filter_authors() {
    awk -F '|' '/^r/ {sub("^ ", "", $2); sub(" $", "", $2); print $2" = "$2" <"$2">"}' |
    sort -u
}

svn_generate_authors() {
    svn log -q "$SVN_URL_ROOT" |
    filter_authors >"$AUTHORS"
}

svn_git() {
    git svn clone "$SVN_URL_ROOT" --no-metadata -A "$AUTHORS" --stdlayout /wrk/repo
}