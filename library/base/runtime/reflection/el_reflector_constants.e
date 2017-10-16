note
	description: "Summary description for {EL_REFLECTOR_CONSTANTS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:58 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	EL_REFLECTOR_CONSTANTS

inherit
	REFLECTOR_CONSTANTS
		export
			{NONE} all
		end

feature {NONE} -- Constants

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

	Once_current_object: REFLECTED_REFERENCE_OBJECT
		once
			create Result.make (Current)
		end
end