note
	description: "[
		An ${EL_ATTRIBUTE_BIT_RANGE_TABLE} object with the mask and bit-shift information calculated
		from range values supplied for each field using the field address operator '$'
	]"
	notes: "[
		**Date Example**
		
			class DATE inherit EL_COMPACTABLE_REFLECTIVE

			feature {NONE} -- Constants

				Range_table: EL_ATTRIBUTE_RANGE_TABLE
					once
						create Result
						Result [$day] := 1 |..| 31
						Result [$month] := 1 |..| 12
						Result [$year] := -100_000 |..| 100_000
						Result.initialize (Current)
					end
			end
	]"
	instructions: "[
		A call to `initialize' must be made immediately after filling the table with entries
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-10-13 17:33:52 GMT (Sunday 13th October 2024)"
	revision: "1"

class
	EL_ATTRIBUTE_RANGE_TABLE

inherit
	EL_ATTRIBUTE_BIT_RANGE_TABLE
		rename
			make as make_masks
		undefine
			copy, default_create, is_equal
		redefine
			compact_value, make_field_arrays, set_from_compact
		end

	EL_HASH_TABLE [INTEGER_INTERVAL, TYPED_POINTER [ANY]]
		rename
			key_for_iteration as address_item,
			item_for_iteration as range_item
		export
			{NONE} all
			{ANY} valid_key, force
		redefine
			make_equal
		end

create
	default_create, make_assignments

feature {NONE} -- Initialization

	make_equal (n: INTEGER)
		do
			Precursor (n)
			make_field_arrays (0)
		end

	make_field_arrays (n: INTEGER)
		do
			Precursor (n)
			create field_offset.make_empty (n)
		end

feature -- Access

	compact_value (object: EL_COMPACTABLE_REFLECTIVE): NATURAL_64
		local
			i: INTEGER; field_value, i_th_offset: NATURAL_64
		do
			if attached field_array as field and then attached field_bitshift as bitshift
				and then attached field_offset as offset
			then
				from i := 0 until i = field.count loop
					field_value := field [i].to_natural_64 (object)
					i_th_offset := offset [i]
					if is_negative (i_th_offset) then
						field_value := field_value + (i_th_offset - 1).bit_not
					else
						field_value := field_value - i_th_offset
					end
					check
						mask_wide_enough: mask_wide_enough (i, field_value)
					end
					Result := Result | (field_value |<< bitshift [i])
					i := i + 1
				end
			end
		end

feature -- Basic operations

	initialize (object: EL_COMPACTABLE_REFLECTIVE)
		local
			bit_count, bit_shift: INTEGER; bit_mask: NATURAL_64
			b: EL_NATURAL_64_BIT_ROUTINES
		do
			make_field_arrays (count)
			if attached object.field_table as table then
				from start until after loop
					if table.has_address (object, address_item)
						and then attached {EL_REFLECTED_EXPANDED_FIELD [ANY]} table.found_item as field
					then
						bit_count := to_bit_count (range_item)
						bit_mask := b.filled_bits (bit_count) |<< bit_shift
						field_array.extend (field)
						field_bitshift.extend (bit_shift)
						field_mask.extend (bit_mask)
						field_offset.extend (range_item.lower.to_natural_64)
						bit_shift := bit_shift + bit_count
					end
					forth
				end
			end
			is_initialized := object.field_table.count = field_array.count
		ensure
			initialized: is_initialized
			no_masks_overlap: no_masks_overlap
		end

	set_from_compact (object: EL_COMPACTABLE_REFLECTIVE; a_value: NATURAL_64)
		local
			i: INTEGER; value, i_th_offset: NATURAL_64; is_positive: BOOLEAN
		do
			if attached field_array as field and then attached field_bitshift as bitshift
				and then attached field_mask as mask and then attached field_offset as offset
			then
				from i := 0 until i = field.count loop
					i_th_offset := offset [i]
					value := (mask [i] & a_value) |>> bitshift [i]
					if is_negative (i_th_offset) then
						value := value - (i_th_offset - 1).bit_not
					else
						value := value + i_th_offset
					end
					field [i].set_from_natural_64 (object, value)
					i := i + 1
				end
			end
		end

feature {NONE} -- Implementation

	frozen is_negative (n: NATURAL_64): BOOLEAN
		do
			Result := (n |>> 63).to_boolean
		end

	frozen to_bit_count (range: INTEGER_INTERVAL): INTEGER
		local
			b: EL_BIT_ROUTINES; lower, upper, maximum: NATURAL_64
		do
			lower := range.lower.abs.to_natural_64
			upper := range.upper.to_natural_64
			maximum := if range.lower >= 0 then upper - lower else upper + lower end
			Result := 64 - b.leading_zeros_count_64 (maximum)
		end

feature {NONE} -- Internal attributes

	field_offset: SPECIAL [NATURAL_64]
		-- offset to shift range.lower to zero

end