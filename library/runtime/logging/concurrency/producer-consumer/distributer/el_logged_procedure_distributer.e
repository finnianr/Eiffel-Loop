note
	description: "Summary description for {EL_LOGGED_PROCEDURE_DISTRIBUTER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-04 13:57:35 GMT (Wednesday 4th October 2017)"
	revision: "3"

class
	EL_LOGGED_PROCEDURE_DISTRIBUTER [G]

inherit
	EL_PROCEDURE_DISTRIBUTER [G]
		redefine
			threads
		end

create
	make

feature {NONE} -- Internal attributes

	threads: EL_ARRAYED_LIST [EL_LOGGED_WORK_DISTRIBUTION_THREAD]
		-- threads of worker threads

end
