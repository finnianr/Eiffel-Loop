note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-14 15:37:24 GMT (Friday 14th June 2013)"
	revision: "2"

class
	EL_SYNCHRONIZED_IO

obsolete
	"Use EL_LOGGING"

feature -- Access

	sio: EL_SYNCHRONIZED [EL_LOCKABLE_STD_FILES]
			--
		once ("process")
			create Result
		end

end


