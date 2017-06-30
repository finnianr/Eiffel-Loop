note
	description: "Summary description for {EL_LOGGED_WORK_DISTRIBUTER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-06-13 8:57:37 GMT (Tuesday 13th June 2017)"
	revision: "1"

class
	EL_LOGGED_WORK_DISTRIBUTER

inherit
	EL_WORK_DISTRIBUTER
		redefine
			new_thread
		end

create
	make
	
feature {NONE} -- Implementation

	new_thread: EL_LOGGED_WORK_DISTRIBUTION_THREAD
		do
			create Result.make (Current)
		end

end
