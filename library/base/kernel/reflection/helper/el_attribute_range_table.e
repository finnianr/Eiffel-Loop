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
	date: "2025-04-19 11:41:38 GMT (Saturday 19th April 2025)"
	revision: "8"

class
	EL_ATTRIBUTE_RANGE_TABLE

inherit
	EL_ATTRIBUTE_BIT_RANGE_TABLE
		rename
			make as make_masks
		redefine
			compact_value, make_field_arrays, set_from_compact
		end

	EL_REFLECTION_HANDLER

create
	make

feature {NONE} -- Initialization

	make (field_list: EL_FIELD_LIST)
		-- make with `field_list' of object implementing EL_COMPACTABLE_REFLECTIVE
		do
			create field_range_map.make (field_list.count)
			make_field_arrays (0)
		end

	make_field_arrays (n: INTEGER)
		do
			Precursor (n)
			create field_offset.make_empty (n)
		end

feature -- Measurement

	count: INTEGER
		do
			Result := field_range_map.count
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

	initialize
		require
			all_fields_set: all_fields_set
		local
			bit_count, bit_shift: INTEGER; bit_mask: NATURAL_64; b: EL_NATURAL_64_BIT_ROUTINES
		do
			make_field_arrays (count)
			if attached field_range_map as list then
				from list.start until list.after loop
					if attached list.item_key as expanded_field and then attached list.item_value as range_64 then
						bit_count := to_bit_count (range_64)
						bit_mask := b.filled_bits (bit_count) |<< bit_shift
						field_array.extend (expanded_field)
						field_bitshift.extend (bit_shift)
						field_mask.extend (bit_mask)
						field_offset.extend (range_64.lower.to_natural_64)
						bit_shift := bit_shift + bit_count
					end
					list.forth
				end
			end
			is_initialized := True
			create field_range_map.make (0) -- recover area memory
		ensure
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

feature -- Element change

	set_32 (a_field: detachable like field_array.item; lower, upper: INTEGER)
		require
			attached_field: a_field /= Void
		do
			set_64 (a_field, lower.to_integer_64, upper.to_integer_64)
		end

	set_64 (a_field: detachable like field_array.item; lower, upper: INTEGER_64)
		require
			attached_field: a_field /= Void
		do
			if attached a_field as field then
				field_range_map.extend (field, create {EL_INTEGER_64_INTERVAL}.make (lower, upper))
			end
		end

feature -- Contract Support

	all_fields_set: BOOLEAN
		do
			Result := field_range_map.full
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

	frozen to_bit_count (range: EL_INTEGER_64_INTERVAL): INTEGER
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

	field_range_map: EL_ARRAYED_MAP_LIST [EL_REFLECTED_EXPANDED_FIELD [ANY], EL_INTEGER_64_INTERVAL];

note
	notes: "[
		**Date Example**

			class DATE inherit EL_COMPACTABLE_REFLECTIVE

			feature {NONE} -- Constants

				Range_table: EL_ATTRIBUTE_RANGE_TABLE
					once
						create Result.make (field_list)
						Result.set_32 (field ($day), 1, 31)
						Result.set_32 (field ($month), 1, 12)
						Result.set_64 (field ($year), -100_000, 100_000)
						Result.initialize
					end

		**Large Values**

		To specify range values greater than ${INTEGER_32_REF}.Max_value use the `set_64' routine
	]"

end