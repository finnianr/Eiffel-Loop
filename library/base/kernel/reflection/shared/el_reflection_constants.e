note
	description: "Type constants for object reflection"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-26 14:47:16 GMT (Monday 26th December 2022)"
	revision: "46"

deferred class
	EL_REFLECTION_CONSTANTS

inherit
	REFLECTOR_CONSTANTS
		undefine
			copy, is_equal, default_create
		end

feature {NONE} -- Implementation

	reflected_reference_types: TUPLE [
		EL_REFLECTED_BOOLEAN_REF,

		EL_REFLECTED_COLLECTION [BOOLEAN], EL_REFLECTED_COLLECTION [POINTER],
		EL_REFLECTED_COLLECTION [CHARACTER_8], EL_REFLECTED_COLLECTION [CHARACTER_32],

		EL_REFLECTED_COLLECTION [NATURAL_8], EL_REFLECTED_COLLECTION [NATURAL_16],
		EL_REFLECTED_COLLECTION [NATURAL_32], EL_REFLECTED_COLLECTION [NATURAL_64],

		EL_REFLECTED_COLLECTION [INTEGER_8], EL_REFLECTED_COLLECTION [INTEGER_16],
		EL_REFLECTED_COLLECTION [INTEGER_32], EL_REFLECTED_COLLECTION [INTEGER_64],

		EL_REFLECTED_COLLECTION [REAL_32], EL_REFLECTED_COLLECTION [REAL_64],

		EL_REFLECTED_DATE, EL_REFLECTED_DATE_TIME,
		EL_REFLECTED_IMMUTABLE_STRING_8, EL_REFLECTED_IMMUTABLE_STRING_32,
		EL_REFLECTED_MAKEABLE_FROM_STRING_8, EL_REFLECTED_MAKEABLE_FROM_STRING_32,
		EL_REFLECTED_MAKEABLE_FROM_ZSTRING,
		EL_REFLECTED_MANAGED_POINTER,
		EL_REFLECTED_PATH,
		EL_REFLECTED_STORABLE,
		EL_REFLECTED_STRING_8, EL_REFLECTED_STRING_32,
		EL_REFLECTED_TIME,
		EL_REFLECTED_TUPLE,
		EL_REFLECTED_URI [EL_URL], EL_REFLECTED_URI [EL_URI],
		EL_REFLECTED_ZSTRING
	]
		-- Types conforming to `EL_REFLECTED_REFERENCE'
		do
			create Result
		end

feature {NONE} -- Factories

	Collection_field_factory_factory: EL_INITIALIZED_OBJECT_FACTORY [
		EL_REFLECTED_COLLECTION_FACTORY [ANY, EL_REFLECTED_COLLECTION [ANY]], EL_REFLECTED_COLLECTION [ANY]
	]
		once
			create Result
		end

	Makeable_reader_writer_factory_factory: EL_INITIALIZED_OBJECT_FACTORY [
		EL_MAKEABLE_READER_WRITER_FACTORY [EL_MAKEABLE, EL_MAKEABLE_READER_WRITER [EL_MAKEABLE]],
		EL_MAKEABLE_READER_WRITER [EL_MAKEABLE]
	]
		once
			create Result
		end

	Reflectively_settable_factory: EL_INITIALIZED_OBJECT_FACTORY [
		EL_REFLECTIVELY_SETTABLE_FACTORY [EL_REFLECTIVELY_SETTABLE], EL_REFLECTIVELY_SETTABLE
	]
		once
			create Result
		end

feature {NONE} -- Reference types

	Group_type_order_table: EL_HASH_TABLE [INTEGER, TYPE [ANY]]
		-- Defines search order for matching `value_type' in groups
		once
			create Result.make (<<
				[{EL_MAKEABLE_FROM_STRING [STRING_GENERAL]}, 16],
				[{COLLECTION [ANY]}, 14],
				[{EL_STORABLE}, 12],
				[{READABLE_STRING_GENERAL}, 10],
				[{EL_URI}, 8], -- Must be higher priority than READABLE_STRING_GENERAL
				[{ABSOLUTE}, 6] -- Date and time classes
			>>)
		end

	Non_abstract_field_type_table: HASH_TABLE [TYPE [EL_REFLECTED_REFERENCE [ANY]], INTEGER]
		once
			Result := Reference_field_list.non_abstract_type_table
		end

	Reference_field_list: EL_REFLECTED_REFERENCE_LIST
		once
			create Result.make (reflected_reference_types)
		end

	frozen Standard_field_types: ARRAY [TYPE [EL_REFLECTED_FIELD]]
		-- standard expanded types
		once
			create Result.make_filled ({EL_REFLECTED_CHARACTER_8}, 0, 16)
				-- Characters
				Result [Character_8_type] := {EL_REFLECTED_CHARACTER_8}
				Result [Character_32_type] := {EL_REFLECTED_CHARACTER_32}

				-- Integers
				Result [Integer_8_type] := {EL_REFLECTED_INTEGER_8}
				Result [Integer_16_type] := {EL_REFLECTED_INTEGER_16}
				Result [Integer_32_type] := {EL_REFLECTED_INTEGER_32}
				Result [Integer_64_type] := {EL_REFLECTED_INTEGER_64}

				-- Naturals
				Result [Natural_8_type] := {EL_REFLECTED_NATURAL_8}
				Result [Natural_16_type] := {EL_REFLECTED_NATURAL_16}
				Result [Natural_32_type] := {EL_REFLECTED_NATURAL_32}
				Result [Natural_64_type] := {EL_REFLECTED_NATURAL_64}

				-- Reals
				Result [Real_32_type] := {EL_REFLECTED_REAL_32}
				Result [Real_64_type] := {EL_REFLECTED_REAL_64}

				-- Others
				Result [Boolean_type] := {EL_REFLECTED_BOOLEAN}
				Result [Pointer_type] := {EL_REFLECTED_POINTER}
			end

	String_reference_types: EL_ARRAYED_LIST [INTEGER]
		once
			Result := Reference_field_list.string_type_id_list
		end

	Storable_reference_types: EL_ARRAYED_LIST [INTEGER]
		once
			Result := Reference_field_list.storable_types
		end

end