note
	description: "Windows implementation of ${EL_OS_RELEASE_I}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "5"

class
	EL_OS_RELEASE_IMP

inherit
	EL_OS_RELEASE_I

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

end