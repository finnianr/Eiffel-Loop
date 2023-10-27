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
	date: "2023-10-27 11:35:11 GMT (Friday 27th October 2023)"
	revision: "2"

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
			create internal_month_day_string.make_empty
		end

feature -- Access

	log_path: STRING

	new_relay_spammer_list: EL_ARRAYED_MAP_LIST [NATURAL, INTEGER]
		-- map of ip number and compact today of mail spammer

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
			ip_number: NATURAL; day_updated: BOOLEAN
		do
			if is_new_day then
				new_relay_spammer_list.wipe_out
				day_updated := True
			end

			if attached Today_tail_command as cmd then
			-- Get lines with today's today
				cmd.put_string (Var.month_day, month_day_string (day_updated))
				cmd.put_string (Var.log_path, log_path)
				cmd.execute
				across cmd.lines as list loop
					if attached list.item as line then
						ip_number := new_ip_number (line)
						if not relay_spammer_set.has (ip_number)
							and then across Warning_list as warning some line.has_substring (warning.item) end
						then
							relay_spammer_set.put (ip_number)
							new_relay_spammer_list.extend (relay_spammer_set.found_item, today.ordered_compact_date)
						end
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

	compact_date (line: ZSTRING): INTEGER
		-- parse today from start of log line with possible double space after month
		--	Oct  8 06:45:32 myching sm-mta[17403]
		note
			parked: "for possible future use"
		local
			date_string: STRING; end_index, year: INTEGER
		do
			if is_new_day then
				do_nothing
			end
			year := today.year

			create date_string.make (12)
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
			Result := today.ordered_compact_date
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
			if today.ordered_compact_date > today_compact then
				today_compact := today.ordered_compact_date
				Result := True
			end
		end

feature {NONE} -- Internal attributes

	internal_month_day_string: STRING

	today: EL_DATE

	today_compact: INTEGER

	relay_spammer_set: EL_HASH_SET [NATURAL]
		-- set of ip numbers that maybe forged and have rate limit exceeded warning

feature {NONE} -- Constants

	Date_format: STRING = "yyyy Mmm dd"

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