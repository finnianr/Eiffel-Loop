note
	description: "Parse Apache or Cherokee web-server log entry into fields"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-09 12:02:04 GMT (Sunday 9th February 2025)"
	revision: "35"

class
	EL_WEB_LOG_ENTRY

inherit
	ANY

	EL_WEB_LOG_ENTRY_BASE

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

	normalized_user_agent: STRING
		-- lower case `user_agent' stripped of punctuation and version numbers
		do
			Result := stripped_lower (user_agent).joined_words
		end

	request_uri_step: STRING
		-- lower case first path step of `request_uri' with parameters after '?' cropped
		-- and leading '/' removed
		-- Eg. "/one/two?x=10" => "one"
		local
			slash_index: INTEGER
		do
			if attached String_8_pool.borrowed_item as borrowed
				and then attached trimmed_request_uri (borrowed) as str
			then
				slash_index := str.index_of ('/', 1)
				if slash_index > 0 then
					str.keep_head (slash_index - 1)
				end
				str.to_lower
				Word_part_set.put_copy (str)
				Result := Word_part_set.found_item
				borrowed.return
			else
				Result := Empty_string_8
			end
		end

	request_uri_extension: STRING
		-- dot extension of `request_uri'
		-- empty string if no dot extension or is not composed of alphabetical characters.
		local
			dot_index, slash_index: INTEGER; s8: EL_STRING_8_ROUTINES
		do
			Result := Empty_string_8
			if attached String_8_pool.borrowed_item as borrowed
				and then attached trimmed_request_uri (borrowed) as str
			then
				dot_index := str.last_index_of ('.', str.count)
				slash_index := str.last_index_of ('/', str.count)
				if dot_index > 0 and then dot_index > slash_index + 1 then
					str.keep_tail (str.count - dot_index)
					str.to_lower
					if s8.is_alpha_numeric (str) then
						Word_part_set.put_copy (str)
						Result := Word_part_set.found_item
					end
				end
				borrowed.return
			end
		end

	request_uri_group: STRING
		-- used in report analysis and set externally

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

	trimmed_request_uri (buffer: EL_STRING_8_BUFFER_I): STRING
		-- buffered characters of `request_uri' between leading '/' and '?'
		local
			start_index, end_index: INTEGER
		do
			if attached request_uri as uri then
				if uri.count > 0 then
					start_index := if uri [1] = '/' then 2 else 1 end
					end_index := uri.index_of ('?', start_index)
					if end_index = 0 then
						end_index := uri.count
					else
						end_index := end_index - 1
					end
				else
					start_index := 1
				end
			end
			Result := buffer.copied_substring (request_uri, start_index, end_index)
		end

end