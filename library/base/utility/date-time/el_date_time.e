note
	description: "Date time"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-16 10:28:33 GMT (Sunday 16th May 2021)"
	revision: "15"

class
	EL_DATE_TIME

inherit
	DATE_TIME
		rename
			date_time_tools as Date_time,
			make as make_from_parts,
			make_from_string as make_with_format,
			make_from_string_default as make
		undefine
			Date_time
		redefine
			formatted_out, make_with_format, date_time_valid
		end

	EL_MODULE_TIME
		rename
			Time as Mod_time
		end

	EL_SHARED_DATE_TIME

	EL_STRING_8_CONSTANTS

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
	make_ISO_8601_extended,
	make_ISO_8601

feature -- Initialization

	make_ISO_8601_extended (s: STRING)
		do
			make_with_format (s, Date_time.ISO_8601.format_extended)
		end

	make_ISO_8601 (s: STRING)
		do
			make_with_format (s, Date_time.ISO_8601.format)
		end

	make_from_other (other: DATE_TIME)
		do
			set_from_other (other)
		end

	make_with_format (s: STRING; format: STRING)
		local
			parser: EL_DATE_TIME_PARSER; str: STRING
		do
			str := Buffer_8.copied_upper (s)
			if attached Conversion_table [format] as conversion then
				parser := Parser_table.item (conversion.format)
				parser.set_source_string (conversion.modified_string (str))
			else
				parser := Parser_table.item (format)
				parser.set_source_string (str)
			end
			parser.parse
			make_fine (parser.year, parser.month, parser.day, parser.hour, parser.minute, parser.fine_second)

			zone_offset := parser.zone_offset
			if zone_offset.abs.to_boolean then
				add_minutes (zone_offset.to_integer * 15)
			end
		ensure then
			valid_day_text: valid_day_text (Parser_table.found_item)
		end

feature -- Access

	formatted_out (format: STRING): STRING
		local
			index: INTEGER
		do
			if attached Conversion_table [format] as conversion then
				Result := conversion.formatted_out (Current)

			elseif attached Code_string_table.item (format) as code then
				Result := code.new_string (Current)
			end
			-- Turn Upper case month and day names into propercase if the
			-- format code is propercase
			across Propercase_table as table loop
				if format.has_substring (table.key) then
					across table.item as values_list until index > 0 loop
						index := Result.substring_index (values_list.item, 1)
						if index > 0 then
							Result [index + 1] := Result [index + 1].as_lower
							Result [index + 2] := Result [index + 2].as_lower
						end
					end
				end
			end
		end

	to_string: STRING
		do
			Result := out
		end

	zone_offset: INTEGER_8
		-- zone offset as multiples of 15 mins

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
		local
			modified, str: STRING
		do
			str := Buffer_8.copied_upper (s)
			if attached Conversion_table [format] as conversion then
				if conversion.is_valid_string (str)
					and then attached Code_string_table.item (conversion.format) as code
					and then code.precise
				then
					modified := conversion.modified_string (str)
					Result := code.correspond (modified) and then code.is_date_time (modified)
				end
			elseif attached Code_string_table.item (format) as code then
				Result := code.precise and code.correspond (str) and then code.is_date_time (str)
			end
		end

feature {NONE} -- Implementation

	add_minutes (mins: INTEGER)
		local
			hour_offset, minute_offset: INTEGER
		do
			hour_offset := mins // 60
			minute_offset := mins \\ 60
			if hour_offset.abs.to_boolean then
				hour_add (hour_offset)
			end
			if minute_offset.abs.to_boolean then
				minute_add (minute_offset)
			end
		end

	new_code_string (format: STRING): EL_DATE_TIME_CODE_STRING
		do
			create Result.make (format)
		end

	new_parser (format: STRING): EL_DATE_TIME_PARSER
		do
			Result := Code_string_table.item (format).new_parser
		end

	valid_day_text (parser: DATE_TIME_PARSER): BOOLEAN
		local
			zero: INTEGER_8
		do
			if attached parser.day_text as text and then zone_offset = zero then
				Result := text.same_string (Date_time.Days_text [date.day_of_the_week])
			else
				Result := True
			end
		end

feature {EL_DATE_TIME_CONVERSION} -- Constants

	Code_string_table: EL_CACHE_TABLE [EL_DATE_TIME_CODE_STRING, STRING]
		once
			create Result.make (11, agent new_code_string)
		end

feature {NONE} -- Constants

	Buffer_8: EL_STRING_8_BUFFER
		once
			create Result
		end

	Conversion_table: HASH_TABLE [EL_DATE_TIME_CONVERSION, STRING]
		once
			create Result.make_equal (3)
			Result [Date_time.ISO_8601.format] := create {EL_ISO_8601_DATE_TIME_CONVERSION}.make
			Result [Date_time.ISO_8601.format_extended] := create {EL_ISO_8601_EXTENDED_DATE_TIME_CONVERSION}.make
		end

	Parser_table: EL_CACHE_TABLE [EL_DATE_TIME_PARSER, STRING]
		once
			create Result.make (11, agent new_parser)
		end

	Propercase_table: EL_HASH_TABLE [ARRAY [STRING], STRING]
		once
			create Result.make (<<
				["Mmm", Date_time.Months_text],
				["Ddd", Date_time.Days_text]
			>>)
		end

end