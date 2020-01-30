note
	description: "Type constants for object reflection"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-30 12:16:37 GMT (Thursday 30th January 2020)"
	revision: "29"

class
	EL_REFLECTOR_CONSTANTS

inherit
	REFLECTOR_CONSTANTS
		export
			{EL_REFLECTION_HANDLER} all
		end

feature {EL_REFLECTION_HANDLER} -- Collection types

	frozen Numeric_collection_type_table: EL_REFLECTED_COLLECTION_TYPE_TABLE [NUMERIC]
		once
			create Result.make (<<
				{INTEGER_8}, {INTEGER_16}, {INTEGER_32}, {INTEGER_64},
				{NATURAL_8}, {NATURAL_16}, {NATURAL_32}, {NATURAL_64},
				{REAL_32}, {REAL_64}
			>>)
		end

	frozen Other_collection_type_table: EL_REFLECTED_COLLECTION_TYPE_TABLE [ANY]
		once
			create Result.make (<< {BOOLEAN}, {CHARACTER_8}, {CHARACTER_32} >>)
		end

	frozen String_collection_type_table: EL_REFLECTED_COLLECTION_TYPE_TABLE [STRING_GENERAL]
		once
			create Result.make (<< {STRING_8}, {STRING_32}, {ZSTRING} >>)
		end

feature {EL_REFLECTION_HANDLER} -- Reference types

	frozen Boolean_ref_type_table: EL_REFLECTED_REFERENCE_TYPE_TABLE [EL_REFLECTED_BOOLEAN_REF]
		once
			create Result.make (<< {EL_REFLECTED_BOOLEAN_REF} >>)
		end

	frozen Makeable_from_string_type_table: EL_REFLECTED_REFERENCE_TYPE_TABLE [
		EL_REFLECTED_MAKEABLE_FROM_STRING [EL_MAKEABLE_FROM_STRING [STRING_GENERAL]]
	]
		once
			create Result.make (<<
				{EL_REFLECTED_MAKEABLE_FROM_ZSTRING},
				{EL_REFLECTED_MAKEABLE_FROM_STRING_8},
				{EL_REFLECTED_MAKEABLE_FROM_STRING_32}
			>>)
		end

	frozen String_convertable_type_table: EL_REFLECTED_REFERENCE_TYPE_TABLE [EL_REFLECTED_REFERENCE [ANY]]
		once
			create Result.make (<< {EL_REFLECTED_DATE_TIME}, {EL_REFLECTED_PATH}, {EL_REFLECTED_TUPLE} >>)
		end

	frozen String_type_table: EL_REFLECTED_REFERENCE_TYPE_TABLE [EL_REFLECTED_STRING_GENERAL [STRING_GENERAL]]
		once
			create Result.make (<< {EL_REFLECTED_STRING_8}, {EL_REFLECTED_STRING_32}, {EL_REFLECTED_ZSTRING} >>)
		end

	frozen Storable_type_table: EL_REFLECTED_STORABLE_REFERENCE_TYPE_TABLE
		once
			create Result.make
		end

end
