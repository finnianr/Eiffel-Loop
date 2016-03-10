note
	description: "Summary description for {EL_SHARED_PYTHON_INTERPRETER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:28 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_SHARED_PYTHON_INTERPRETER

feature -- Access

	Python: EL_PYTHON_INTERPRETER
			--
		once
			create Result.initialize
		end

end
