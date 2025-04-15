note
	description: "Extension to ${DATE_TIME_TOOLS}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-15 10:55:35 GMT (Tuesday 15th April 2025)"
	revision: "19"

class
	EL_DATE_TIME_TOOLS

inherit
	DATE_TIME_TOOLS

	EL_STRING_GENERAL_ROUTINES_I

	EL_MODULE_TUPLE

feature -- Access

	modification_time (file: FILE_PATH): EL_DATE_TIME
		do
			if file.exists then
				create Result.make_from_epoch (file.modification_time)
			else
				create Result.make_from_other (Origin)
			end
		end

	zone_designator_count (format: STRING): INTEGER
		-- 0 if format does not contain "tzd"
		-- 1 if format ends with "tzd"
		-- 2 if format ends with "tzd (tzd)"
		local
			zone_index: INTEGER; buffer: EL_STRING_8_BUFFER_ROUTINES
		do
			if attached buffer.empty as format_upper then
				format_upper.append (format); format_upper.to_upper
				zone_index := format_upper.substring_index (Time_zone_designator, 1)
				if zone_index.to_boolean then
					if format_upper.substring_index (Time_zone_designator, zone_index + 3).to_boolean then
						Result := 2
					else
						Result := 1
					end
				end
			end
		ensure
			valid_count: format.as_upper.has_substring (Time_zone_designator) implies Result > 0
		end

feature -- Basic operations

	format_to (output, format: STRING; unix_date_time: INTEGER; time_zone: detachable STRING)
		-- output `unix_date_time' formatted with `format' to `output' wiping out previous content,
		-- and adding optional `time_zone'
		do
			Date_time.make_from_epoch (unix_date_time)
			output.wipe_out
			Date_time.append_to_string_8 (output, format)
			if attached time_zone as str then
				output.append_character (' '); output.append (str)
			end
		end

feature -- Integer field representations

	Date_representation: EL_DATE_REPRESENTATION
		-- maps reflected `INTEGER' field to `DATE'
		once
			create Result.make (date_default_format_string)
		end

	Representation: EL_DATE_TIME_REPRESENTATION
		-- maps reflected `INTEGER' field to `EL_DATE_TIME'
		once
			create Result.make (Default_format_string)
		end

	Time_representation: EL_TIME_REPRESENTATION
		-- maps reflected `INTEGER' field to `TIME'
		once
			create Result.make (ISO_8601.time_extended)
		end

feature -- Constants

	ISO_8601: TUPLE [time, time_extended, date, date_extended, format, format_extended: STRING]
		once
			create Result
			Result.time_extended := "[0]hh:[0]mi:[0]ss"
			Result.time := super_8 (Result.time_extended).pruned (':')
			Result.date_extended := "yyyy-[0]mm-[0]dd"
			Result.date := super_8 (Result.date_extended).pruned ('-')

			Result.format := Result.date + "T" + Result.time + "Z"
			Result.format_extended := Result.date_extended + "T" + Result.time_extended + "Z"
		end

	Origin: DATE_TIME
		local
			dt: DATE_TIME
		once
			create dt.make_from_epoch (0)
			Result := dt.Origin
		end

	Time_zone_designator: STRING = "TZD"

	Zone: TUPLE [GMT, PDT, PST, UTC: STRING]
		-- common time zones
		once
			create Result
			Tuple.fill (Result, "GMT, PDT, PST, UTC")
		end

feature -- Constants

	Zone_table: EL_HASH_TABLE [INTEGER, STRING]
		-- Zones relative to UTC formated as hours and mins
		once
			Result := <<
				[Zone.PST, -8_00], [Zone.PDT, -7_00], [Zone.GMT, 0], [Zone.UTC, 0]
			>>
		end

feature {NONE} -- Constants

	Date_time: EL_DATE_TIME
		once
			create Result.make_default
		end
end