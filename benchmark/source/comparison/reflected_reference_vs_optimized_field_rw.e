note
	description: "[
		Compare optimized way of field read/write by reflection to the original
		implementation of ${EL_REFLECTED_FIELD}
	]"
	notes: "[
		For basic getting/setting fields the original implementation of ${EL_REFLECTED_INTEGER_32} was
		97% slower than the current optimized version.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-16 17:15:28 GMT (Thursday 16th November 2023)"
	revision: "2"

class
	REFLECTED_REFERENCE_VS_OPTIMIZED_FIELD_RW

inherit
	EL_BENCHMARK_COMPARISON

	EL_REFLECTIVE
		rename
			field_included as is_expanded_field,
			foreign_naming as eiffel_naming
		end

create
	make

feature -- Access

	Description: STRING = "Compare optimized way of field read/write by reflection"

feature -- Basic operations

	execute
		local
			field: EL_REFLECTED_INTEGER_32
		do
			field_index := -1
			across field_table as table until field_index >= 0 loop
				if table.item.name.same_string ("integer_value")
					and then attached {EL_REFLECTED_INTEGER_32} table.item as item
				then
					field := item
					field_index := field.index
				end
			end
			compare ("Test get/set on integers 1 to 1000", <<
				["class EL_REFLECTED_INTEGER_32", agent use_reflected_integer_field (field)],
				["Optimized get/set routine",		 agent use_optimized_field_setting]
			>>)
		end

feature {NONE} -- Implementation

	get_integer (object: EL_REFLECTIVE): INTEGER
		do
			Result := {ISE_RUNTIME}.integer_32_field (
				field_index, {ISE_RUNTIME}.raw_reference_field_at_offset ($object, 0), 0
			)
		end

	set_integer (object: EL_REFLECTIVE; value: INTEGER)
		do
			{ISE_RUNTIME}.set_integer_32_field (
				field_index, {ISE_RUNTIME}.raw_reference_field_at_offset ($object, 0), 0, value
			)
		end

feature {NONE} -- Target routines

	use_optimized_field_setting
		local
			i: INTEGER; failed: BOOLEAN
		do
			from i := 1 until failed or i > 1000 loop
				set_integer (Current, i)
				if get_integer (Current) /= i then
					failed := True
				end
				i := i + 1
			end
			if failed then
				lio.put_line ("Get value not equal set value")
			end
		end

	use_reflected_integer_field (field: EL_REFLECTED_INTEGER_32)
		local
			i: INTEGER; failed: BOOLEAN
		do
			from i := 1 until failed or i > 1000 loop
				field.set (Current, i)
				if field.value (Current) /= i then
					failed := True
				end
				i := i + 1
			end
			if failed then
				lio.put_line ("Get value not equal set value")
			end
		end

feature {NONE} -- Internal attributes

	field_index: INTEGER

	integer_value: INTEGER

end