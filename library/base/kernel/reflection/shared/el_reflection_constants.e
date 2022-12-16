note
	description: "Type constants for object reflection"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-16 8:34:42 GMT (Friday 16th December 2022)"
	revision: "43"

deferred class
	EL_REFLECTION_CONSTANTS

inherit
	REFLECTOR_CONSTANTS
		undefine
			copy, is_equal, default_create
		end

	EL_SHARED_FACTORIES

feature {NONE} -- Implementation

	reflected_reference_types: TUPLE [
		EL_REFLECTED_BOOLEAN_REF,
		EL_REFLECTED_DATE, EL_REFLECTED_DATE_TIME,
		EL_REFLECTED_IMMUTABLE_STRING_8, EL_REFLECTED_IMMUTABLE_STRING_32,
		EL_REFLECTED_MAKEABLE_FROM_STRING_8, EL_REFLECTED_MAKEABLE_FROM_STRING_32,
		EL_REFLECTED_MAKEABLE_FROM_ZSTRING,
		EL_REFLECTED_MANAGED_POINTER,
		EL_REFLECTED_PATH,
		EL_REFLECTED_STORABLE,
		EL_REFLECTED_STRING_8, EL_REFLECTED_STRING_32,
		EL_REFLECTED_TUPLE,
		EL_REFLECTED_URI [EL_URL], EL_REFLECTED_URI [EL_URI],
		EL_REFLECTED_ZSTRING
	]
		-- Types conforming to `EL_REFLECTED_REFERENCE'
		do
			create Result
		end

	new_reference_field_list (type_tuple: TUPLE): like Reference_field_list
		local
			type_list: EL_TUPLE_TYPE_ARRAY
		do
			create type_list.make_from_tuple (type_tuple)
			create Result.make (type_list.count)
			across type_list as list loop
				if attached {EL_REFLECTED_REFERENCE [ANY]}
					Default_factory.new_item_from_type_id (list.item.type_id) as new
				then
					Result.extend (new)
				end
			end
		end

feature {NONE} -- Reference types

	Group_type_order_table: EL_HASH_TABLE [INTEGER, TYPE [ANY]]
		-- Defines search order for matching `value_type' in groups
		once
			create Result.make (<<
				[{EL_MAKEABLE_FROM_STRING [STRING_GENERAL]}, 14],
				[{EL_STORABLE}, 12],
				[{READABLE_STRING_GENERAL}, 10],
				[{EL_URI}, 8], -- Must be higher priority than READABLE_STRING_GENERAL
				[{ABSOLUTE}, 6] -- Date and time classes
			>>)
		end

	Non_abstract_field_type_table: HASH_TABLE [TYPE [EL_REFLECTED_REFERENCE [ANY]], INTEGER]
		once
			create Result.make (Reference_field_list.count)
			across Reference_field_list as list loop
				if not list.item.is_abstract then
					Result.extend (list.item.generating_type, list.item.value_type.type_id)
				end
			end
		end

	Reference_field_list: EL_ARRAYED_LIST [EL_REFLECTED_REFERENCE [ANY]]
		once
			Result := new_reference_field_list (reflected_reference_types)
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
			create Result.make (10)
			across Reference_field_list as list loop
				if attached {EL_REFLECTED_STRING [READABLE_STRING_GENERAL]} list.item then
					Result.extend (list.item.value_type.type_id)
				end
			end
		end

	Storable_reference_types: EL_ARRAYED_LIST [INTEGER]
		once
			create Result.make (Reference_field_list.count)
			across Reference_field_list as list loop
				if list.item.is_storable_type then
					Result.extend (list.item.value_type.type_id)
				end
			end
		end

end