note
	description: "[
		Analyses sendmail log using grep command for hijacking attempts to use as mail relay
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
	date: "2023-10-21 9:19:54 GMT (Saturday 21st October 2023)"
	revision: "1"

class
	EL_SENDMAIL_LOG

inherit
	ANY

	EL_MODULE_TUPLE

	EL_MODULE_IP_ADDRESS

create
	make, make_default

feature {NONE} -- Initialization

	make (a_tail_count: INTEGER)
		do
			log_path := Default_log_path
			tail_count := a_tail_count
			create relay_spammer_set.make (20)
			create new_relay_spammer_list.make (10)
			create date.make_now_utc
		end

	make_default
		do
			make (Default_tail_count)
		end

feature -- Access

	log_path: STRING

	new_relay_spammer_list: EL_ARRAYED_MAP_LIST [NATURAL, INTEGER]
		-- map of ip number and compact date of mail spammer

feature -- Constants

	Default_log_path: STRING
		once
			Result := "/var/log/mail.log"
		end

feature -- Measurement

	tail_count: INTEGER

feature -- Element change

	update_relay_spammer_list
		-- scan tail of log to update `new_relay_spammer_list' with ip number of rejected relay request
		-- because
		--		A. the connection rate limit was exceeded
		--		B. the identity maybe forged

		--		Oct  8 06:45:32 myching sm-mta[17403]: ruleset=check_relay, arg1=[80.94.95.181], arg2=80.94.95.181,\
		--		relay=[80.94.95.181], reject=421 4.3.2 Connection rate limit exceeded.
		require
			is_log_readable: log_path = Default_log_path implies is_log_readable
		local
			index, ip_index, year: INTEGER; address: STRING
		do
			new_relay_spammer_list.wipe_out
			date.make_now_utc; year := date.year

			if attached Tail_grep_rate_limit_exceeded as cmd then
				cmd.put_integer (Var.line_count, tail_count)
				cmd.put_string (Var.log_path, log_path)
				cmd.execute
				across cmd.lines as list loop
					if attached list.item as line then
						index := line.substring_index (Check_relay, 1)
						if index > 0 then
							ip_index := index + Check_relay.count
							address := line.substring_to (']', $ip_index)
							relay_spammer_set.put (IP_address.to_number (address))
							if relay_spammer_set.inserted then
								new_relay_spammer_list.extend (relay_spammer_set.found_item, compact_date (line, year))
							end
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

	compact_date (line: ZSTRING; year: INTEGER): INTEGER
		-- parse date from start of log line with possible double space after month
		--	Oct  8 06:45:32 myching sm-mta[17403]
		local
			date_string: STRING; end_index: INTEGER
		do
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
			date.make_with_format (date_string, Date_format)
			Result := date.ordered_compact_date
		end

feature {NONE} -- Internal attributes

	date: EL_DATE

	relay_spammer_set: EL_HASH_SET [NATURAL]
		-- set of ip numbers that maybe forged and have rate limit exceeded warning

feature {NONE} -- Constants

	Check_relay: STRING = "ruleset=check_relay, arg1=["

	Date_format: STRING = "yyyy Mmm dd"

	Default_tail_count: INTEGER = 50

	Tail_grep_rate_limit_exceeded: EL_CAPTURED_OS_COMMAND
		once
			create Result.make_with_name ("grep-limit-exceeded", "[
				tail --lines=$LINE_COUNT $LOG_PATH | grep --fixed-strings "Connection rate limit exceeded"
			]")
		end

	Var: TUPLE [line_count, log_path: IMMUTABLE_STRING_8]
		once
			create Result
			Tuple.fill_immutable (Result, "LINE_COUNT, LOG_PATH")
		end
end