note
	description: "Shared instance of [$source EL_TEST_XML_DATA]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-29 9:16:18 GMT (Saturday 29th October 2022)"
	revision: "1"

deferred class
	EL_SHARED_TEST_XML_DATA

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	XML: EL_TEST_XML_DATA
		once
			create Result
		end
end