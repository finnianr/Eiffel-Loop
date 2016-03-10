note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:36 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_WAVE_IN_HANDLE
	
inherit
	MANAGED_POINTER
		rename
			make as make_pointer
		end

create
	make	
	
feature {NONE} -- Initialization

	make
			--
		do
			make_pointer (structure_size)
		end

feature -- Access

	structure_size: INTEGER
			-- Size to allocate (in bytes)
		once
			Result := c_size_of_HWAVEIN
		end

feature {NONE} -- Externals

	c_size_of_HWAVEIN: INTEGER
			--
		external
			"C [macro <mmsystem.h>]"
		alias
			"sizeof (HWAVEIN)"
		end
end

