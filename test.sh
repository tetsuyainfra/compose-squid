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


# Manager check
#curl http://localhost:3128/squid-internal-mgr/menu

# check cant connect to
check_403 http://example.com/

# Site check(repository-apt.conf HTTP)
check_200 http://deb.debian.org/
check_200 http://security.debian.org/
check_200 http://archive.ubuntu.com/

# Site check(repository-apt.conf HTTPS)
check_200 https://esm.ubuntu.com
check_200 https://motd.ubuntu.com
check_200 https://security.ubuntu.com