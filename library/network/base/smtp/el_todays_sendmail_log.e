note
	description: "[
		Analyses today's entries in sendmail log for SMTP relay abuse
	]"
	notes: "[
		Make current user member of administrator group **adm**
		
			sudo usermod -aG adm <username>
			
		Then re-login for command to take effect.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-10-28 9:27:51 GMT (Saturday 28th October 2023)"
	revision: "3"

class
	EL_TODAYS_SENDMAIL_LOG

inherit
	ANY

	EL_MODULE_TUPLE

	EL_MODULE_IP_ADDRESS

create
	make

feature {NONE} -- Initialization

	make
		do
			log_path := Default_log_path
			create relay_spammer_set.make (20)
			create new_relay_spammer_list.make (10)
			create today.make_now_utc
			create time.make_now
			create internal_month_day_string.make_empty
		end

feature -- Access

	log_path: STRING

	new_relay_spammer_list: EL_ARRAYED_LIST [NATURAL]
		-- list of new IP addresses of relay spammers since last call to `update_relay_spammer_list'

feature -- Constants

	Default_log_path: STRING
		once
			Result := "/var/log/mail.log"
		end

feature -- Measurement

	tail_count: INTEGER

feature -- Element change

	update_relay_spammer_list
		-- scan tail of log with today's date to update `new_relay_spammer_list' with ip number of log entry
		-- containing any string in `Warning_list'
		require
			is_log_readable: log_path = Default_log_path implies is_log_readable
		local
			day_updated: BOOLEAN; line: ZSTRING
		do
			new_relay_spammer_list.wipe_out
			if is_new_day then
				day_updated := True
				today_compact := today.ordered_compact_date
				time_compact := 0
			end

			if attached Today_tail_command as cmd then
			-- Get lines with today's today
				cmd.put_string (Var.month_day, month_day_string (day_updated))
				cmd.put_string (Var.log_path, log_path)
				cmd.execute
				across cmd.lines.query_if (agent is_new_entry) as list loop
					line := list.item
					if across Warning_list as warning some line.has_substring (warning.item) end then
						check
							todays_date: new_compact_date (line, today.year) = today_compact
						end
						relay_spammer_set.put (new_ip_number (line))
						if relay_spammer_set.inserted then
							new_relay_spammer_list.extend (relay_spammer_set.found_item)
						end
					end
					if list.is_last then
						time_compact := new_compact_time (line)
					end
				end
			end
		end

feature -- Contract Support

	is_log_readable: BOOLEAN
		-- `True' if current user is a member of 'adm' group
		local
			groups: EL_CAPTURED_OS_COMMAND
		do
			create groups.make ("groups")
			groups.execute
			if groups.lines.count > 0 then
				Result := groups.lines.first.split (' ').has_item ("adm")
			end
		end

feature {NONE} -- Implementation

	new_compact_date (line: ZSTRING; year: INTEGER): INTEGER
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
					end_index := end_index - 4
					if attached line.substring (1, end_index) as month_day then
						month_day.to_canonically_spaced
						month_day.append_to_string_8 (date_string)
					end
				end
				today.make_with_format (date_string, Date_format)
			end
			Result := today.ordered_compact_date
		end

	new_compact_time (line: ZSTRING): INTEGER
		do
			if attached Date_time_buffer.copied_general (line.substring (8, 15)) as time_string then
				time.make_with_format (time_string, Time_format)
				Result := time.compact_time
			end
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

	new_ip_number (line: ZSTRING): NATURAL
		-- Extract IP address from log entry
		-- Oct 26 14:45:16 myching sm-mta[30359]: 39QEjFLv030359: rejecting commands from [103.187.190.12]
		local
			start_index: INTEGER; address: STRING
		do
			start_index := line.substring_index (Message_start_marker, 1)
			if start_index > 0 then
			-- Start of message
				start_index := line.index_of ('[', start_index + Message_start_marker.count)
				if start_index > 0 then
					start_index := start_index + 1
					address := line.substring_to (']', $start_index)
					Result := IP_address.to_number (address)
				end
			end
		ensure
			not_zero: Result > 0
		end

	is_new_day: BOOLEAN
		-- redefine to fixed date in testing descendant
		do
			today.make_now_utc
			Result := today.ordered_compact_date > today_compact
		end

	is_new_entry (line: ZSTRING): BOOLEAN
		do
			Result := new_compact_time (line) >= time_compact
		end

feature {NONE} -- Internal attributes

	internal_month_day_string: STRING

	time: EL_TIME

	time_compact: INTEGER

	today: EL_DATE

	today_compact: INTEGER

	relay_spammer_set: EL_HASH_SET [NATURAL]
		-- set of ip numbers that maybe forged and have rate limit exceeded warning

feature {NONE} -- Constants

	Date_format: STRING = "yyyy Mmm dd"

	Date_time_buffer: EL_STRING_8_BUFFER
		once
			create Result
		end

	Time_format: STRING = "[0]hh:[0]mi:[0]ss"

	Today_tail_command: EL_CAPTURED_OS_COMMAND
		once
			create Result.make_with_name ("grep-today", "grep %"^$MONTH_DAY%" $LOG_PATH")
		end

	Message_start_marker: ZSTRING
		once
			Result := "]: "
		end

	Warning_list: EL_ZSTRING_LIST
		once
			Result := "Connection rate limit exceeded, Relaying denied"
		end

	Var: TUPLE [log_path, month_day: IMMUTABLE_STRING_8]
		once
			create Result
			Tuple.fill_immutable (Result, "LOG_PATH, MONTH_DAY")
		end
end