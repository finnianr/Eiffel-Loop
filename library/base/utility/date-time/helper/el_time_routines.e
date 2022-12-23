note
	description: "Time routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-23 17:08:32 GMT (Friday 23rd December 2022)"
	revision: "10"

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

feature -- Conversion

	compact_decimal_time (time: TIME): NATURAL_64
		do
			Result := time.compact_time.to_natural_64
			Result := Result |<< 16 | time_fraction_16 (time)
		end

	time_fraction_16 (time: TIME): NATURAL_16
		-- `fractional_second' expressed as portion of `0xFFFF' i.e. 16-bit max value
		do
			Result := (time.fractional_second * Result.Max_value).rounded.to_natural_16
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

feature -- Constants

	Unix_origin: DATE_TIME
		-- Time 00:00 on 1st Jan 1970
		once
			create Result.make_from_epoch (0)
		end

end