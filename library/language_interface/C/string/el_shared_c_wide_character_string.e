note
	description: "Summary description for {EL_SHARED_C_WIDE_CHARACTER_STRING}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_SHARED_C_WIDE_CHARACTER_STRING

feature -- Access

	wide_string (a_native_string: POINTER): EL_C_WIDE_CHARACTER_STRING
		do
			Result := Internal_wide_string
			Result.set_owned_from_c (a_native_string)
		end

feature {NONE} -- Constants

	Internal_wide_string: EL_C_WIDE_CHARACTER_STRING
		once
			create Result
		end
end
