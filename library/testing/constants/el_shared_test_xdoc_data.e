note
	description: "Shared instance of ${EL_TEST_XDOC_DATA}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:23:38 GMT (Saturday 20th January 2024)"
	revision: "5"

deferred class
	EL_SHARED_TEST_XDOC_DATA

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Xdoc: EL_TEST_XDOC_DATA
		once
			create Result
		end
end