note
	description: "Abstraction to process log entries that match today's date"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-23 11:46:29 GMT (Sunday 23rd February 2025)"
	revision: "6"

deferred class
	EL_TODAYS_LOG_ENTRIES

inherit
	ANY

	EL_MODULE_FILE; EL_MODULE_IP_ADDRESS; EL_MODULE_TUPLE

	EL_CHARACTER_8_CONSTANTS

feature {NONE} -- Initialization

	make
		do
			log_path := default_log_path
			create relay_hacker_set.make_equal (20)
			create new_hacker_ip_list.make (10)
			create today.make_now_utc
			create time.make_now
			create internal_month_day_string.make_empty
		end

feature -- Access

	log_path: STRING

	new_hacker_ip_list: EL_ARRAYED_LIST [NATURAL]
		-- list of new IP addresses of hackers since last call to `update_hacker_ip_list'

feature -- Deferred

	default_log_path: STRING
		deferred
		end

	new_ip_number (line: STRING): NATURAL
		deferred
		ensure
			not_zero: Result > 0
		end

	port: NATURAL_16
		-- associated port number
		deferred
		end

feature -- Element change

	update_hacker_ip_list
		-- scan tail of log with today's date to update `new_hacker_ip_list' with ip number of log entry
		-- containing any string in `warning_list'
		require
			is_log_readable: log_path = Default_log_path implies is_log_readable
		local
			day_updated: BOOLEAN; line: STRING
		do
			new_hacker_ip_list.wipe_out
			if is_new_day then
				day_updated := True
				today_compact := today.ordered_compact_date
				time_compact := 0
			end
			across new_todays_lines (month_day_string (day_updated)).query_if (agent is_new_entry) as list loop
				line := list.item
				if across warning_list as warning some line.has_substring (warning.item) end then
					check
						todays_date: new_compact_date (line, today.year) = today_compact
					end
					relay_hacker_set.put (new_ip_number (line))
					if relay_hacker_set.inserted then
						new_hacker_ip_list.extend (relay_hacker_set.found_item)
					end
				end
				if list.is_last then
					time_compact := new_compact_time (line)
				end
			end
		end

feature -- Contract Support

	is_log_readable: BOOLEAN
		-- `True' if current user has permission to read log file
		do
			Result := File.is_readable (log_path)
		end

feature {NONE} -- Implementation

	is_new_day: BOOLEAN
		-- redefine to fixed date in testing descendant
		do
			today.make_now_utc
			Result := today.ordered_compact_date > today_compact
		end

	is_new_entry (line: STRING): BOOLEAN
		do
			Result := new_compact_time (line) >= time_compact
		end

	month_day_string (day_updated: BOOLEAN): STRING
		-- fixed length date without the year
		do
			if day_updated then
				internal_month_day_string := today.formatted_out (Date_format)

			-- right justify day
				if attached internal_month_day_string as str and then str.count < Date_format.count then
					str.insert_character (' ', str.count)
				end
				internal_month_day_string.remove_head (5) -- remove year
			end
			Result := internal_month_day_string
		ensure
			year_removed_and_day_right_justified: Result.count = 6
		end

feature {NONE} -- Factory

	new_compact_date (line: STRING; year: INTEGER): INTEGER
		-- parse today from start of log line with right justified day number
		--	Oct  8 06:45:32 myching sm-mta[17403]
		local
			end_index: INTEGER
		do
			if attached Date_time_buffer.empty as date_string then
				date_string.append_integer (year)
				date_string.append_character (' ')
				end_index := line.index_of (':', 1)
				if end_index > 5 then
					date_string.append_substring (line, 1, end_index - 4)
				--	ensure canonically spaced
					date_string.replace_substring_all (Space * 2, Space * 1)
				end
				today.make_with_format (date_string, Date_format)
			end
			Result := today.ordered_compact_date
		end

	new_compact_time (line: STRING): INTEGER
		do
			if attached Date_time_buffer.copied_general (line.substring (8, 15)) as time_string then
				time.make_with_format (time_string, Time_format)
				Result := time.compact_time
			end
		end

	new_todays_lines (date_string: STRING): EL_STRING_8_LIST
		local
			log: PLAIN_TEXT_FILE; break: BOOLEAN
		do
			create Result.make (300)
			create log.make_open_read (log_path)
			from until break loop
				log.read_line
				if log.end_of_file then
					break := True
					
				elseif log.last_string.starts_with (date_string) then
					Result.extend (log.last_string.string)
				end
			end
			log.close
		end

feature {NONE} -- Deferred

	warning_list: EL_STRING_8_LIST
		deferred
		end

feature {NONE} -- Internal attributes

	internal_month_day_string: STRING

	relay_hacker_set: EL_HASH_SET [NATURAL]
		-- set of ip numbers that maybe forged and have rate limit exceeded warning

	time: EL_TIME

	time_compact: INTEGER

	today: EL_DATE

	today_compact: INTEGER

feature {NONE} -- Constants

	Date_format: STRING = "yyyy Mmm dd"

	Date_time_buffer: EL_STRING_8_BUFFER
		once
			create Result
		end

	Time_format: STRING = "[0]hh:[0]mi:[0]ss"

end