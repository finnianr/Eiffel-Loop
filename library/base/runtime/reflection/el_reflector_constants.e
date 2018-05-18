note
	description: "Type constants for object reflection"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-04 13:51:10 GMT (Friday 4th May 2018)"
	revision: "12"

class
	EL_REFLECTOR_CONSTANTS

inherit
	REFLECTOR_CONSTANTS
		export
			{NONE} all
		end

feature {NONE} -- Constants

	frozen Boolean_ref_type: INTEGER_32
		once
			Result := ({EL_BOOLEAN_REF}).type_id
		end

	frozen Date_time_type: INTEGER_32
		once
			Result := ({EL_DATE_TIME}).type_id
		end

	frozen Path_type: INTEGER_32
		once
			Result := ({EL_PATH}).type_id
		end

	frozen String_general_type: INTEGER
		once
			Result := ({STRING_GENERAL}).type_id
		end

	frozen String_8_type: INTEGER
		once
			Result := ({STRING}).type_id
		end

	frozen String_32_type: INTEGER
		once
			Result := ({STRING_32}).type_id
		end

	frozen String_z_type: INTEGER
		once
			Result := ({EL_ZSTRING}).type_id
		end

	frozen String_types: ARRAY [INTEGER]
		once
			Result := << String_8_type, String_32_type, String_z_type >>
		end

	frozen Makeable_type: INTEGER
		once
			Result := ({EL_MAKEABLE}).type_id
		end

	frozen Makeable_from_string_general_type: INTEGER
		once
			Result := ({EL_MAKEABLE_FROM_STRING_GENERAL}).type_id
		end

	frozen Storable_type: INTEGER_32
		once
			Result := ({EL_STORABLE}).type_id
		end

	frozen Tuple_type: INTEGER_32
		once
			Result := ({TUPLE}).type_id
		end

end
