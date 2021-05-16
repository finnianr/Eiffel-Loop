note
	description: "Date-time parser"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-16 9:15:08 GMT (Sunday 16th May 2021)"
	revision: "2"

class
	EL_DATE_TIME_PARSER

inherit
	DATE_TIME_PARSER
		redefine
			parse
		end

	EL_SHARED_DATE_TIME

create
	make

feature -- Element change

	set_zone_dezignator_count (a_zone_dezignator_count: INTEGER)
		do
			zone_designator_count := a_zone_dezignator_count
		end

feature -- Access

	zone_offset: INTEGER_8
		-- mulitples of 15 min intervals

feature -- Basic operations

	parse
		local
			i, offset_hh_mm, sign_index, sign_one, leading_count: INTEGER; zone_string, zone_dezignator: STRING
			c: CHARACTER
		do
			if zone_designator_count.to_boolean then
				leading_count := Date_time.leading_string_count (source_string, zone_designator_count)
				zone_string := source_string.substring (leading_count + 1, source_string.count)
				source_string.keep_head (leading_count)
				Precursor
				source_string.append (zone_string)
				create zone_dezignator.make (3)
				zone_offset := 0
				from i := 1 until zone_dezignator.count = 3 or else i > zone_string.count loop
					c := zone_string [i]
					if c.is_alpha then
						zone_dezignator.append_character (c)
					end
					i := i + 1
				end
				if Date_time.Zone_table.has_key (zone_dezignator) then
					offset_hh_mm := Date_time.Zone_table.found_item
					add_zone_offset ((offset_hh_mm // 100).opposite, (offset_hh_mm \\ 100).opposite)
				end
				-- We might have an adjuster without any zone designator
				across Arithmetic_signs as l_sign until sign_index > 0 loop
					if l_sign.item = '+' then
						sign_one := -1
					else
						sign_one := 1
					end
					sign_index := zone_string.index_of (l_sign.item, 1)
				end
				if sign_index.abs.to_boolean and attached new_offset_time (zone_string, sign_index) as time then
					add_zone_offset (sign_one * time.hour, sign_one * time.minute)
				end
			else
				Precursor
			end
		end

feature {NONE} -- Implementation

	add_zone_offset (hours, mins: INTEGER)
		-- convert to multiples of 15 mins
		do
			zone_offset := zone_offset + (hours * 4 + mins // 15).to_integer_8
		end

	new_offset_time (zone_string: STRING; sign_index: INTEGER): TIME
		local
			offset_string: STRING; i: INTEGER
			c: CHARACTER; done: BOOLEAN
		do
			create offset_string.make (5)
			from i := sign_index + 1 until done or else i > zone_string.count loop
				c := zone_string [i]
				if c.is_digit or else c = ':' then
					offset_string.append_character (c)
				else
					done := True
				end
				i := i + 1
			end
			-- in case of something like GMT+0000
			if offset_string.count = 4 and not offset_string.has (':') then
				offset_string.insert_character (':', 3)
			end
			-- add default mins and secs
			from until offset_string.occurrences (':') = 2 loop
				offset_string.append (once ":00")
			end
			if offset_string.count < 8 then
				offset_string.prepend_character ('0')
			end
			create Result.make_from_string (offset_string, Date_time.ISO_8601.time_extended)
		end

feature {NONE} -- Internal attributes

	zone_designator_count: INTEGER

	Arithmetic_signs: ARRAY [CHARACTER]
		once
			Result := << '+', '-' >>
		end

end