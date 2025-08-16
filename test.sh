#!/bin/bash

# set -x

http_proxy=http://localhost:3128/
https_proxy=http://localhost:3128/
export http_proxy https_proxy

function check_url() {
    URL=$1
    EXPECT_CODE=$2
    # r=$(curl "$URL" -o /dev/null -w '%{http_code}\n' -v -s)
    code=$(curl "$URL" -L -o /dev/null -w '%{http_code}\n' -s)
    if [ "$code" != "$EXPECT_CODE" ]; then
        echo "Expected $EXPECT_CODE but got $code for $URL"
        exit 1
    else
        echo "Success: $URL returned $code"
    fi
}

function check_200() {
    check_url "$@" 200
}
function check_403() {
    check_url "$@" 403
}

# Function to check if a HTTPS-URL CONNECT is not allowed
function check_000() {
    check_url "$@" 000
}


# Manager check
#curl http://localhost:3128/squid-internal-mgr/menu

# check cant connect to
check_403 http://example.com/
check_000 https://www.google.com/

################################################################################
# APT
# Site check(repository-apt.conf HTTP)
check_200 http://deb.debian.org/
check_200 http://archive.ubuntu.com/
check_200 http://security.ubuntu.com/ubuntu/dists/noble-security/InRelease

# Site check(repository-apt.conf HTTPS)
# / path is returned 304 to www.ubuntu.com, so we check this path
# now HTTPS repository is disabled
check_000 https://security.ubuntu.com/ubuntu/dists/noble-security/InRelease
check_000 https://esm.ubuntu.com
check_000 https://motd.ubuntu.com

