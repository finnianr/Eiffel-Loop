note
	description: "Time routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-26 14:41:59 GMT (Monday 26th December 2022)"
	revision: "12"

expanded class
	EL_TIME_ROUTINES

feature -- Status query

	is_valid (time_str: STRING): BOOLEAN
		local
			parts: LIST [STRING]
		do
			if time_str.count >= 4 then
				parts := time_str.split (':')
				if parts.count = 2 and then across parts as part all part.item.is_integer end then
					Result := True
				end
			end
		end

	is_valid_fine (fine_time_str: STRING): BOOLEAN
			-- True if 'fine_time_str' conforms to mm:ss:ff3
			-- Eg. 1:02.555
		local
			parts: LIST [STRING]; mins, secs: STRING
		do
			parts := fine_time_str.split (':')
			if parts.count = 2 then
				mins := parts [1]; secs := parts [2]
				secs.prune_all_leading ('0')
				Result := mins.is_integer and secs.is_real
			end
		end

	same_time (t1, t2: TIME): BOOLEAN
		do
			if t1.compact_time = t2.compact_time then
				Result := fractional_secs_23_bit (t1) = fractional_secs_23_bit (t2)
			end
		end

feature -- Conversion

	compact_decimal (time: TIME): NATURAL_64
		do
			Result := time.compact_time.to_natural_64 |<< Shift_23
			Result := Result | fractional_secs_23_bit (time)
		end

	fractional_secs_23_bit (time: TIME): NATURAL_32
		-- `fractional_second' expressed as portion of `Max_value_23_bits'
		-- (accurate to 1/8.4 million of a second)
		do
			Result := (time.fractional_second * Max_value_23_bits).rounded.to_natural_32
		ensure
			valid_result: Result <= Max_value_23_bits
		end

	unix_date_time (a_date_time: DATE_TIME): INTEGER
		do
			Result := a_date_time.relative_duration (Unix_origin).seconds_count.to_integer
		end

feature -- Access

	now (utc: BOOLEAN): DATE_TIME
		do
			if utc then
				create Result.make_now_UTC
			else
				create Result.make_now
			end
		end

	unix_now (utc: BOOLEAN): INTEGER
		do
			Result := unix_date_time (now (utc))
		end

feature -- Basic operations

	read_compressed_time (readable: EL_READABLE): NATURAL_64
		local
			compact_time, fraction_23_bit: NATURAL; n32: EL_NATURAL_32_BIT_ROUTINES
		do
			compact_time := readable.read_natural_32
			if (compact_time & Time_has_fraction_mask).to_boolean then
				fraction_23_bit := n32.isolated (compact_time, Fraction_msb_7_mask)
				fraction_23_bit := (fraction_23_bit |<< 16) | readable.read_natural_16

				Result := (compact_time & Compact_time_mask).to_natural_64
				Result := Result |<< Shift_23 | fraction_23_bit
			else
				Result := compact_time.to_natural_64 |<< Shift_23
			end
		end

	set_from_compact_decimal (time: TIME; a_compact_decimal: NATURAL_64)
		local
			fraction: NATURAL_32
		do
			time.make_by_compact_time ((a_compact_decimal |>> Shift_23).to_integer_32)
			fraction := a_compact_decimal.to_natural_32 & Max_value_23_bits
			time.set_fractionals (fraction / Max_value_23_bits)
		ensure
			reversible: a_compact_decimal = compact_decimal (time)
		end

	write_compressed_time (time: TIME; writable: EL_WRITABLE)
		local
			fraction_32_bit, combined_values: NATURAL_32; t: EL_TIME_ROUTINES
			n32: EL_NATURAL_32_BIT_ROUTINES
		do
			fraction_32_bit := t.fractional_secs_23_bit (time)
			if fraction_32_bit.to_boolean then
				combined_values := n32.inserted (0, Compact_time_mask, time.compact_time.to_natural_32)
				combined_values := n32.inserted (combined_values, Fraction_MSB_7_mask, fraction_32_bit |>> 16)
				combined_values := n32.inserted (combined_values, Time_has_fraction_mask, 1)

				writable.write_natural_32 (combined_values)
				writable.write_natural_16 (fraction_32_bit.to_natural_16)
			else
				writable.write_natural_32 (time.compact_time.to_natural_32)
			end
		end

feature -- Constants

	Unix_origin: DATE_TIME
		-- Time 00:00 on 1st Jan 1970
		once
			create Result.make_from_epoch (0)
		end

feature {NONE} -- Constants

	Max_value_23_bits: NATURAL = 0x7F_FFFF

	Time_has_fraction_mask: NATURAL = 0x4000_0000
		-- bit 32

	Compact_time_mask: NATURAL = 0x00FF_FFFF
		-- bits 1 - 16

	Shift_23: INTEGER = 23

	Fraction_MSB_7_mask: NATURAL = 0x7F00_0000
		-- bits 17 - 31

end