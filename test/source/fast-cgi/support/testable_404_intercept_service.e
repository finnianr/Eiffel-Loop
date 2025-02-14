note
	description: "Test version of ${EL_404_INTERCEPT_SERVICE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-14 14:27:32 GMT (Friday 14th February 2025)"
	revision: "2"

class
	TESTABLE_404_INTERCEPT_SERVICE

inherit
	EL_404_INTERCEPT_SERVICE
		redefine
			new_servlet
		end
create
	make_port

feature {NONE} -- Implementation

	new_servlet: TESTABLE_404_INTERCEPT_SERVLET
		do
			create Result.make (Current)
		end

end