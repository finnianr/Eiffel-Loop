note
	description: "Parse Apache or Cherokee web-server log entry"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-10 8:58:12 GMT (Wednesday 10th July 2024)"
	revision: "15"

class
	EL_WEB_LOG_ENTRY

inherit
	ANY

	EL_MODULE_IP_ADDRESS

	EL_ZSTRING_CONSTANTS

	EL_SET [CHARACTER_8]
		rename
			has as has_punctuation
		end

create
	make

feature {NONE} -- Initialization

	make (line: ZSTRING)
		require
			valid_line: line.occurrences (Quote) = 6
		local
			index: INTEGER; part: ZSTRING
		do
			across line.split (Quote) as list loop
				part := list.item
				inspect list.cursor_index
					when 1 then
						if attached part.substring_to (' ') as address then
							ip_number := Ip_address.to_number (address)
							index := part.index_of ('[', address.count + 3) + 1
						end
						compact_date := Date_parser.to_ordered_compact_date (part.substring (index, index + 10))
						index := index + 12
						compact_time := Time_parser.to_compact_time (part.substring (index, index + 7))
					when 2 then
						Http_command_cache_set.put (part.substring_to (' '))
						http_command := Http_command_cache_set.found_item
						index := part.substring_index (Http_protocol, http_command.count + 1)
						if index.to_boolean then
							Request_uri_cache_set.put (part.substring (http_command.count + 2, index - 2))
						else
							Request_uri_cache_set.put_copy (Empty_string)
						end
						request_uri := Request_uri_cache_set.found_item
					when 3 then
						part.adjust
						index := part.index_of (' ', 1)
						status_code := part.substring (1, index - 1).to_natural
						byte_count := part.substring_end (index + 1).to_natural
					when 4 then
						if part.is_character ('-') then
							Referer_cache_set.put_copy (Empty_string)
						else
							Referer_cache_set.put_copy (part)
						end
						referer := Referer_cache_set.found_item
					when 6 then
						User_agent_uri_cache_set.put_copy (part)
						user_agent := User_agent_uri_cache_set.found_item

				else end
			end
		end

feature -- Date/time

	compact_date: INTEGER
		-- Year, month, day coded for fast comparison between dates.

	compact_time: INTEGER
		-- Hour, minute, second coded.

	date: DATE
		do
			create Result.make_by_ordered_compact_date (compact_date)
		end

	time: TIME
		do
			create Result.make_by_compact_time (compact_time)
		end

feature -- Access

	byte_count: NATURAL

	http_command: STRING

	ip_number: NATURAL

	referer: ZSTRING

	request_uri: ZSTRING

	status_code: NATURAL

	stripped_user_agent (keep_ref: BOOLEAN): ZSTRING
		-- lower case `user_agent' stripped of punctuation and version numbers
		do
			Result := stripped_lower (user_agent)
			if keep_ref then
				Result := Result.twin
			end
		end

	user_agent: ZSTRING

feature {NONE} -- Implementation

	has_punctuation (c: CHARACTER): BOOLEAN
		do
			inspect c
				when '_', '-' then
					Result := False
			else
				Result := c.is_punctuation
			end
		end

	stripped_lower (a_name: ZSTRING): ZSTRING
		-- if `a_name' ~ "Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101 Firefox/78.0"
		-- result is "mozilla x11 linux x86_64 rv gecko firefox"
		local
			name, part: ZSTRING
		do
			name := a_name.twin
			name.replace_set_members_8 (Current, ' ') -- `has_punctuation' defines set

			Result := Buffer.empty
			across name.split (' ') as split loop
				if split.item_count > 0 then
					part := split.item
					if not part.item_8 (1).is_digit then
						if Result.count > 0 then
							Result.append_character (' ')
						end
						Result.append (part)
					end
				end
			end
			Result.to_lower
		end

feature {NONE} -- Field cache

	Http_command_cache_set: EL_HASH_SET [ZSTRING]
		once
			create Result.make (1000)
		end

	Referer_cache_set: EL_HASH_SET [ZSTRING]
		once
			create Result.make (1000)
		end

	Request_uri_cache_set: EL_HASH_SET [ZSTRING]
		once
			create Result.make (1000)
		end

	User_agent_uri_cache_set: EL_HASH_SET [ZSTRING]
		once
			create Result.make (1000)
		end

feature {NONE} -- Constants

	Buffer: EL_ZSTRING_BUFFER
		once
			create Result
		end

	Date_parser: EL_DATE_TIME_PARSER
		once
			Result := "[0]dd/mmm/yyyy"
		end

	Http_protocol: ZSTRING
		once
			Result := "HTTP/1."
		end

	Quote: CHARACTER_32 = '%"'

	Time_parser: EL_DATE_TIME_PARSER
		once
			Result := "[0]hh:[0]mi:[0]ss"
		end

end