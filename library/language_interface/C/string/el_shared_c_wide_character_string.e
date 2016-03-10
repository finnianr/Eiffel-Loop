note
	description: "Summary description for {EL_SHARED_C_WIDE_CHARACTER_STRING}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "6"

class
	EL_SHARED_C_WIDE_CHARACTER_STRING

feature -- Access

	wide_string (a_native_string: POINTER): EL_C_WIDE_CHARACTER_STRING
		do
			if a_native_string = Default_pointer then
				create Result
			else
				Result := Internal_wide_string
				Result.set_owned_from_c (a_native_string)
			end
		end

feature {NONE} -- Constants

	Internal_wide_string: EL_C_WIDE_CHARACTER_STRING
		once
			create Result
		end
end
