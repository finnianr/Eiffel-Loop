note
	description: "Date time"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-11-03 11:29:26 GMT (Sunday 3rd November 2024)"
	revision: "31"

class
	EL_DATE_TIME

inherit
	DATE_TIME
		rename
			date_time_tools as Date_time,
			make_from_string as make_with_format,
			make_from_string_default as make_from_string
		export
			{ANY} ordered_compact_date
			{NONE} duration -- really buggy
		undefine
			Date_time, formatted_out, date_time_valid, make_with_format, make_now, make_now_utc
		end

	EL_TIME_DATE_I
		rename
			input_valid as date_time_valid
		redefine
			Factory
		end

create
	make, make_default, make_fine,
	make_by_date_time, make_by_date, make_from_epoch, make_now, make_now_utc,
	make_from_other, make_with_format, make_from_string,
	make_from_string_with_base, make_from_string_default_with_base,
	make_ISO_8601_extended, make_ISO_8601

feature -- Initialization

	make_default
		do
			create date.make_by_days (0)
			create time.make_fine (0, 0, 0)
		end

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
			make_default
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

feature -- Measurement

	epoch_seconds: INTEGER
		-- seconds since epoch (1 Jan 1970 at 00:00:00)
		do
			Result := relative_duration (Epochal_origin).fine_seconds_count.rounded
		ensure
			almost_reversible: new_date (Result).is_almost_equal (Current)
		end

	zone_offset: INTEGER_8
		-- zone offset as multiples of 15 mins

feature -- Status query

	same_as (other: DATE_TIME): BOOLEAN
		do
			if date.ordered_compact_date = other.date.ordered_compact_date then
				Result := time.compact_time = other.time.compact_time
			end
		end

feature -- Comparison

	is_almost_equal (other: like Current): BOOLEAN
		-- Is the current object within one second of `other'?
		do
			Result := (ordered_compact_date - other.ordered_compact_date).abs <= 1
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
			date.copy (other.date)
			time.copy (other.time)
			if attached {EL_DATE_TIME} other as dt then
				zone_offset := dt.zone_offset
			end
		end

feature -- Conversion

	to_date_time: DATE_TIME
		do
			create Result.make_from_epoch (to_unix)
		end

	to_unix, time_stamp: INTEGER
		-- Unix time stamp
		local
			t: EL_TIME_ROUTINES
		do
			Result := t.unix_date_time (Current)
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

	new_date (epoch: INTEGER): like Current
		do
			create Result.make_from_epoch (epoch)
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

	update_with (system: EL_SYSTEM_TIME)
		do
			date.make (system.year_now, system.month_now, system.day_now)
			time.make_fine (system.hour_now, system.minute_now, system.second_now + system.millisecond_now / 1000)
		end

	valid_string_for_code (str: STRING; code: EL_DATE_TIME_CODE_STRING): BOOLEAN
		do
			Result := code.precise and code.correspond (str) and then code.is_date_time (str)
		end

feature {EL_DATE_TIME_CONVERSION} -- Constants

	Epochal_origin: EL_DATE_TIME
		once
			create Result.make_from_epoch (0)
		end

	Factory: EL_DATE_TIME_PARSER_FACTORY
		once
			create Result.make
		end
end