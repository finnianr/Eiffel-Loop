note
	description: "Matlab c type"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:05:05 GMT (Saturday 19th May 2018)"
	revision: "3"

deferred class
	EL_MATLAB_C_TYPE

inherit
	EL_MEMORY
		undefine
			dispose
		end
		
	PLATFORM
	
feature -- Access

	item: POINTER

end