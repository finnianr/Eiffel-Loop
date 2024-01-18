note
	description: "Implementation details for ${EL_STRING_CONVERSION_TABLE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-18 14:35:24 GMT (Saturday 18th November 2023)"
	revision: "2"

deferred class
	EL_STRING_CONVERSION_TABLE_IMPLEMENTATION

inherit
	REFLECTOR_CONSTANTS
		export
			{NONE} all
		end

	EL_MODULE_EIFFEL; EL_MODULE_NAMING

	EL_MODULE_TUPLE
		rename
			Tuple as Mod_tuple
		end

	EL_SHARED_CLASS_ID; EL_SHARED_FACTORIES

	EL_SHARED_STRING_8_BUFFER_SCOPES; EL_SHARED_STRING_32_BUFFER_SCOPES

	EL_SHARED_ZSTRING_BUFFER_SCOPES

	STRING_HANDLER

feature {NONE} -- Initialization

	make_implementation
		do
			create boolean_8_converter.make

			create character_8_converter.make
			create character_32_converter.make

			create integer_8_converter.make
			create integer_16_converter.make
			create integer_32_converter.make
			create integer_64_converter.make

			create natural_8_converter.make
			create natural_16_converter.make
			create natural_32_converter.make
			create natural_64_converter.make

			create real_32_converter.make
			create real_64_converter.make

			create split_list_area.make_filled (new_split_list ('1'), 3)
			split_list_area [1] := new_split_list ('4')
			split_list_area [2] := new_split_list ('X')
		end

feature {NONE} -- Implementation

	converter_types: TUPLE [
			EL_STRING_TO_INTEGER_8,
			EL_STRING_TO_INTEGER_16,
			EL_STRING_TO_INTEGER_32,
			EL_STRING_TO_INTEGER_64,

			EL_STRING_TO_NATURAL_8,
			EL_STRING_TO_NATURAL_16,
			EL_STRING_TO_NATURAL_32,
			EL_STRING_TO_NATURAL_64,

			EL_STRING_TO_REAL_32,
			EL_STRING_TO_REAL_64,

			EL_STRING_TO_BOOLEAN,
			EL_STRING_TO_CHARACTER_8,
			EL_STRING_TO_CHARACTER_32,

			EL_STRING_TO_STRING_8, EL_STRING_TO_STRING_32, EL_STRING_TO_ZSTRING,
			EL_STRING_TO_IMMUTABLE_STRING_8, EL_STRING_TO_IMMUTABLE_STRING_32,

			EL_STRING_TO_DIR_PATH, EL_STRING_TO_FILE_PATH,
			EL_STRING_TO_DIR_URI_PATH, EL_STRING_TO_FILE_URI_PATH
	]
		do
			create Result
		end

	filled_split_list (
		csv_list: READABLE_STRING_GENERAL; separator: CHARACTER_32; adjustments: INTEGER
	): like new_split_list
		-- reusable split list
		do
			inspect Class_id.character_bytes (csv_list)
				when '1' then
					Result := split_list_area [0]
				when '4' then
					Result := split_list_area [1]
				when 'X' then
					Result := split_list_area [2]
			end
			Result.fill_general (csv_list, separator, adjustments)
		end

	new_expanded_table: HASH_TABLE [EL_READABLE_STRING_GENERAL_TO_TYPE [ANY], TYPE [ANY]]
		local
			current_object: REFLECTED_REFERENCE_OBJECT; i, type_id: INTEGER
		do
			create Result.make (20)
			create current_object.make (Current)
			from i := 1 until i > current_object.field_count loop
				type_id := current_object.field_static_type (i)
				if {ISE_RUNTIME}.type_conforms_to (type_id, Converter_base_id)
					and then attached current_object.reference_field (i) as ref
					and then attached {EL_READABLE_STRING_GENERAL_TO_TYPE [ANY]} ref as converter
				then
					Result.extend (converter, converter.generating_type)
				end
				i := i + 1
			end
		end

	new_split_list (character_width_code: CHARACTER): EL_SPLIT_READABLE_STRING_LIST [READABLE_STRING_GENERAL]
		require
			valid_code: Class_id.valid_character_byte_codes.has (character_width_code)
		do
			inspect character_width_code
				when '1' then
					create {EL_SPLIT_IMMUTABLE_STRING_8_LIST} Result.make_empty
				when '4' then
					create {EL_SPLIT_IMMUTABLE_STRING_32_LIST} Result.make_empty
				when 'X' then
					create {EL_SPLIT_ZSTRING_LIST} Result.make_empty
			end
		end

	readable_string: READABLE_STRING_GENERAL
		do
			Result := ""
		end

feature {NONE} -- Internal attributes

	boolean_8_converter: EL_STRING_TO_BOOLEAN

	character_32_converter: EL_STRING_TO_CHARACTER_32

	character_8_converter: EL_STRING_TO_CHARACTER_8

	integer_16_converter: EL_STRING_TO_INTEGER_16

	integer_32_converter: EL_STRING_TO_INTEGER_32

	integer_64_converter: EL_STRING_TO_INTEGER_64

	integer_8_converter: EL_STRING_TO_INTEGER_8

	natural_16_converter: EL_STRING_TO_NATURAL_16

	natural_32_converter: EL_STRING_TO_NATURAL_32

	natural_64_converter: EL_STRING_TO_NATURAL_64

	natural_8_converter: EL_STRING_TO_NATURAL_8

	real_32_converter: EL_STRING_TO_REAL_32

	real_64_converter: EL_STRING_TO_REAL_64

	split_list_area: SPECIAL [like new_split_list]

feature {NONE} -- Constants

	Converter_base_id: INTEGER
		once
			Result := ({EL_READABLE_STRING_GENERAL_TO_TYPE [ANY]}).type_id
		end

end