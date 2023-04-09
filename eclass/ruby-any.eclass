# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: ruby-any.eclass
# @MAINTAINER:
# Ruby team <ruby@gentoo.org>
# @AUTHOR:
# Author: Hans de Graaff <graaff@gentoo.org>
# Based on python-any-r1 by: Michał Górny <mgorny@gentoo.org>
# @SUPPORTED_EAPIS: 7 8
# @PROVIDES: ruby-utils
# @BLURB: An eclass for build-time dependencies on Ruby or Ruby packages.
# @DESCRIPTION:
# A minimal eclass for packages which need any Ruby interpreter installed without
# a need for explicit choice and invariability. This usually involves packages
# requiring Ruby at build-time but having no other relevance to it.
#
# @CODE
# USE_RUBY="ruby27 ruby30"
# inherit ruby-any
# BDEPEND="${RUBY_DEPS}"
# @CODE

case ${EAPI} in
	7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ ! ${_RUBY_ANY_ECLASS} ]]; then
_RUBY_ANY_ECLASS=1

inherit ruby-utils

if [[ ${_RUBY_SINGLE_ECLASS} ]]; then
	die "ruby-single.eclass can not be used with ruby-any.eclass."
elif [[ ${_RUBY_NG_ECLASS} ]]; then
	die "ruby-ng.eclass can not be used with ruby-any.eclass."
fi

# @ECLASS_VARIABLE: USE_RUBY
# @DEFAULT_UNSET
# @PRE_INHERIT
# @REQUIRED
# @DESCRIPTION:
# This variable contains a space separated list of targets (see above) a package
# is compatible to. It must be set before the `inherit' call. There is no
# default. All ebuilds are expected to set this variable.


# @ECLASS_VARIABLE: RUBY_DEPS
# @DEFAULT_UNSET
# @DESCRIPTION:
#
# This is an eclass-generated Ruby dependency string for all
# implementations listed in USE_RUBY. Any one of the supported ruby
# targets will satisfy this dependency. A dependency on
# virtual/rubygems is also added to ensure that this is installed
# in time for the package to use it.
#
# Example use:
# @CODE
# RDEPEND="${RUBY_DEPS}
#   dev-foo/mydep"
# BDEPEND="${RDEPEND}"
# @CODE
#
# Example value:
# @CODE
# || ( dev-lang/ruby:3.0 dev-lang/ruby:2.7 ) virtual/rubygems
# @CODE
#
# The order of dependencies will change over time to best match the
# current state of ruby targets, e.g. stable version first.

# @FUNCTION: ruby_setup
# @USAGE: [<impl-pattern>...]
# @DESCRIPTION:
# Find the best (most preferred) Ruby implementation that is suitable
# for running common Ruby code. Set the Ruby build environment up
# for that implementation.
ruby_setup() {
	local impl
	local ruby_candidate

	for impl in ${RUBY_TARGETS_PREFERENCE}; do
		if ! [[ ${USE_RUBY} =~ ${impl} ]]; then
			continue
		fi

		# Only proceed if it's requested
		if ! has_version "virtual/rubygems[ruby_targets_${impl}(-)]"; then
			continue
		fi

		ruby_candidate=$(ruby_implementation_command ${impl})
		if [[ -n ${ruby_candidate} ]] ; then
			export RUBY="${ruby_candidate}"
		fi
	done

	if [[ -z ${RUBY} ]] ; then
		die "No compatible Ruby implementations from USE_RUBY are installed."
	fi
}

_ruby_any_implementations_depend() {
	local depend
	for _ruby_implementation in ${RUBY_TARGETS_PREFERENCE}; do
		if [[ ${USE_RUBY} =~ ${_ruby_implementation} ]]; then
			depend+=" ("
			depend+=" $(_ruby_implementation_depend $_ruby_implementation)"
			depend+=" virtual/rubygems[ruby_targets_${_ruby_implementation}(-)]"
			depend+=" )"
		fi
	done
	echo "|| ( ${depend} )"
}

_ruby_any_set_globals() {
	RUBY_DEPS=$(_ruby_any_implementations_depend)
}

_ruby_any_set_globals

fi
