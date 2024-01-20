note
	description: "[
		Object whose expanded fields can be compactly represented as a single ${NATURAL_64} number
	]"
	notes: "[
		Using a compact date as an example the table manifest string can be formatted as follows:

			day:
				1 .. 8
			month:
				9 .. 16
			year:
				17 .. 32
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "6"

deferred class
	EL_COMPACTABLE_REFLECTIVE

inherit
	EL_REFLECTIVE
		rename
			field_included as is_expanded_field,
			foreign_naming as eiffel_naming
		export
			{EL_REFLECTED_FIELD_BIT_MASKS} field_table
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
			valid_masks: upper_bit <= 16
		do
			Result := field_masks.compact_value (Current).to_natural_16
		end

	compact_natural_32: NATURAL_32
		require
			valid_masks: upper_bit <= 32
		do
			Result := field_masks.compact_value (Current).to_natural_32
		end

	compact_natural_64: NATURAL_64
		do
			Result := field_masks.compact_value (Current)
		end

	compact_natural_8: NATURAL_8
		require
			valid_masks: upper_bit <= 8
		do
			Result := field_masks.compact_value (Current).to_natural_8
		end

feature -- INTEGER_x conversion

	compact_integer_16: INTEGER_16
		require
			valid_masks: upper_bit <= 16
		do
			Result := field_masks.compact_value (Current).to_integer_16
		end

	compact_integer_32: INTEGER_32
		require
			valid_masks: upper_bit <= 32
		do
			Result := field_masks.compact_value (Current).to_integer_32
		end

	compact_integer_64: INTEGER_64
		do
			Result := field_masks.compact_value (Current).to_integer_64
		end

	compact_integer_8: INTEGER_8
		require
			valid_masks: upper_bit <= 8
		do
			Result := field_masks.compact_value (Current).to_integer_8
		end

feature -- Measurement

	maximum_value: NATURAL_64
		do
			Result := field_masks.maximum_value
		end

	upper_bit: INTEGER
		do
			Result := field_masks.upper_bit
		end

feature -- Element change

	set_from_natural_64 (value: NATURAL_64)
		require
			fits_in_bit_mask_range: value <= maximum_value
		do
			field_masks.set_from_compact (Current, value)
		end

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

	set_from_natural_8 (value: NATURAL_8)
		do
			set_from_natural_64 (value)
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
		do
			Result := is_equal_except (other) -- {ANY}.is_equal
		end

feature {NONE} -- Deferred

	field_masks: EL_REFLECTED_FIELD_BIT_MASKS
		-- implement as once function with manifest string
		deferred
		end

end