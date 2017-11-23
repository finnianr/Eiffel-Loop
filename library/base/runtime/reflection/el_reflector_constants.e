note
	description: "Summary description for {EL_REFLECTOR_CONSTANTS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-11-10 15:11:50 GMT (Friday 10th November 2017)"
	revision: "3"

class
	EL_REFLECTOR_CONSTANTS

inherit
	REFLECTOR_CONSTANTS
		export
			{NONE} all
		end

feature {NONE} -- Constants

	Makeable_from_zstring_type: INTEGER
		once
			Result := ({EL_MAKEABLE_FROM_ZSTRING}).type_id
		end

	Makeable_from_string_8_type: INTEGER
		once
			Result := ({EL_MAKEABLE_FROM_STRING_8}).type_id
		end

	Makeable_from_string_32_type: INTEGER
		once
			Result := ({EL_MAKEABLE_FROM_STRING_32}).type_id
		end

	String_8_type: INTEGER
		once
			Result := ({STRING}).type_id
		end

	String_32_type: INTEGER
		once
			Result := ({STRING_32}).type_id
		end

	String_z_type: INTEGER
		once
			Result := ({EL_ZSTRING}).type_id
		end

	String_types: ARRAY [INTEGER]
		once
			Result := << String_8_type, String_32_type, String_z_type >>
		end

end
