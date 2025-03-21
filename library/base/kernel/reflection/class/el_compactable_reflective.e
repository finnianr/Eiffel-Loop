note
	description: "[
		Object whose expanded fields can be compactly represented as a single ${NATURAL_64} number
	]"
	instructions: "[
		Read notes for ${EL_ATTRIBUTE_RANGE_TABLE} and ${EL_ATTRIBUTE_BIT_RANGE_TABLE} for details
		on how to implement `Range_table' as once routine.
	]"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-21 10:23:28 GMT (Friday 21st March 2025)"
	revision: "10"

deferred class
	EL_COMPACTABLE_REFLECTIVE

inherit
	EL_REFLECTIVE
		rename
			field_included as is_expanded_field,
			foreign_naming as eiffel_naming
		export
			{EL_ATTRIBUTE_BIT_RANGE_TABLE} meta_data, field_table
		redefine
			is_equal
		end

feature {NONE} -- Initialization

	make_from_integer_16 (value: INTEGER_16)
		do
			set_from_natural_64 (value.to_natural_64)
		end

	make_from_integer_32 (value: INTEGER_32)
		do
			set_from_natural_64 (value.to_natural_64)
		end

	make_from_integer_64 (value: INTEGER_64)
		do
			set_from_natural_64 (value.to_natural_64)
		end

	make_from_integer_8 (value: INTEGER_8)
		do
			set_from_natural_64 (value.to_natural_64)
		end

	make_from_natural_16 (value: NATURAL_16)
		do
			set_from_natural_64 (value)
		end

	make_from_natural_32 (value: NATURAL_32)
		do
			set_from_natural_64 (value)
		end

	make_from_natural_64 (value: NATURAL_64)
		do
			set_from_natural_64 (value)
		end

	make_from_natural_8 (value: NATURAL_8)
		do
			set_from_natural_64 (value)
		end

feature -- NATURAL_x conversion

	compact_natural_16: NATURAL_16
		require
			valid_masks: upper_bit_index <= 16
		do
			Result := Range_table.compact_value (Current).to_natural_16
		end

	compact_natural_32: NATURAL_32
		require
			valid_masks: upper_bit_index <= 32
		do
			Result := Range_table.compact_value (Current).to_natural_32
		end

	compact_natural_64: NATURAL_64
		do
			Result := Range_table.compact_value (Current)
		end

	compact_natural_8: NATURAL_8
		require
			valid_masks: upper_bit_index <= 8
		do
			Result := Range_table.compact_value (Current).to_natural_8
		end

feature -- INTEGER_x conversion

	compact_integer_16: INTEGER_16
		require
			valid_masks: upper_bit_index <= 16
		do
			Result := Range_table.compact_value (Current).to_integer_16
		end

	compact_integer_32: INTEGER_32
		require
			valid_masks: upper_bit_index <= 32
		do
			Result := Range_table.compact_value (Current).to_integer_32
		end

	compact_integer_64: INTEGER_64
		do
			Result := Range_table.compact_value (Current).to_integer_64
		end

	compact_integer_8: INTEGER_8
		require
			valid_masks: upper_bit_index <= 8
		do
			Result := Range_table.compact_value (Current).to_integer_8
		end

feature -- Measurement

	maximum_value: NATURAL_64
		do
			Result := Range_table.maximum_value
		end

	upper_bit_index: INTEGER
		do
			Result := Range_table.upper_bit_index
		end

feature -- Element change

	set_from_integer_16 (value: INTEGER_16)
		do
			set_from_natural_64 (value.to_natural_64)
		end

	set_from_integer_32 (value: INTEGER_32)
		do
			set_from_natural_64 (value.to_natural_64)
		end

	set_from_integer_64 (value: INTEGER_64)
		do
			set_from_natural_64 (value.to_natural_64)
		end

	set_from_integer_8 (value: INTEGER_8)
		do
			set_from_natural_64 (value.to_natural_64)
		end

	set_from_natural_16 (value: NATURAL_16)
		do
			set_from_natural_64 (value)
		end

	set_from_natural_32 (value: NATURAL_32)
		do
			set_from_natural_64 (value)
		end

	set_from_natural_64 (value: NATURAL_64)
		require
			fits_in_bit_mask_range: value <= maximum_value
		do
			Range_table.set_from_compact (Current, value)
		end

	set_from_natural_8 (value: NATURAL_8)
		do
			set_from_natural_64 (value)
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
		do
			Result := is_equal_except (other) -- {ANY}.is_equal
		end

feature {NONE} -- Implementation

	range (lower, upper: INTEGER_64): EL_INTEGER_64_INTERVAL
		do
			create Result.make (lower, upper)
		end

feature {NONE} -- Deferred

	Range_table: EL_ATTRIBUTE_BIT_RANGE_TABLE
		-- implement as once function with manifest string
		deferred
		ensure
			initialized: Result.is_initialized
		end

note
	descendants: "[
			EL_COMPACTABLE_REFLECTIVE*
				${EL_FIREWALL_STATUS}
				${COMPACTABLE_DATE}
					${RANGE_COMPACTABLE_DATE}
				${EL_COMPACTABLE_EDITION*}
					${EL_SET_STRING_EDITION}
					${EL_REMOVE_TEXT_EDITION}
					${EL_CHARACTER_32_EDITION}
					${EL_INSERT_STRING_EDITION}
					${EL_REPLACE_SUBSTRING_EDITION}
	]"
end