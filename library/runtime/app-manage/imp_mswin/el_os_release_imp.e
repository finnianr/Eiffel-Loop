note
	description: "Windows implementation of ${EL_OS_RELEASE_I}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-08 9:16:53 GMT (Sunday 8th September 2024)"
	revision: "6"

class
	EL_OS_RELEASE_IMP

inherit
	EL_OS_RELEASE_I
		redefine
			is_windows_7
		end

	EL_WINDOWS_IMPLEMENTATION

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

feature -- Status query

	is_windows_7: BOOLEAN
		do
			Result := major_version = 6 and minor_version = 1
		end

end