#!/usr/bin/env bash
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

tmpfile="/tmp/.tmux.public-ip.txt"
update_period=60

update() {
	dig=$(which dig 2>/dev/null)
	if [[ -z $dig ]]; then
		echo "install 'dig'"
		exit;
	fi

	echo updating
	cat << _EOF_ > $tmpfile
LAST_TS=$(date +%s)
IP_ADDR=$($dig +short myip.opendns.com @resolver1.opendns.com)
_EOF_
}

if [ -f "$tmpfile" ]; then
	source $tmpfile
	if [[ $(( $LAST_TS + $update_period )) -lt $(date +%s) ]]; then
		echo "$(( $LAST_TS + $update_period )) is less than $(date +%s)"
		update
	fi
else
	update
fi

source $tmpfile
echo $IP_ADDR
