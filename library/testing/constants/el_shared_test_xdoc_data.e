note
	description: "Shared instance of ${EL_TEST_XDOC_DATA}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-04-29 8:55:04 GMT (Saturday 29th April 2023)"
	revision: "4"

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