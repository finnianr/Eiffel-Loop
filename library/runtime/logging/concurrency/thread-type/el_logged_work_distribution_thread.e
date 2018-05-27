note
	description: "Logged work distribution thread"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:50 GMT (Saturday 19th May 2018)"
	revision: "5"

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
