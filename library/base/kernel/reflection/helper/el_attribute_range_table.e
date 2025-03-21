note
	description: "[
		An ${EL_ATTRIBUTE_BIT_RANGE_TABLE} object with the mask and bit-shift information calculated
		from range values supplied for each field using the field address operator '$'
	]"
	notes: "See end of class"
	instructions: "[
		A call to `initialize' must be made immediately after filling the table with entries
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-21 12:16:17 GMT (Friday 21st March 2025)"
	revision: "6"

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

	EL_REFLECTION_HANDLER

create
	default_create

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
						field_value := field_value + positive (i_th_offset)
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
			if attached object.field_list as field_list then
				from start until after loop
					if attached field_list.field_with_address (object, address_item) as field
						and then attached {EL_REFLECTED_EXPANDED_FIELD [ANY]} field as expanded_field
						and then attached as_range_64 (range_item) as range_64
					then
						bit_count := to_bit_count (range_64)
						bit_mask := b.filled_bits (bit_count) |<< bit_shift
						field_array.extend (expanded_field)
						field_bitshift.extend (bit_shift)
						field_mask.extend (bit_mask)
						field_offset.extend (range_64.lower_.to_natural_64)
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
			i: INTEGER; value, i_th_offset: NATURAL_64
		do
			if attached field_array as field and then attached field_bitshift as bitshift
				and then attached field_mask as mask and then attached field_offset as offset
			then
				from i := 0 until i = field.count loop
					i_th_offset := offset [i]
					value := (mask [i] & a_value) |>> bitshift [i]
					if is_negative (i_th_offset) then
						value := value - positive (i_th_offset)
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

	frozen positive (n: NATURAL_64): NATURAL_64
		do
			Result := (n - 1).bit_not
		end

	frozen as_range_64 (range: INTEGER_INTERVAL): TUPLE [lower_, upper_: INTEGER_64]
		do
			if attached {EL_INTEGER_64_INTERVAL} range as range_64 then
				Result := [range_64.lower, range_64.upper]
			else
				Result := [range.lower.to_integer_64, range.upper.to_integer_64]
			end
		end

	frozen to_bit_count (range: like as_range_64): INTEGER
		local
			b: EL_BIT_ROUTINES; lower, upper, maximum: NATURAL_64
		do
			lower := range.lower_.abs.to_natural_64
			upper := range.upper_.to_natural_64
			maximum := if range.lower_ >= 0 then upper - lower else upper + lower end
			Result := 64 - b.leading_zeros_count_64 (maximum)
		end

feature {NONE} -- Internal attributes

	field_offset: SPECIAL [NATURAL_64];
		-- offset to shift range.lower to zero

note
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

		**Large Values**

		To specify range values greater than ${INTEGER_32_REF}.Max_value use the `range' function
		defined as:

			range (lower, upper: INTEGER_64): EL_INTEGER_64_INTERVAL
				do
					create Result.make (lower, upper)
				end

	]"

end