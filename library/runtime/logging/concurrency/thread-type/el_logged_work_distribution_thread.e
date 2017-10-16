note
	description: "Summary description for {EL_LOGGED_WORK_DISTRIBUTION_THREAD}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-03 13:47:03 GMT (Tuesday 3rd October 2017)"
	revision: "3"

class
	EL_LOGGED_WORK_DISTRIBUTION_THREAD

inherit
	EL_WORK_DISTRIBUTION_THREAD
		undefine
			on_start
		end

	EL_LOGGED_IDENTIFIED_THREAD
		undefine
			make_default, stop
		end

create
	make
end
