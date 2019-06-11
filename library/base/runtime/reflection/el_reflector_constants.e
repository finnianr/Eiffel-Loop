note
	description: "Type constants for object reflection"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-11 14:42:06 GMT (Tuesday 11th June 2019)"
	revision: "20"

class
	EL_REFLECTOR_CONSTANTS

inherit
	REFLECTOR_CONSTANTS
		export
			{EL_REFLECTION_HANDLER} all
		end

feature {EL_REFLECTION_HANDLER} -- Constants

	frozen Makeable_type: INTEGER
		once
			Result := ({EL_MAKEABLE}).type_id
		end

	frozen Makeable_from_zstring_type: INTEGER
		once
			Result := ({EL_MAKEABLE_FROM_ZSTRING}).type_id
		end

	frozen Makeable_from_string_8_type: INTEGER
		once
			Result := ({EL_MAKEABLE_FROM_STRING_8}).type_id
		end

	frozen Makeable_from_string_32_type: INTEGER
		once
			Result := ({EL_MAKEABLE_FROM_STRING_32}).type_id
		end

	frozen Storable_type: INTEGER_32
		once
			Result := ({EL_STORABLE}).type_id
		end

	frozen Tuple_type: INTEGER_32
		once
			Result := ({TUPLE}).type_id
		end

	frozen Dir_path_type: INTEGER_32
		once
			Result := ({EL_FILE_PATH}).type_id
		end

	frozen Path_type: INTEGER_32
		once
			Result := ({EL_PATH}).type_id
		end

	frozen Boolean_ref_type: INTEGER_32
		once
			Result := ({EL_BOOLEAN_REF}).type_id
		end

	frozen Date_time_type: INTEGER_32
		once
			Result := ({EL_DATE_TIME}).type_id
		end

	frozen File_path_type: INTEGER_32
		once
			Result := ({EL_FILE_PATH}).type_id
		end

feature {EL_REFLECTION_HANDLER} -- Collection types

	frozen Numeric_collection_type_table: EL_REFLECTED_COLLECTION_TYPE_TABLE [NUMERIC]
		once
			create Result.make (<<
				{EL_COLLECTION_TYPE_ASSOCIATION [INTEGER_8]},
				{EL_COLLECTION_TYPE_ASSOCIATION [INTEGER_16]},
				{EL_COLLECTION_TYPE_ASSOCIATION [INTEGER_32]},
				{EL_COLLECTION_TYPE_ASSOCIATION [INTEGER_64]},

				{EL_COLLECTION_TYPE_ASSOCIATION [NATURAL_8]},
				{EL_COLLECTION_TYPE_ASSOCIATION [NATURAL_16]},
				{EL_COLLECTION_TYPE_ASSOCIATION [NATURAL_32]},
				{EL_COLLECTION_TYPE_ASSOCIATION [NATURAL_64]},

				{EL_COLLECTION_TYPE_ASSOCIATION [REAL_32]},
				{EL_COLLECTION_TYPE_ASSOCIATION [REAL_64]}
			>>)
		end

	frozen Other_collection_type_table: EL_REFLECTED_COLLECTION_TYPE_TABLE [ANY]
		once
			create Result.make (<<
				{EL_COLLECTION_TYPE_ASSOCIATION [BOOLEAN]},
				{EL_COLLECTION_TYPE_ASSOCIATION [CHARACTER_8]},
				{EL_COLLECTION_TYPE_ASSOCIATION [CHARACTER_32]}
			>>)
		end

	frozen String_collection_type_table: EL_REFLECTED_COLLECTION_TYPE_TABLE [STRING_GENERAL]
		once
			create Result.make (<<
				{EL_COLLECTION_TYPE_ASSOCIATION [STRING_8]},
				{EL_COLLECTION_TYPE_ASSOCIATION [STRING_32]},
				{EL_COLLECTION_TYPE_ASSOCIATION [ZSTRING]}
			>>)
		end

feature {EL_REFLECTION_HANDLER} -- Reference types

	frozen Makeable_from_string_type_table: EL_REFLECTED_REFERENCE_TYPE_TABLE [
		EL_REFLECTED_MAKEABLE_FROM_STRING [EL_MAKEABLE_FROM_STRING_GENERAL], EL_MAKEABLE_FROM_STRING_GENERAL
	]
		once
			create Result.make (<<
				[Makeable_from_zstring_type, {EL_REFLECTED_MAKEABLE_FROM_ZSTRING}],
				[Makeable_from_string_8_type, {EL_REFLECTED_MAKEABLE_FROM_STRING_8}],
				[Makeable_from_string_32_type, {EL_REFLECTED_MAKEABLE_FROM_STRING_32}]
			>>)
		end

	frozen String_convertable_type_table: EL_REFLECTED_REFERENCE_TYPE_TABLE [EL_REFLECTED_REFERENCE [ANY], ANY]
		once
			create Result.make (<<
				[Boolean_ref_type,						{EL_REFLECTED_BOOLEAN_REF}],
				[Date_time_type,							{EL_REFLECTED_DATE_TIME}],
				[Path_type,									{EL_REFLECTED_PATH}]
			>>)
		end

	frozen String_type_table: EL_REFLECTED_REFERENCE_TYPE_TABLE [
		EL_REFLECTED_STRING_GENERAL [STRING_GENERAL], STRING_GENERAL
	]
		once
			create Result.make (<<
				[String_8_type,	{EL_REFLECTED_STRING_8}],
				[String_32_type,	{EL_REFLECTED_STRING_32}],
				[String_z_type,	{EL_REFLECTED_ZSTRING}]
			>>)
		end

	frozen Storable_type_table: EL_REFLECTED_STORABLE_REFERENCE_TYPE_TABLE
		once
			create Result.make
		end

feature {EL_REFLECTION_HANDLER} -- String types

	frozen String_32_type: INTEGER
		once
			Result := ({STRING_32}).type_id
		end

	frozen String_z_type: INTEGER
		once
			Result := ({ZSTRING}).type_id
		end

	frozen String_8_type: INTEGER
		once
			Result := ({STRING}).type_id
		end

end
