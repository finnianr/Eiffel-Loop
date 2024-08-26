note
	description: "Test version of ${EL_HACKER_INTERCEPT_SERVICE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-26 7:20:03 GMT (Monday 26th August 2024)"
	revision: "1"

class
	HACKER_INTERCEPT_TEST_SERVICE

inherit
	EL_HACKER_INTERCEPT_SERVICE
		redefine
			new_servlet
		end
create
	make_port

feature {NONE} -- Implementation

	new_servlet: TEST_HACKER_INTERCEPT_SERVLET
		do
			create Result.make (Current)
		end

end