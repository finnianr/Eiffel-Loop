note
	description: "Parse Apache or Cherokee web-server log entry"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-01-22 12:07:09 GMT (Wednesday 22nd January 2025)"
	revision: "22"

class
	EL_WEB_LOG_ENTRY

inherit
	ANY

	EL_MODULE_DATE
		rename
			Date as Date_
		end

	EL_MODULE_IP_ADDRESS

	EL_ZSTRING_CONSTANTS

	EL_SET [CHARACTER_8]
		rename
			has as has_punctuation
		end

	EL_DATE_FORMATS
		export
			{NONE} all
		end

	EL_SHARED_ZSTRING_BUFFER_POOL

create
	make, make_default

feature {NONE} -- Initialization

	make (line: ZSTRING)
		require
			valid_line: line.occurrences (Quote) = 6
		local
			index, field_index: INTEGER; part: ZSTRING; value_set: like new_string_set
		do
			make_default
			across line.split (Quote) as list loop
				part := list.item; field_index := list.cursor_index
				if Field_cache_array.valid_index (field_index) then
					value_set := Field_cache_array [field_index]
				else
					value_set := Default_value_set
				end
				inspect field_index
					when 1 then
						if attached part.substring_to (' ') as address then
							ip_number := Ip_address.to_number (address)
							index := part.index_of ('[', address.count + 3) + 1
						end
						compact_date := Date_parser.to_ordered_compact_date (part.substring (index, index + 10))
						index := index + 12
						compact_time := Time_parser.to_compact_time (part.substring (index, index + 7))
					when 2 then
						Http_command_set.put (part.substring_to (' '))
						http_command := Http_command_set.found_item

						index := part.substring_index (Http_protocol, http_command.count + 1)
						if index.to_boolean then
							value_set.put (part.substring (http_command.count + 2, index - 2))
						else
							value_set.put_copy (Empty_string)
						end
						request_uri := value_set.found_item
					when 3 then
						part.adjust
						index := part.index_of (' ', 1)
						status_code := part.substring (1, index - 1).to_natural
						byte_count := part.substring_end (index + 1).to_natural
					when 4 then
						if part.is_character ('-') then
							value_set.put_copy (Empty_string)
						else
							value_set.put_copy (part)
						end
						referer := value_set.found_item
					when Field_count then
						value_set.put_copy (part)
						user_agent := value_set.found_item

				else end
			end
		end

	make_default
		do
			request_uri_group := Empty_string
			http_command := Empty_string
			referer := Empty_string
			request_uri := Empty_string
			user_agent := Empty_string
		end

feature -- Status query

	is_selected: BOOLEAN
		do
			Result := request_uri_group.count > 0
		end

	has_mobile_agent: BOOLEAN
		do
			Result := across Mobile_agents as list some
				user_agent.has_substring (list.item)
			end
		end

feature -- Element change

	set_request_uri_group (a_request_uri_group: ZSTRING)
		do
			request_uri_group := a_request_uri_group
		end

feature -- Date/time

	compact_date: INTEGER
		-- Year, month, day coded for fast comparison between dates.

	compact_time: INTEGER
		-- Hour, minute, second coded.

	date: EL_DATE
		do
			create Result.make_by_ordered_compact_date (compact_date)
		end

	month_year: STRING
		do
			Result := Date_.formatted (date, Month_year_format)
		end

	time: EL_TIME
		do
			create Result.make_by_compact_time (compact_time)
		end

feature -- Access

	request_uri_group: ZSTRING
		-- used in report analysis and set externally

	byte_count: NATURAL

	http_command: ZSTRING

	ip_number: NATURAL

	referer: ZSTRING

	request_uri: ZSTRING

	status_code: NATURAL

	stripped_user_agent: ZSTRING
		-- lower case `user_agent' stripped of punctuation and version numbers
		do
			Result := stripped_lower (user_agent).joined_words
			Result.to_lower
		end

	user_agent: ZSTRING

feature -- Basic operations

	reset_cache
		-- reset field cache
		do
			across Field_cache_array as list loop
				list.item.wipe_out
			end
		end

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

	new_string_set: EL_HASH_SET [ZSTRING]
		do
			create Result.make_equal (3)
		end

	stripped_lower (a_name: ZSTRING): EL_ZSTRING_LIST
		-- if `a_name' is "Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101 Firefox/78.0"
		-- `Result.joined_words' is "firefox linux rv x11 x86_64"
		local
			name, part: ZSTRING
		do
			if attached String_pool.borrowed_item as borrowed then
				name := borrowed.copied (a_name)
				name.replace_set_members_8 (Current, ' ') -- `has_punctuation' defines set
				name.to_lower

				Result := List_buffer
				Result.wipe_out
				across name.split (' ') as split loop
					if split.item_count > 0 then
						Agent_word_set.put_copy (split.item)
						part := Agent_word_set.found_item
						if not part.item_8 (1).is_digit and then not Excluded_agents_words.has (part) then
							Result.extend (part)
						end
					end
				end
				borrowed.return
			end
			Result.unique_sort
		end

feature {NONE} -- String sets

	Agent_word_set: EL_HASH_SET [ZSTRING]
		once
			Result := Field_cache_array [1]
		end

	Default_value_set: EL_HASH_SET [ZSTRING]
		once
			create Result.make_equal (0)
		end

	Field_cache_array: ARRAY [EL_HASH_SET [ZSTRING]]
		once
			create Result.make_filled (Default_value_set, 1, Field_count)
			across 1 |..| Field_count as index loop
				Result [index.item] := new_string_set
			end
		end

	Http_command_set: EL_HASH_SET [ZSTRING]
		once
			Result := Field_cache_array [1]
		end

feature {NONE} -- Date/Time

	Date_parser: EL_DATE_TIME_PARSER
		once
			Result := "[0]dd/mmm/yyyy"
		end

	Month_year_format: STRING
		once
			Result := new_format (<< Var.long_month_name, Var.year >>)
		end

	Time_parser: EL_DATE_TIME_PARSER
		once
			Result := "[0]hh:[0]mi:[0]ss"
		end

feature {NONE} -- Constants

	Excluded_agents_words: EL_ZSTRING_LIST
		once
			Result := "compatible, like, chrome, gecko, khtml, mozilla, safari"
		end

	List_buffer: EL_ZSTRING_LIST
		once
			create Result.make (10)
		end

	Field_count: INTEGER = 6

	Http_protocol: ZSTRING
		once
			Result := "HTTP/1."
		end

	Mobile_agents: EL_ZSTRING_LIST
		once
			Result := "mobile, Mobile"
		end

	Quote: CHARACTER_32 = '%"'

end