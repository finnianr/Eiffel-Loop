note
	description: "Abstraction to process log entries that match today's date"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-09 19:07:32 GMT (Sunday 9th March 2025)"
	revision: "14"

deferred class
	EL_RECENT_LOG_ENTRIES

inherit
	ANY

	EL_MODULE_FILE; EL_MODULE_IP_ADDRESS; EL_MODULE_TUPLE

	EL_CHARACTER_8_CONSTANTS

feature {NONE} -- Initialization

	make (a_tail_count: INTEGER)
		do
			tail_count := a_tail_count
			log_path := default_log_path
			tail_count := a_tail_count.max (30)
			create buffer
			create intruder_list.make (10)
			create white_list.make_from_array (<< IP_address.Loop_back >>)
			create intruder_history_set.make (10)
			create today.make_now_utc
			create date_time.make_now
		end

feature -- Access

	intruder_list: EL_ARRAYED_LIST [NATURAL]
		-- set of never before encountered intruder addresses after calling `update_intruder_list'

	log_path: STRING

	tail_count: INTEGER

	white_list: ARRAYED_LIST [NATURAL]
		-- addresses that cannot be considered intruders

feature -- Status query

	has_intruder: BOOLEAN
		do
			Result := intruder_list.count > 0
		end

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
		-- scan tail of log with today's date to update `intruder_set' with IP number of log entry
		require
			is_log_readable: log_path = Default_log_path implies is_log_readable
		do
			intruder_list.wipe_out
			if attached new_tail_lines.query_if (agent is_new_entry) as line_list then
				if line_list.count > 0  then
					parse_lines (line_list)
					time_compact := new_compact_time (line_list.last)
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

	extend_intruder_list (line: STRING)
		local
			address: NATURAL
		do
			address := parsed_address (line)
			if address > 0 and then not white_list.has (address) then
				intruder_history_set.put (address)
			-- only added to `intruder_list' never encountered before
				if intruder_history_set.inserted then
					intruder_list.extend (address)
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
			if attached Tail_command as cmd and then attached cmd.variables as var then
				cmd.put_integer (var.tail_count, tail_count)
				cmd.put_string (var.path, log_path)
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

	date_time: EL_DATE_TIME

	intruder_history_set: EL_HASH_SET [NATURAL]
		-- set of all intruder IP addresses encounterd

	time_compact: INTEGER

	today: EL_DATE

feature {NONE} -- Constants

	Date_time_format: STRING = "yyyy Mmm dd [0]hh:[0]mi:[0]ss"

	Tail_command: EL_PARSED_CAPTURED_OS_COMMAND [TUPLE [tail_count, path: STRING]]
		once
			create Result.make_command ("tail -n $tail_count $path")
		end
end