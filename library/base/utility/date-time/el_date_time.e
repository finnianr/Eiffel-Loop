note
	description: "Date time"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-13 15:27:50 GMT (Thursday 13th May 2021)"
	revision: "11"

class
	EL_DATE_TIME

inherit
	DATE_TIME
		rename
			date_time_tools as DT,
			make as make_from_parts,
			make_from_string as make_with_format,
			make_from_string_default as make
		undefine
			DT
		redefine
			formatted_out, make_with_format, date_time_valid
		end

	EL_MODULE_TIME
		rename
			Time as Mod_time
		end

	EL_SHARED_DT

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
	make_with_format,
	make_from_string_with_base,
	make_from_string_default_with_base,
	make_from_zone_and_format,
	make_utc_from_zone_and_format,
	make_ISO_8601,
	make_ISO_8601_short

feature -- Initialization

	make_utc_from_zone_and_format (s, a_zone, format: STRING; offset, hour_adjust: INTEGER)
		do
			make_from_zone_and_format (s, a_zone, format, offset)
			hour_add (hour_adjust)
		end

	make_from_zone_and_format (s, a_zone, format: STRING; offset: INTEGER)
		local
			pos_last: INTEGER
		do
			pos_last := s.substring_index (a_zone, 1) - 2
			make_with_format (buffer_8.copied_substring (s, offset, pos_last), format)
			add_offset (parse_offset (s))
		end

	make_from_other (other: DATE_TIME)
		do
			set_from_other (other)
		end

	make_ISO_8601 (s: STRING)
		do
			make_with_format (s, DT.Format_iso_8601)
		end

	make_ISO_8601_short (s: STRING)
		do
			make_with_format (s, DT.format_iso_8601_short)
		end

	make_with_format (s: STRING; format: STRING)
		local
			modified: STRING
		do
			if attached ISO_8601_info_table [format] as l then
				modified := Buffer_8.copied_substring (s, 1, l.index_of_T - 1)
				if format ~ DT.Format_iso_8601 then
					modified.append_character (' ')
				end
				modified.append_substring (s, l.index_of_T + 1, l.input_string_count - 1)
				Precursor (modified, l.format)
			else
				Precursor (s, format)
			end
		end

feature -- Access

	to_string: STRING
		do
			Result := out
		end

	formatted_out (format: STRING): STRING
		do
			if attached ISO_8601_info_table [format] as l then
				create Result.make (l.input_string_count)
				Result.append (Precursor (l.format))
				Result [l.index_of_T] := 'T'
				Result.append_character ('Z')
			else
				Result := Precursor (format)
			end
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

feature -- Conversion

	to_date_time: DATE_TIME
		do
			create Result.make_from_epoch (to_unix)
		end

	to_unix: INTEGER
		do
			Result := Mod_time.unix_date_time (Current)
		end

feature -- Contract support

	date_time_valid (s: STRING; format: STRING): BOOLEAN
		do
			if attached ISO_8601_info_table [format] as l then
				if s.count = l.input_string_count then
					Result := s [l.index_of_T] = 'T' and s [l.input_string_count] = 'Z'
				end
			else
				Result := Precursor (s, format)
			end
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

	ISO_8601_info_table: HASH_TABLE [EL_ISO_8601_FORMAT, STRING]
		once
			create Result.make_equal (3)
			Result [DT.Format_iso_8601] := ["yyyy-[0]mm-[0]dd [0]hh:[0]mi:[0]ss", 20, 11]
			Result [DT.format_iso_8601_short] := ["yyyy[0]mm[0]dd[0]hh[0]mi[0]ss", 16, 9]
		end

	Arithmetic_signs: ARRAY [CHARACTER]
		once
			Result := << '+', '-' >>
		end

	Buffer_8: EL_STRING_8_BUFFER
		once
			create Result
		end

end