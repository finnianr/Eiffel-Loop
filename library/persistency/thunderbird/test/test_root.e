note
	description: "Application root"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-11-04 14:15:38 GMT (Monday 4th November 2019)"
	revision: "23"

class
	TEST_ROOT

inherit
	EL_MULTI_APPLICATION_ROOT [EL_EIFFEL_LOOP_BUILD_INFO]

create
	make

feature {NONE} -- Constants

	Applications: TUPLE [OPEN_OFFICE_TEST_APP, THUNDERBIRD_TEST_APP]
		once
			create Result
		end

end
