note
	description: "Summary description for {EL_SHARED_PYTHON_INTERPRETER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:12 GMT (Tuesday 2nd September 2014)"
	revision: "2"

class
	EL_SHARED_PYTHON_INTERPRETER

feature -- Access

	Python: EL_PYTHON_INTERPRETER
			--
		once
			create Result.initialize
		end

end
