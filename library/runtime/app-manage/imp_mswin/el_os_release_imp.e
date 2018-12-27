note
	description: "Windows implementation of [$source EL_OS_RELEASE_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-06-05 10:20:59 GMT (Tuesday 5th June 2018)"
	revision: "2"

class
	EL_OS_RELEASE_IMP

inherit
	EL_OS_RELEASE_I

	EL_OS_IMPLEMENTATION

	EL_WEL_WINDOWS_VERSION
		rename
			major as major_version,
			minor as minor_version
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			name  := "Windows"
		end

feature -- Access

	name: ZSTRING

end
