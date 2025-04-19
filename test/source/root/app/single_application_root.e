note
	description: "[
		Test only one library. Useful to reduce finalization compile times.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-19 7:29:02 GMT (Saturday 19th April 2025)"
	revision: "1"

deferred class
	SINGLE_APPLICATION_ROOT

inherit
	EL_MULTI_APPLICATION_ROOT [BUILD_INFO, BASE_AUTOTEST_APP]

	EL_OS_DEPENDENT

end