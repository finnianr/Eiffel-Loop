note
	description: "Abstraction to process log entries that match today's date"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-24 5:14:11 GMT (Monday 24th February 2025)"
	revision: "8"

deferred class
	EL_RECENT_LOG_ENTRIES

inherit
	ANY

	EL_MODULE_FILE; EL_MODULE_IP_ADDRESS; EL_MODULE_TUPLE

	EL_CHARACTER_8_CONSTANTS

feature {NONE} -- Initialization

	make
		do
			log_path := default_log_path
			create buffer
			create relay_hacker_set.make_equal (20)
			create intruder_list.make (10)
			create today.make_now_utc
			create date_time.make_now
		end

feature -- Access

	log_path: STRING

	intruder_list: EL_ARRAYED_LIST [NATURAL]
		-- list of new IP addresses of hackers since last call to `update_malicious_list'

feature -- Deferred

	default_log_path: STRING
		deferred
		end

	parsed_address (line: STRING): NATURAL
		deferred
		ensure
			not_zero: Result > 0
		end

	port: NATURAL_16
		-- associated port number
		deferred
		end

feature -- Element change

	update_intruder_list
		-- scan tail of log with today's date to update `intruder_ip_list' with ip number of log entry
		-- containing any string in `warning_list'
		require
			is_log_readable: log_path = Default_log_path implies is_log_readable
		do
			intruder_list.wipe_out
			if attached new_tail_lines.query_if (agent is_new_entry) as line_list
				 and then line_list.count > 0
			then
				parse_lines (line_list)
				time_compact := new_compact_time (line_list.last)
			end
		end

feature -- Contract Support

	is_log_readable: BOOLEAN
		-- `True' if current user has permission to read log file
		do
			Result := File.is_readable (log_path)
		end

feature {NONE} -- Implementation

	extend_intruder_list (line: STRING)
		local
			address: NATURAL
		do
			address := parsed_address (line)
			if address.to_boolean then
				relay_hacker_set.put (address)
				if relay_hacker_set.inserted then
					intruder_list.extend (relay_hacker_set.found_item)
				end
			end
		end

	is_new_entry (line: STRING): BOOLEAN
		do
			Result := new_compact_time (line) >= time_compact
		end

feature {NONE} -- Factory

	new_compact_time (line: STRING): INTEGER
		do
			if attached buffer.empty as str then
				str.append_integer (today.year)
				str.append_character (' ')
				str.append_substring (line, 1, 15)
			-- Remove double space "2025 Feb  2 18:13:19" for single digit dates
				if str [10] = ' ' then
					str.remove (10)
				end
				date_time.make_with_format (str, Date_time_format)
				Result := date_time.time_stamp
			end
		end

	new_tail_lines: EL_STRING_8_LIST
		do
			if attached Tail_command as cmd then
				cmd.put_string (Var_path, log_path)
				cmd.execute
				create Result.make_from_general (cmd.lines)
			end
		end

feature {NONE} -- Deferred

	parse_lines (line_list: LIST [STRING])
		deferred
		end

feature {NONE} -- Internal attributes

	buffer: EL_STRING_8_BUFFER

	relay_hacker_set: EL_HASH_SET [NATURAL]
		-- set of ip numbers that maybe forged and have rate limit exceeded warning

	date_time: EL_DATE_TIME

	time_compact: INTEGER

	today: EL_DATE

feature {NONE} -- Constants

	Date_time_format: STRING = "yyyy Mmm dd [0]hh:[0]mi:[0]ss"

	Tail_command: EL_CAPTURED_OS_COMMAND
		once
			create Result.make ("tail -n 30 $path")
		end

	Var_path: STRING = "path"
end