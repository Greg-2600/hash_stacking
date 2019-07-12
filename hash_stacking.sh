#!/bin/sh

get_usage() {
# help message
	echo "The data to hash can be sent via STDIN or as an argument"
	echo "Usage:"
        echo "$0 data or cat data.file|$0"
	exit 1; 
}

get_input() {
# function to use input provided via argument or stdin
# callable via get_input $@
# Usage: 
# 	get_input input
# 	echo "input"|get_input

	while read -t 1 stdin_line; do
		stdin+=$stdin_line
		echo $stdin_line
	done

	if [ -z "$stdin" ]; then
		stdin=$@
		echo $stdin
	fi
}


get_hash() {
# function to recursively hash a block of data

	# all algorithms supported by osx shasum
	#sha_alg='1 224 256 384 512 512224 512256'

	alg='256'                # sha algorithm
	iterations=100           # depth of recursions

	block=$@                 # data to hash
	salt=$RANDOM$RANDOM      # arbitrary salt
	this_hash="$salt $block" # genesis hash, and external loop scope storage

	# iterate for count of recursion depth
	for (( i = 0; i < $iterations; i++ )); do

		# if we want to use more than 1 algorithm...
		#for alg in $sha_alg; do

		# do the math and send product out of scope
		this_hash=$(
			echo $this_hash| # reference from outside of loop scope
			shasum -a $alg|  # set the sha algorithm
			cut -f1 -d' '    # unfortuently there is a trailing space and dash
		)
		#done
	done

	# express product result as valid json object
	echo "{"
	echo "	\"block\": \"$block\","
	echo "	\"salt\": \"$salt\","
	echo "	\"algorithms\": \"SHA: $alg\","
	echo "	\"iterations\": \"$iterations\","
	echo "	\"hash\": \"$this_hash\""
	echo "}"

}


main() {
# called with data from get_input.
# performs flow control, input validation, and exception handling

	# assign argument stack from get_input
	block=$@
	# validate data exists or send help and explode
	if [ -z "$block" ]; then
		get_usage
	fi
	# call get_hash and send the stack
	get_hash $@
}


main $(get_input $@)
