note
	description: "Shared python interpreter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 10:25:09 GMT (Monday 1st July 2019)"
	revision: "6"

deferred class
	EL_SHARED_PYTHON_INTERPRETER

inherit
	EL_ANY_SHARED

feature -- Access

	Python: EL_PYTHON_INTERPRETER
			--
		once
			create Result.initialize
		end

end
