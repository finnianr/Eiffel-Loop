note
	description: "Shared instance of [$source EL_TEST_XML_DATA]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-09 8:19:47 GMT (Wednesday 9th November 2022)"
	revision: "2"

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