note
	description: "Experiment to see how Debian package info can be modeled in Eiffel"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-08-28 9:20:47 GMT (Wednesday 28th August 2019)"
	revision: "2"

class
	GCC_4_9_BASE -- gcc-4.9-base

feature -- Access

	version: DEBIAN_VERSION
		once
			Result := "4.9.3-0ubuntu4"
		end
end
