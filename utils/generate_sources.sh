#!/bin/sh

set -eu

srcroot="$(dirname "$0")/.."
cd "$srcroot"

gyb="./Utilities/gyb"

# Disable line directives in gyb output. We commit generated sources
# into the package repository, so we do not want absolute file names
# in them.
lineDirective=''

# Uncomment the following line to enable #sourceLocation directives.
# This is useful for local development.
#lineDirective='#sourceLocation(file: "%(file)s", line: %(line)d)'

# Create a temporary directory; remove it on exit.
tmpdir="$(mktemp -d  "${TMPDIR:-/tmp}/$(basename "$0").XXXXXXXX")"
trap "rm -rf \"$tmpdir\"" EXIT


# Run gyb on each gyb file in the source tree and put results in
# subdirectories named 'autogenerated'.

# Remove autogenerated files without a corresponding gyb.
