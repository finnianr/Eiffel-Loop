note
	description: "Test version of ${EL_404_INTERCEPT_SERVICE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-05 18:04:36 GMT (Wednesday 5th March 2025)"
	revision: "5"

class
	TESTABLE_404_INTERCEPT_SERVICE

inherit
	EL_404_INTERCEPT_SERVICE
		redefine
			new_servlet
		end

	SHARED_DEV_ENVIRON

create
	make, make_port

feature {NONE} -- Implementation

	new_servlet: TESTABLE_404_INTERCEPT_SERVLET
		do
			create Result.make (Current)
		end
end