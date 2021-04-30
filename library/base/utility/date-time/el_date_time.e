note
	description: "Date time"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-04-30 12:13:23 GMT (Friday 30th April 2021)"
	revision: "10"

class
	EL_DATE_TIME

inherit
	DATE_TIME
		rename
			make as make_from_parts,
			make_from_string as make_from_string_with_code,
			make_from_string_default as make
		redefine
			date_time_valid
		end

	EL_MODULE_TIME
		rename
			Time as Mod_time
		end

create
	make,
	make_from_parts,
	make_fine,
	make_by_date_time,
	make_by_date,
	make_now,
	make_now_utc,
	make_from_epoch,
	make_from_other,
	make_from_string_with_code,
	make_from_string_with_base,
	make_from_string_default_with_base,
	make_from_zone_and_format,
	make_utc_from_zone_and_format

feature -- Initialization

	make_utc_from_zone_and_format (s, a_zone, a_format: STRING; offset, hour_adjust: INTEGER)
		do
			make_from_zone_and_format (s, a_zone, a_format, offset)
			hour_add (hour_adjust)
		end

	make_from_zone_and_format (s, a_zone, a_format: STRING; offset: INTEGER)
		local
			pos_last: INTEGER
		do
			pos_last := s.substring_index (a_zone, 1) - 2
			make_from_string_with_code (buffer_8.copied_substring (s, offset, pos_last), a_format)
			add_offset (parse_offset (s))
		end

	make_from_other (other: DATE_TIME)
		do
			set_from_other (other)
		end

feature -- Access

	to_string: STRING
		do
			Result := out
		end

feature -- Element change

	add_offset (offset: INTEGER)
			-- add offset formatted as hhmm or hh
		do
			if offset /= 0 then
				if offset > 100 then
					minute_add (offset \\ 100)
					hour_add (offset // 100)
				else
					hour_add (offset)
				end
			end
		end

	set_from_other (other: DATE_TIME)
		do
			set_time (other.time); set_date (other.date)
		end

feature -- Preconditions

	date_time_valid (s: STRING; format_string: STRING): BOOLEAN
		do
			Result := True
		end

feature -- Conversion

	to_date_time: DATE_TIME
		do
			create Result.make_from_epoch (to_unix)
		end

	to_unix: INTEGER
		do
			Result := Mod_time.unix_date_time (Current)
		end

feature {NONE} -- Implementation

	parse_offset (s: STRING): INTEGER
		local
			i, pos_sign, pos_space: INTEGER; sign: CHARACTER
		do
			from i := 1 until pos_sign > 0 or i > Arithmetic_signs.count loop
				sign := Arithmetic_signs [i]
				pos_sign := s.index_of (sign, 1)
				if pos_sign > 0 then
					pos_space := s.index_of (' ', pos_sign)
					if pos_space = 0 then
						pos_space := s.count + 1
					end
					Result := buffer_8.copied_substring (s, pos_sign, pos_space - 1).to_integer
				end
				i := i + 1
			end
		end

feature {NONE} -- Constants

	Arithmetic_signs: ARRAY [CHARACTER]
		once
			Result := << '+', '-' >>
		end

	Buffer_8: EL_STRING_8_BUFFER
		once
			create Result
		end

end