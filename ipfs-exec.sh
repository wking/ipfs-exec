#!/bin/sh
#
# Copyright (c) 2015, W. Trevor King <wking@tremily.us>
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
# 1. Reistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the
#    distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

VERSION='1.0.0'

usage() {
	cat <<-EOF
		usage: ipfs-exec.sh [options] IPFS_PATH COMMAND...

		options:

		  --help         print this help and exit
		  --output PATH  set the output directory
		  --version      print the version number and exit

		Pull content from IPFS [1], enter the resulting directory, and run
		COMMAND...

		The possibilities are endless, but one useful task is pulling an
		Open Container Initiative container [2,3] from IPFS and launching
		it with runC [4].

		[1]: http://ipfs.io/
		[2]: https://www.opencontainers.org/
		[3]: https://github.com/opencontainers/specs
		[4]: https://github.com/opencontainers/runc
	EOF
}

die () {
	echo "ERROR: ${@}" >&2
	exit 1
}

get_first_n_characters() {
	# POSIX doesn't support Bash's ${parameter:offset:length}
	# http://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html#tag_18_06_02
	LENGTH="${1}"
	OPTION="${2}"
	while test "${#OPTION}" -gt "${LENGTH}"
	do
		OPTION="${OPTION%%?}"
	done
	echo "${OPTION}"
}

OUTPUT=

while test "${#}" -gt 0 -a "x$(get_first_n_characters 1 "${1}")" = 'x-'
do
	case "${1}" in
		'--help')
			usage
			exit
			;;
		'--output')
			OUTPUT="${2}"
			shift
			;;
		'--version')
			echo "${VERSION}"
			exit
			;;
		'--')
			shift
			break
			;;
		*)
			die "invalid option to ${0} (${1})"
	esac
	shift
done

IPFS_PATH="${1}"
shift

if test -z "${IPFS_PATH}"
then
	die "missing IPFS_PATH argument ${0}"
fi

if test "${#}" -eq 0
then
	die "missing COMMAND argument ${0}"
fi

if test -z "${OUTPUT}"
then
	OUTPUT="${IPFS_PATH}"
fi

# TODO: this is racy.  The check should be in 'ipfs get ...'
if test -e "${OUTPUT}"
then
	die "output directory already exists ${OUTPUT}"
fi

ipfs get --output "${OUTPUT}" "${IPFS_PATH}" &&
cd "${OUTPUT}" &&
exec "${@}"
