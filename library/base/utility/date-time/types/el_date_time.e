note
	description: "Date time"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-08-15 19:02:16 GMT (Sunday 15th August 2021)"
	revision: "21"

class
	EL_DATE_TIME

inherit
	DATE_TIME
		rename
			date_time_tools as Date_time,
			make_from_string as make_with_format,
			make_from_string_default as make_from_string
		undefine
			Date_time, formatted_out, date_time_valid, make_with_format
		end

	EL_DATE_TIME_UTILITY
		rename
			input_valid as date_time_valid
		export
			{EL_DATE_TIME_CONVERSION} Code_string_table
		redefine
			new_code_string
		end

	EL_MODULE_TIME
		rename
			Time as Mod_time
		end

create
	make, make_fine, make_by_date_time, make_by_date, make_from_epoch, make_now, make_now_utc,
	make_from_other, make_with_format, make_from_string_with_base, make_from_string_default_with_base,
	make_ISO_8601_extended, make_ISO_8601

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
			make_from_epoch (0)
			set_from_other (other)
		end

	make_with_parser (parser: EL_DATE_TIME_PARSER)
		do
			make_fine (parser.year, parser.month, parser.day, parser.hour, parser.minute, parser.fine_second)
			if attached {EL_ZONED_DATE_TIME_PARSER} parser as zoned then
				zone_offset := zoned.zone_offset
				if zone_offset.abs.to_boolean then
					add_minutes (zone_offset.to_integer * 15)
				end
			end
		ensure then
			valid_day_text: valid_day_text (parser)
		end

feature -- Access

	zone_offset: INTEGER_8
		-- zone offset as multiples of 15 mins

feature -- Status query

	same_as (other: DATE_TIME): BOOLEAN
		do
			if date.ordered_compact_date = other.date.ordered_compact_date then
				Result := time.compact_time = other.time.compact_time
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
		local
			zone_designator_count: INTEGER
		do
			if attached Conversion_table [format] as converter then
				create {EL_ISO_8601_DATE_TIME_CODE_STRING} Result.make (format, converter)
			else
				zone_designator_count := Date_time.zone_designator_count (format)
				if zone_designator_count > 0 then
					create {EL_ZONED_DATE_TIME_CODE_STRING} Result.make (format, zone_designator_count)
				else
					create Result.make (format)
				end
			end
		end

	to_shared_date_time: DATE_TIME
		do
			Result := Current
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

feature {NONE} -- Implementation

	valid_string_for_code (str: STRING; code: EL_DATE_TIME_CODE_STRING): BOOLEAN
		do
			Result := code.precise and code.correspond (str) and then code.is_date_time (str)
		end

feature {NONE} -- Constants

	Conversion_table: HASH_TABLE [EL_DATE_TIME_CONVERSION, STRING]
		once
			create Result.make_equal (3)
			Result [Date_time.ISO_8601.format] := create {EL_ISO_8601_DATE_TIME_CONVERSION}.make
			Result [Date_time.ISO_8601.format_extended] := create {EL_ISO_8601_EXTENDED_DATE_TIME_CONVERSION}.make
		end

end