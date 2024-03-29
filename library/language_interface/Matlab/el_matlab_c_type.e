note
	description: "Matlab c type"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "5"

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