# Switch Go (swgo)
# A very simple and intensely opinionated Go version manager.
#
# Author: George Lesica <george@lesica.com>
#
# To use, create a file called ".swgo" in any project directory.
# Inside of this file, set two variables: GOROOT_ and GOPATH_
# to the values you want assigned to GOROOT and GOPATH,
# respectively. Then, while in that directory, just run "swgo"
# and your GOROOT, GOPATH, and PATH will be updated accordingly.
#
# A nice optimization is to create a ".swgo" file in your home
# directory so you can easily restore your default environment.
# If no ".swgo" file is found in the current working directory
# your home directory will be checked next.

function swgo() {
	local SWGO_CONFIG='.swgo'

	# Look for the local .swgo file or, failing that, one
	# in the home directory. If neither is found, exit with
	# an error.
	if [[ ! -f "$SWGO_CONFIG" ]]; then
		if [[ ! -f "$HOME/$SWGO_CONFIG" ]]; then
			>&2 echo "No config file ($SWGO_CONFIG) found."
			return 1
		else
			SWGO_CONFIG="$HOME/$SWGO_CONFIG"
		fi
	fi

	# Source the config to get the new variables,
	# GOPATH_ and GOROOT_ that will replace the
	# existing values of GOPATH and GOROOT,
	# respectively.
	source $SWGO_CONFIG

	# If there was no GOROOT_ found in the config then
	# we can't set a new environment.
	if [[ -z ${GOROOT_+x} ]]; then
		>&2 echo "No GOROOT_ defined in config."
		return 1
	fi

	# If there was no GOPATH_ found in the config then
	# we can't set a new environment.
	if [[ -z ${GOROOT_+x} ]]; then
		>&2 echo "No GOPATH_ defined in config."
		return 1
	fi

	# If there is an existing GOROOT we need to remove it
	# from the PATH.
	if [[ -n ${GOROOT+x} ]]; then
		export PATH="${PATH//"$GOROOT/bin"}"
		export PATH="${PATH//"$GOROOT/bin/"}"
		unset GOROOT
	fi

	# If there is an existing GOPATH we need to remove it
	# from the PATH.
	if [[ -n ${GOPATH+x} ]]; then
		export PATH="${PATH//"$GOPATH/bin"}"
		export PATH="${PATH//"$GOPATH/bin/"}"
		unset GOPATH
	fi

	# Kind of ugly but sometimes we want to clean up the
	# PATH. There are a couple cases:
	#   1. Leftover "::"
	#   2. Leading ":"
	#   3. Trailing ":"
	export PATH="${PATH/::/:}"
	export PATH="${PATH/#:/}"
	export PATH="${PATH/%:/}"

	# We have now blown away the existing Go
	# environment so we are free to set up a new
	# one using the config values.

	# Set the new GOROOT from the config if one was
	# specified.
	export GOROOT="$GOROOT_"
	unset GOROOT_

	# Set the new GOPATH from the config if one was
	# specified.
	export GOPATH="$GOPATH_"
	unset GOPATH_

	# Update the path with the new GOROOT and GOPATH
	# values. We prepend the GOROOT to prevent the
	# system Go from being used.
	export PATH="$GOROOT/bin:$PATH:$GOPATH/bin"

	echo "GOROOT=$GOROOT"
	echo "GOPATH=$GOPATH"
	return 0
}
