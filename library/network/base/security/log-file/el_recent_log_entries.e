note
	description: "Abstraction to process log entries that match today's date"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-11 10:19:32 GMT (Tuesday 11th March 2025)"
	revision: "17"

deferred class
	EL_RECENT_LOG_ENTRIES

inherit
	ANY

	EL_MODULE_FILE; EL_MODULE_IP_ADDRESS; EL_MODULE_TUPLE

	EL_CHARACTER_8_CONSTANTS

	EL_STRING_8_CONSTANTS

feature {NONE} -- Initialization

	make (a_log_path: FILE_PATH)
		do
			log_path := a_log_path
			last_line := Empty_string_8
			create intruder_list.make (10)
			create intruder_history_set.make (10)
			create white_listed_set.make_from (<< IP_address.Loop_back >>, False)
			state := agent final
		end

feature -- Access

	intruder_list: EL_ARRAYED_LIST [NATURAL]
		-- set of never before encountered intruder addresses after calling `update_intruder_list'

	log_path: FILE_PATH

	white_listed_set: EL_HASH_SET [NATURAL]
		-- set of IP addresses that cannot be considered intruders
		-- (address of authenticated SSH user OR loop-back)

feature -- Status query

	has_intruder: BOOLEAN
		do
			Result := intruder_list.count > 0
		end

feature -- Deferred

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
		-- scan copy of log tail to update `intruder_set' with IP numbers of any detected attacks
		require
			log_is_readable: is_log_readable
		local
			continue_from_last: BOOLEAN
		do
			intruder_list.wipe_out

			if last_line.count > 0 then
			-- Try to pick up from same line in previous call to `update_intruder_list'
				across File.plain_text_lines (log_path) as file_line loop
					if attached file_line.item as line then
						if continue_from_last then
							do_with (line)
						else
							continue_from_last := line ~ last_line
						end
						if file_line.is_last then
							last_line := line
						end
					end
				end
			end
			if not continue_from_last then
			-- check entire log file from beginning
				state := agent check_line
				across File.plain_text_lines (log_path) as file_line loop
					if attached file_line.item as line then
						do_with (line)
						if file_line.is_last then
							last_line := line
						end
					end
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

	check_line (line: STRING)
		do
		end

	extend_intruder_list (line: STRING)
		local
			address: NATURAL
		do
			address := parsed_address (line)
			if address > 0 and then not white_listed_set.has (address) then
				intruder_history_set.put (address)
			-- only added to `intruder_list' never encountered before
				if intruder_history_set.inserted then
					intruder_list.extend (address)
				end
			end
		end

feature {NONE} -- Deferred

	final (line: STRING)
		do
		end

	do_with (line: STRING)
		deferred
		end

feature {NONE} -- Internal attributes

	intruder_history_set: EL_HASH_SET [NATURAL]
		-- set of all intruder IP addresses encounterd

	last_line: STRING

	state: PROCEDURE [STRING]
		-- current line state as log lines are iterated over

end