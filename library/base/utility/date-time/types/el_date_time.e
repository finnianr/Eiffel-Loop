note
	description: "Date time"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-08-13 9:10:39 GMT (Friday 13th August 2021)"
	revision: "18"

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

	EL_STRING_8_CONSTANTS

	EL_MODULE_DATE_TIME

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

	make_ISO_8601 (s: STRING)
		do
			make_with_format (s, Date_time.ISO_8601.format)
		end

	make_ISO_8601_extended (s: STRING)
		do
			make_with_format (s, Date_time.ISO_8601.format_extended)
		end

	make_from_other (other: DATE_TIME)
		do
			set_from_other (other)
		end

	make_with_format (s: STRING; format: STRING)
		local
			parser: EL_DATE_TIME_PARSER
		do
			if attached String_8_pool.new_scope as pool and then attached pool.reuse_item as str then
				str.append (s)
				if attached Conversion_table [format] as conversion then
					parser := Parser_table.item (conversion.format)
					parser.set_source_string (conversion.modified_string (str))
				else
					parser := Parser_table.item (format)
					parser.set_source_string (str)
				end
				pool.recycle_end (str)
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

feature -- Basic operations

	append_to (general: STRING_GENERAL; format: STRING)
		local
			index, old_count: INTEGER; str: STRING
			pool: like String_8_pool.new_scope
		do
			if attached {STRING_8} general as str_8 then
				str := str_8
			else
				pool := String_8_pool.new_scope
				str := pool.reuse_item
			end
			old_count := str.count
			if attached Conversion_table [format] as conversion then
				conversion.append_to (str, Current)

			elseif attached Code_string_table.item (format) as code then
				code.append_to (str, Current)
			end
			-- Turn Upper case month and day names into propercase if the
			-- format code is propercase
			across Propercase_table as table loop
				if format.has_substring (table.key) then
					across table.item as values_list until index > 0 loop
						index := str.substring_index (values_list.item, old_count + 1)
						if index > 0 then
							str [index + 1] := str [index + 1].as_lower
							str [index + 2] := str [index + 2].as_lower
						end
					end
				end
			end
			if general /= str then
				general.append (str)
				pool.recycle_end (str)
			end
		end

feature -- Access

	formatted_out (format: STRING): STRING
		do
			if attached String_8_pool.new_scope as pool and then attached pool.reuse_item as str then
				append_to (str, format)
				Result := str.twin
				pool.recycle_end (str)
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
			time.make_by_compact_time (other.time.compact_time)
			date.make_by_ordered_compact_date (other.date.ordered_compact_date)
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
			modified: STRING
		do
			if attached String_8_pool.new_scope as pool and then attached pool.reuse_item as str then
				str.append (s); str.to_upper
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
				pool.recycle_end (str)
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