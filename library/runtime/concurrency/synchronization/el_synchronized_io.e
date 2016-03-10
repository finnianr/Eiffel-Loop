note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-05-10 15:51:03 GMT (Sunday 10th May 2015)"
	revision: "3"

class
	EL_SYNCHRONIZED_IO

obsolete
	"Use EL_LOGGING"

feature -- Access

	sio: EL_MUTEX_CREATEABLE_REFERENCE [EL_LOCKABLE_STD_FILES]
			--
		once ("process")
			create Result
		end

end


