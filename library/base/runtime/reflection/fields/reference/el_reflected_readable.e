note
	description: "Summary description for {EL_REFLECTED_READABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-04 13:16:25 GMT (Friday 4th May 2018)"
	revision: "3"

deferred class
	EL_REFLECTED_READABLE [G]

inherit
	EL_REFLECTED_REFERENCE [G]

feature -- Basic operations

	read (a_object: EL_REFLECTIVE; reader: EL_MEMORY_READER_WRITER)
		deferred
		end

end
