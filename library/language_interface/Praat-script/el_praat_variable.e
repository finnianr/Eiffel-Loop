note
	description: "Wraps a Praat interpreter variable"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_PRAAT_VARIABLE

create
	default_create

feature -- Element change
	
	set_item (ptr: POINTER)
			--
		do
			item := ptr
		end

feature -- Conversion

	to_string: STRING
			--
		require
			valid_item: is_attached (item)
		local
			string_value: POINTER
		do
			string_value := c_string_value (item)
			if is_attached (string_value) then
				create Result.make_from_c (string_value)
			end
		end
	
	to_double: DOUBLE
			--
		require
			valid_item: is_attached (item)
		do
			Result := c_numeric_value (item)
		end

feature -- Access

	item: POINTER

feature {NONE} -- C externals

	c_string_value (ptr: POINTER): POINTER
			-- Access field stringValue
		external
			"C [struct %"Interpreter.h%"] (struct structInterpreterVariable): EIF_POINTER"
		alias
			"stringValue"
		end
	
	c_numeric_value (ptr: POINTER): DOUBLE
			-- Access field stringValue
		external
			"C [struct %"Interpreter.h%"] (struct structInterpreterVariable): EIF_REAL_64"
		alias
			"numericValue"
		end
end

