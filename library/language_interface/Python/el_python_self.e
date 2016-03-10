note
	description: "Summary description for {EL_PYTHON_SELF}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:28 GMT (Sunday 16th December 2012)"
	revision: "1"

deferred class
	EL_PYTHON_SELF

inherit
	EL_SHARED_PYTHON_INTERPRETER

	EL_PYTHON_INTERPRETER_CONSTANTS

feature {NONE} -- Initialization

	make_self (object: PYTHON_OBJECT)
			--
		local
			symbol_name: STRING
		do
			create symbol_name.make_from_string (generator)
			symbol_name.to_lower
			symbol_name.prepend ("my_")
			create self.make (symbol_name, object)
		end

	make_from_other (other: EL_PYTHON_SELF)
			--
		do
			make_self (other.self.py_object)
		end

feature {EL_PYTHON_SELF, EL_PYTHON_INTERPRETER} -- Implementation

	self: EL_PYTHON_OBJECT

end

