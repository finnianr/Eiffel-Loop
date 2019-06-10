note
	description: "Type constants for object reflection"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-10 20:36:20 GMT (Monday 10th June 2019)"
	revision: "18"

class
	EL_REFLECTOR_CONSTANTS

inherit
	REFLECTOR_CONSTANTS
		export
			{EL_REFLECTION_HANDLER} all
		end

feature {EL_REFLECTION_HANDLER} -- Constants

	frozen Boolean_ref_type: INTEGER_32
		once
			Result := ({EL_BOOLEAN_REF}).type_id
		end

	frozen Date_time_type: INTEGER_32
		once
			Result := ({EL_DATE_TIME}).type_id
		end

	frozen Dir_path_type: INTEGER_32
		once
			Result := ({EL_FILE_PATH}).type_id
		end

	frozen File_path_type: INTEGER_32
		once
			Result := ({EL_FILE_PATH}).type_id
		end

	frozen Path_type: INTEGER_32
		once
			Result := ({EL_PATH}).type_id
		end

feature {NONE} -- Numeric collection types

	frozen Numeric_collection_type_table: EL_REFLECTED_REFERENCE_TYPE_TABLE [EL_REFLECTED_COLLECTION [NUMERIC], NUMERIC]
		once
			create Result.make (<<
				(create {EL_COLLECTION_TYPE [INTEGER_8]}).to_tuple,
				(create {EL_COLLECTION_TYPE [INTEGER_16]}).to_tuple,
				(create {EL_COLLECTION_TYPE [INTEGER_32]}).to_tuple,
				(create {EL_COLLECTION_TYPE [INTEGER_64]}).to_tuple,

				(create {EL_COLLECTION_TYPE [NATURAL_8]}).to_tuple,
				(create {EL_COLLECTION_TYPE [NATURAL_16]}).to_tuple,
				(create {EL_COLLECTION_TYPE [NATURAL_32]}).to_tuple,
				(create {EL_COLLECTION_TYPE [NATURAL_64]}).to_tuple,

				(create {EL_COLLECTION_TYPE [REAL_32]}).to_tuple,
				(create {EL_COLLECTION_TYPE [REAL_64]}).to_tuple
			>>)
		end

feature {NONE} -- Other collection types

	frozen Other_collection_type_table: EL_REFLECTED_REFERENCE_TYPE_TABLE [EL_REFLECTED_COLLECTION [ANY], ANY]
		once
			create Result.make (<<
				(create {EL_COLLECTION_TYPE [BOOLEAN]}).to_tuple,
				(create {EL_COLLECTION_TYPE [CHARACTER_8]}).to_tuple,
				(create {EL_COLLECTION_TYPE [CHARACTER_32]}).to_tuple
			>>)
		end

feature {NONE} -- String collection types

	frozen String_collection_type_table: EL_REFLECTED_REFERENCE_TYPE_TABLE [
		EL_REFLECTED_COLLECTION [STRING_GENERAL], COLLECTION [STRING_GENERAL]
	]
		once
			create Result.make (<<
				(create {EL_COLLECTION_TYPE [STRING_8]}).to_tuple,
				(create {EL_COLLECTION_TYPE [STRING_32]}).to_tuple,
				(create {EL_COLLECTION_TYPE [ZSTRING]}).to_tuple
			>>)
		end

	String_convertable_type_table: EL_REFLECTED_REFERENCE_TYPE_TABLE [EL_REFLECTED_REFERENCE [ANY], ANY]
		once
			create Result.make (<<
				[String_general_type,					{EL_REFLECTED_STRING_GENERAL}],
				[Boolean_ref_type,						{EL_REFLECTED_BOOLEAN_REF}],
				[Date_time_type,							{EL_REFLECTED_DATE_TIME}],
				[Path_type,									{EL_REFLECTED_PATH}],
				[Makeable_from_string_general_type, {EL_REFLECTED_MAKEABLE_FROM_STRING_GENERAL}]
			>>)
		ensure
			makeable_from_string_general_type_is_last:
				Result.type_array [Result.count] = Makeable_from_string_general_type
		end

feature {NONE} -- String types

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
			Result := ({ZSTRING}).type_id
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
