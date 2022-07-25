note
	description: "Type constants for object reflection"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-07-25 5:15:10 GMT (Monday 25th July 2022)"
	revision: "37"

class
	EL_REFLECTION_CONSTANTS

feature {NONE} -- Reference types

	frozen Boolean_ref_type_table: EL_REFLECTED_REFERENCE_TYPE_TABLE [EL_REFLECTED_BOOLEAN_REF]
		once
			create Result.make (<< {EL_REFLECTED_BOOLEAN_REF} >>)
		end

	frozen Collection_type_table: EL_REFLECTED_COLLECTION_TYPE_TABLE
		once
			create Result.make
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
			create Result.make (<<
				{EL_REFLECTED_DATE_TIME}, {EL_REFLECTED_DATE}, {EL_REFLECTED_PATH}, {EL_REFLECTED_TUPLE},
				{EL_REFLECTED_MANAGED_POINTER}
			>>)
		end

	frozen String_type_table: EL_REFLECTED_REFERENCE_TYPE_TABLE [EL_REFLECTED_STRING [READABLE_STRING_GENERAL]]
		once
			create Result.make (<<
				{EL_REFLECTED_URI}, {EL_REFLECTED_IMMUTABLE_STRING_8},
				{EL_REFLECTED_STRING_8}, {EL_REFLECTED_STRING_32}, {EL_REFLECTED_ZSTRING}
			>>)
		ensure
			uri_before_string_8: across Result as reflected some
											reflected.item ~ {EL_REFLECTED_URI} implies reflected.cursor_index = 1
										end
		end

	frozen Storable_type_table: EL_REFLECTED_STORABLE_REFERENCE_TYPE_TABLE
		once
			create Result.make
		end

end