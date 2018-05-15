# Switch Go (swgo)
# A very simple and intensely opinionated Go version manager.
#
# Author: George Lesica <george@lesica.com>
#
# To use, create a file called ".swgo" in any project directory.  Inside of
# this file, export two shell variables: GOROOT_ and GOPATH_ to the values you
# want assigned to GOROOT and GOPATH, respectively. Then, while in that
# directory, just run "swgo" and your GOROOT, GOPATH, and PATH will be updated
# accordingly.
#
# A nice optimization is to create a ".swgo" file in your home directory so you
# can easily restore your default environment.  If no config file is found in
# the current working directory, the parent directories will be searched
# recursively. The search will stop at the home directory.

function swgo() {
	local SWGO_CONFIG='.swgo'

    # Help
    # Display some useful information.
    if [[ "$1" == "help" ]]; then
        echo "Switch Go (swgo)"
        echo "Default:"
        echo "  Activate a config file, if found, use -q for quiet"
        echo "Commands:"
        echo "  create - make a new project-specific GOPATH"
        echo "  help - display this message"
        echo "  ignore - add the config file to global ignore files"
        echo "  save - copy existing GOROOT and GOPATH"
        echo "  show - print the current GOROOT and GOPATH"
    fi

    # Save
    # Copy the existing GOROOT and GOPATH into a .swgo file, if they exist. If
    # not, create a .swgo file with empty assignments.
    if [[ "$1" == "save" ]]; then
        echo "GOROOT_=\"$GOROOT\"" > $SWGO_CONFIG
        echo "GOPATH_=\"$GOPATH\"" >> $SWGO_CONFIG

        return 0
    fi

    # Show
    # Print the current GOROOT and GOPATH values.
    if [[ "$1" == "show" ]]; then
        echo "GOROOT=$GOROOT"
        echo "GOPATH=$GOPATH"

        return 0
    fi

    # Ignore
    # Append the .swgo filename to existing .gitignore, .hgignore, and possibly
    # other files in the home directory.
    if [[ "$1" == "ignore" ]]; then
        # TODO: Check for existence first
        echo "$SWGO_CONFIG" >> "$HOME/.gitignore"
        echo "$SWGO_CONFIG" >> "$HOME/.hgignore"

        return 0
    fi

    # Create
    # Set up a brand new Go project directory structure including src/, bin/,
    # and /pkg directories. Parameters are the host (GitHub or whatever) and
    # the project name.
    if [[ "$1" == "create" ]]; then
        local host="$2"
        local proj="$3"
        local code="$proj/src/$host/$proj"

        mkdir -p "$proj/bin"
        mkdir -p "$proj/pkg"
        mkdir -p "$code"

        echo "GOROOT_=\"$GOROOT\"" > "$code/$SWGO_CONFIG"
        echo "GOPATH_=\"$PWD/$proj\"" >> "$code/$SWGO_CONFIG"

        cd "$code"
        swgo

        return 0
    fi

    # Default functionality

    local quiet="0"
    if [[ "$1" == "-q" ]]; then
        quiet="1"
    fi

    # Look for a local config file. If none is found, recursively search the
    # parent directory but stop at the home directory. If no config is found,
    # exit with an error.
    local original="$PWD"
    while [[ ! -f "$SWGO_CONFIG" ]]; do
        if [[ "$PWD" == "$HOME" ]]; then
            cd "$original"
            >&2 echo "No config file ($SWGO_CONFIG) found"
            >&2 echo "Try 'swgo help'"
            return 1
        fi
        cd ".."
    done
    SWGO_CONFIG="$PWD/$SWGO_CONFIG"
    cd "$original"

    # Source the config to get the new variables, GOPATH_ and GOROOT_ that will
    # replace the existing values of GOPATH and GOROOT, respectively.
	source $SWGO_CONFIG

    # If there was no GOROOT_ found in the config then we can't set a new
    # environment.
	if [[ -z ${GOROOT_+x} ]]; then
		>&2 echo "No GOROOT_ defined in config"
		return 1
	fi

    # If there was no GOPATH_ found in the config then we can't set a new
    # environment.
	if [[ -z ${GOROOT_+x} ]]; then
		>&2 echo "No GOPATH_ defined in config"
		return 1
	fi

    # If there is an existing GOROOT we need to remove it from the PATH.
	if [[ -n ${GOROOT+x} ]]; then
		export PATH="${PATH//"$GOROOT/bin"}"
		export PATH="${PATH//"$GOROOT/bin/"}"
		unset GOROOT
	fi

    # If there is an existing GOPATH we need to remove it from the PATH.
	if [[ -n ${GOPATH+x} ]]; then
		export PATH="${PATH//"$GOPATH/bin"}"
		export PATH="${PATH//"$GOPATH/bin/"}"
		unset GOPATH
	fi

    # Kind of ugly but sometimes we want to clean up the PATH. There are a
    # couple cases:
	#   1. Leftover "::"
	#   2. Leading ":"
	#   3. Trailing ":"
	export PATH="${PATH/::/:}"
	export PATH="${PATH/#:/}"
	export PATH="${PATH/%:/}"

    # We have now blown away the existing Go environment so we are free to set
    # up a new one using the config values.

    # Set the new GOROOT from the config if one was specified.
	export GOROOT="$GOROOT_"
	unset GOROOT_

    # Set the new GOPATH from the config if one was specified.
	export GOPATH="$GOPATH_"
	unset GOPATH_

    # Update the path with the new GOROOT and GOPATH values. We prepend the
    # GOROOT to prevent the system Go from being used.
	export PATH="$GOROOT/bin:$PATH:$GOPATH/bin"

    if [[ "$quiet" == "0" ]]; then
        echo "GOROOT=$GOROOT"
        echo "GOPATH=$GOPATH"
    fi

	return 0
}

