#!/bin/bash
set -euo pipefail

function verbose_command ()
{
	echo "Running: '$@'"
	"$@"
}

d="$(dirname "$0")"
rules="$d/yaml-rules.yml"
[ -r "$rules" ] || {
	echo "ERROR: Rules file '$rules' unreadable" >&2
	exit 1
}

declare  -a files
if [ $# -eq 0 ]; then
	files=($rules)
else
	files=($@)
fi


for i in "${files[@]}"
do
	[ -f "$i" ] || {
		echo "ERROR: pathname '$i' is not file" >&2
		exit 1
	}
	verbose_command yamllint -c "$rules" $i
	# IMPORTANT! Yamllint just check rules, but does NOT guarantee that YAML is parse-able!
	verbose_command python3 -c 'import yaml, sys; yaml.safe_load("'"$i"'")'
done
exit 0
