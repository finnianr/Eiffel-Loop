note
	description: "Accesses the variables of a Praat script execution context"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "4"

deferred class
	EL_PRAAT_SCRIPT_CONTEXT

feature -- Access

	integer_variable (name: STRING): INTEGER
			-- Return value of Praat script variable as an integer value
		deferred
		end
		
	double_variable (name: STRING): DOUBLE
			-- Return value of Praat script variable as a double value
		deferred
		end

	real_variable (name: STRING): REAL
			-- Return value of Praat script variable as a real value
		deferred
		end

	string_variable (name: STRING): STRING
			-- Return value of Praat script variable as a string
		require
			praat_string_names_end_with_dollor: name.item (name.count) = '$'
		deferred
		end
		
	indexed_string_variable (name: STRING; index: INTEGER): STRING
			--
		deferred
		end

end