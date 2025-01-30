note
	description: "Parse Apache or Cherokee web-server log entry into fields"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-01-29 8:29:53 GMT (Wednesday 29th January 2025)"
	revision: "27"

class
	EL_WEB_LOG_ENTRY

inherit
	ANY

	EL_MODULE_DATE
		rename
			Date as Date_
		end

	EL_MODULE_IP_ADDRESS ; EL_MODULE_GEOLOCATION

	EL_SET [CHARACTER_8]
		rename
			has as has_punctuation
		end

	EL_DATE_FORMATS
		export
			{NONE} all
		end

	EL_STRING_8_CONSTANTS

	EL_SHARED_STRING_8_BUFFER_POOL

create
	make, make_default

feature {NONE} -- Initialization

	make (line: STRING)
		require
			valid_line: line.occurrences (Quote) = 6
		local
			index, field_index: INTEGER; part: STRING; value_set: like new_string_set
			line_split: EL_SPLIT_ON_CHARACTER [STRING]; s: EL_STRING_8_ROUTINES
		do
			make_default
			create line_split.make (line, Quote)
			across line_split as split loop
				part := split.item; field_index := split.cursor_index
				if Field_cache_array.valid_index (field_index) then
					value_set := Field_cache_array [field_index]
				else
					value_set := Default_value_set
				end
				inspect field_index
					when 1 then
						if attached s.substring_to (part, ' ') as address then
							ip_number := Ip_address.to_number (address)
							index := part.index_of ('[', address.count + 3) + 1
						end
						compact_date := Date_parser.to_ordered_compact_date (part.substring (index, index + 10))
						index := index + 12
						compact_time := Time_parser.to_compact_time (part.substring (index, index + 7))
					when 2 then
						Http_command_set.put (s.substring_to (part, ' '))
						http_command := Http_command_set.found_item

						index := part.substring_index (Http_protocol, http_command.count + 1)
						if index.to_boolean then
							value_set.put (part.substring (http_command.count + 2, index - 2))
						else
							value_set.put_copy (Empty_string_8)
						end
						request_uri := value_set.found_item
					when 3 then
						part.adjust
						index := part.index_of (' ', 1)
						status_code := part.substring (1, index - 1).to_natural_16
						byte_count := part.substring (index + 1, part.count).to_natural
					when 4 then
						if s.is_character (part, '-') then
							value_set.put_copy (Empty_string_8)
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
			request_uri_group := Empty_string_8
			http_command := Empty_string_8
			referer := Empty_string_8
			request_uri := Empty_string_8
			user_agent := Empty_string_8
		end

feature -- Status query

	has_mobile_agent: BOOLEAN
		do
			Result := across Mobile_agents as list some
				user_agent.has_substring (list.item)
			end
		end

feature -- Element change

	set_request_uri_group (a_request_uri_group: STRING)
		do
			request_uri_group := a_request_uri_group
		end

feature -- Date/time fields

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

feature -- Log fields

	byte_count: NATURAL

	http_command: STRING

	ip_number: NATURAL

	referer: STRING

	request_uri: STRING

	status_code: NATURAL_16

	user_agent: STRING

feature -- Access

	geographic_location: ZSTRING
		do
			Result := Geolocation.for_number (ip_number)
		end

	request_stem_lower: STRING
		-- lower case first path step of `request_uri' with parameters after '?' cropped
		-- and leading '/' removed
		-- Eg. "/one/two?x=10" => "one"
		local
			slash_2_index, qm_index: INTEGER
		do
			if attached String_8_pool.borrowed_item as borrowed
				and then attached borrowed.copied_lower (request_uri) as str
			then
				qm_index := str.index_of ('?', 1)
				if qm_index > 0 then
					str.keep_head (qm_index - 1)
				end
				if str.count > 2 and then str [1] = '/' then
					slash_2_index := str.index_of ('/', 2)
					if slash_2_index > 0 then
						str.keep_head (slash_2_index - 1)
					end
					str.remove_head (1) -- removes '/'
				end
				Request_stem_set.put_copy (str)
				Result := Request_stem_set.found_item
				borrowed.return
			else
				Result := Empty_string_8
			end
		end

	request_uri_group: STRING
		-- used in report analysis and set externally

	normalized_user_agent: STRING
		-- lower case `user_agent' stripped of punctuation and version numbers
		do
			Result := stripped_lower (user_agent).joined_words
		end

feature -- Basic operations

	cache_location
		-- add geographic location to built-in cache
		do
			if attached Geolocation.for_number (ip_number) then
				do_nothing
			end
		end

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

	new_string_set: EL_HASH_SET [STRING]
		do
			create Result.make_equal (3)
		end

	stripped_lower (a_name: STRING): EL_STRING_8_LIST
		-- if `a_name' is "Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101 Firefox/78.0"
		-- `Result.joined_words' is "firefox linux rv x11 x86_64"
		local
			name: STRING; name_split: EL_SPLIT_ON_CHARACTER [STRING]
			s: EL_STRING_8_ROUTINES
		do
			if attached String_8_pool.borrowed_item as borrowed then
				name := borrowed.copied_lower (a_name)
				s.replace_set_members (name, Current, ' ') -- set defined by function `has_punctuation'

				Result := List_buffer
				Result.wipe_out
				create name_split.make (name, ' ')
				across name_split as split loop
					if split.item_count > 0 then
						Agent_word_set.put_copy (split.item)
						if attached Agent_word_set.found_item as part
							and then not part [1].is_digit and then not Excluded_agents_words.has (part)
						then
							Result.extend (part)
						end
					end
				end
				borrowed.return
			end
			Result.unique_sort
		end

feature {NONE} -- String sets

	Agent_word_set: EL_HASH_SET [STRING]
		once
			Result := Field_cache_array [1]
		end

	Default_value_set: EL_HASH_SET [STRING]
		once
			create Result.make_equal (0)
		end

	Field_cache_array: ARRAY [EL_HASH_SET [STRING]]
		once
			create Result.make_filled (Default_value_set, 1, Field_count)
			across 1 |..| Field_count as index loop
				Result [index.item] := new_string_set
			end
		end

	Http_command_set: EL_HASH_SET [STRING]
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

	Excluded_agents_words: EL_STRING_8_LIST
		once
			Result := "compatible, like, chrome, gecko, khtml, mozilla, safari"
		end

	Field_count: INTEGER = 6

	Http_protocol: STRING = "HTTP/1."

	List_buffer: EL_STRING_8_LIST
		once
			create Result.make (10)
		end

	Mobile_agents: EL_STRING_8_LIST
		once
			Result := "mobile, Mobile"
		end

	Quote: CHARACTER = '%"'

	Request_stem_set: EL_HASH_SET [STRING]
		once
			create Result.make_equal (500)
		end

end