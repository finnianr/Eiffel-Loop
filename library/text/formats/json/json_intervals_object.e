note
	description: "[
		List of JSON parsed string value substring intervals indexed by cached field:
		[$source EL_ENUMERATION [NATURAL_16]]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-08 9:56:37 GMT (Wednesday 8th November 2023)"
	revision: "15"

class
	JSON_INTERVALS_OBJECT [FIELD_ENUM -> EL_ENUMERATION_NATURAL_16 create make end]

inherit
	EL_SEQUENTIAL_INTERVALS
		rename
			make as make_intervals,
			index as substring_index
		export
			{NONE} all
		end

	EL_MODULE_EIFFEL

	EL_SHARED_ZSTRING_BUFFER_SCOPES

create
	make

feature {NONE} -- Initialization

	make (utf_8: READABLE_STRING_8)
		require
			new_line_delimited: utf_8.has ('%N')
		local
			field_list: JSON_NAME_VALUE_LIST; field_index, text_count: INTEGER
		do
			area_v2 := Default_area -- To satisfy invariant

			if attached {FIELD_ENUM} Enumeration_by_type.item (Current) as enumeration then
				field := enumeration
				make_filled_area (0, field.count * 2)
			end
			create field_list.make (utf_8)
			across String_scope as scope loop
				if attached scope.item as text then
					from field_list.start until field_list.after loop
						if field.has_name (field_list.item_immutable_name) then
							text_count := text.count
							field_index := field.found_value
							text.append_utf_8 (field_list.item_immutable_value)
							put_i_th (text_count + 1, text.count, field_index)
						end
						field_list.forth
					end
					text_values := text.twin
				end
			end
		end

feature -- Measurement

	physical_size: INTEGER
		do
			-- `field' enumeration is not included because it is shared across objects
			Result := Eiffel.physical_size (Current) + Eiffel.deep_physical_size (text_values)
							+ Eiffel.deep_physical_size (area_v2)
		end

feature {JSON_INTERVALS_OBJECT} -- Factory

	new_enumeration: EL_ENUMERATION_NATURAL_16
		do
			create {FIELD_ENUM} Result.make
		end

feature {NONE} -- Implementation

	boolean_value (i: NATURAL_16): BOOLEAN
		require
			valid_index: valid_index (i)
		do
			Result := buffer_string_value (i).to_boolean
		end

	real_32_value, real_value (i: NATURAL_16): REAL
		require
			valid_index: valid_index (i)
		do
			Result := buffer_string_value (i).to_real
		end

	real_64_value, double_value (i: NATURAL_16): DOUBLE
		require
			valid_index: valid_index (i)
		do
			Result := buffer_string_value (i).to_double
		end

	natural_value, natural_32_value (i: NATURAL_16): NATURAL
		require
			valid_index: valid_index (i)
		do
			Result := buffer_string_value (i).to_natural
		end

	string_8_value (i: NATURAL_16): STRING
		require
			valid_index: valid_index (i)
		local
			buffer_8: EL_STRING_8_BUFFER_ROUTINES
		do
			Result := buffer_8.copied (buffer_string_value (i).to_latin_1).twin
		end

	string_value (i: NATURAL_16): ZSTRING
		require
			valid_index: valid_index (i)
		local
			j: INTEGER
		do
			if attached area_v2 as a then
				j := (i - 1) * 2
				Result := text_values.substring (a [j], a [j + 1])
			else
				create Result.make_empty
			end
		end

	buffer_string_value (i: NATURAL_16): ZSTRING
		require
			valid_index: valid_index (i)
		local
			buffer: EL_ZSTRING_BUFFER_ROUTINES; j: INTEGER
		do
			if attached area_v2 as a then
				j := (i - 1) * 2
				Result := buffer.copied_substring (text_values, a [j], a [j + 1])
			else
				create Result.make_empty
			end
		end

feature {NONE} -- Internal attributes

	field: FIELD_ENUM

	text_values: ZSTRING

feature {NONE} -- Constants

	Default_area: SPECIAL [INTEGER]
		once
			create Result.make_empty (0)
		end

	Enumeration_by_type: EL_FUNCTION_RESULT_TABLE [
		JSON_INTERVALS_OBJECT [EL_ENUMERATION_NATURAL_16], EL_ENUMERATION_NATURAL_16
	]
		once
			create Result.make (11, agent {JSON_INTERVALS_OBJECT [EL_ENUMERATION_NATURAL_16]}.new_enumeration)
		end

end