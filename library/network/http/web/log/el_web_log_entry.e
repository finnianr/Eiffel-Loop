note
	description: "Parse Apache or Cherokee web-server log entry into fields"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-24 13:52:40 GMT (Thursday 24th April 2025)"
	revision: "42"

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
			line_split: EL_SPLIT_ON_CHARACTER_8 [STRING]; sg: EL_STRING_GENERAL_ROUTINES
			index, offset, field_index, qmark_index: INTEGER; part: STRING;
		do
			make_default
			create line_split.make (line, Quote)
			across line_split as split loop
				part := split.item; field_index := split.cursor_index
				inspect field_index
					when 1 then
						index := part.index_of (' ', 1)
						if index > 0 then
							ip_number := Ip_address.substring_as_number (part, 1, index - 1)
							index := part.index_of ('[', index + 1) + 1
							if index > 0 then
								compact_date := Date_parser.to_ordered_compact_date (part.substring (index, index + 10))
								index := index + 12
								compact_time := Time_parser.to_compact_time (part.substring (index, index + 7))
							end
						end
					when 2 then
						http_command := shared_string (Http_command_set, sg.super_8 (part).substring_to (' '))

						index := part.substring_index (Http_protocol, http_command.count + 1)
						if index.to_boolean then
							offset := 2
							if part [http_command.count + offset] = '/' then
								is_absolute_uri := True
								offset := offset + 1
							end
							if attached String_8_pool.biggest_item as borrowed
								and then attached borrowed.copied_substring (part, http_command.count + offset, index - 2) as uri
							then
								uri.right_adjust; uri.to_lower
								if uri.count > 0 then
									qmark_index := uri.index_of ('?', 1)
									if qmark_index > 0 then
										uri_parameters := uri.substring (qmark_index + 1, uri.count)
										uri.keep_head (qmark_index - 1)
									end
									uri_path := shared_string (Request_uri_path_set, uri)
									uri_extension := shared_string (Word_part_set, new_uri_extension (uri))
									keep_first_step (uri)
									uri_step := shared_string (Request_uri_path_set, uri)
								end
								borrowed.return
							end
						end
					when 3 then
						part.adjust
						index := part.index_of (' ', 1)
						status_code := part.substring (1, index - 1).to_natural_16
						byte_count := part.substring (index + 1, part.count).to_natural
					when 4 then
						if not sg.super_8 (part).is_character ('-') then
							referer := shared_string (Referer_set, part)
						end
					when Field_count then
						if part.count > 0 then
							user_agent := shared_string (Agent_word_set, part)
						end

				else
					do_nothing
				end
			end
		end

	make_default
		do
			http_command := Empty_string_8
			referer := Empty_string_8
			uri_extension := Empty_string_8
			uri_group := Empty_string_8
			uri_parameters := Empty_string_8
			uri_path := Empty_string_8
			uri_step := Empty_string_8
			user_agent := Empty_string_8
		end

feature -- Status query

	has_mobile_agent: BOOLEAN
		do
			Result := across Mobile_agents as list some
				user_agent.has_substring (list.item)
			end
		end

	has_excess_digits: BOOLEAN
		require
			digit_count_set: maximum_uri_digits > 0
		do
			if attached String_pool.borrowed_item as borrowed then
				Result := digit_count_exceeded (borrowed.copied_general (uri_path))
				borrowed.return
			end
		end

	is_absolute_uri: BOOLEAN
		-- `True' if request URI starts with '\'

feature -- Element change

	set_uri_group (a_uri_group: STRING)
		do
			uri_group := a_uri_group
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
		-- full uri with parameters and leading '/' if `is_absolute_uri' is true
		do
			create Result.make (uri_path.count + uri_parameters.count + 2)
			if is_absolute_uri then
				Result.append_character ('/')
			end
			Result.append (uri_path)
			if uri_parameters.count > 0 then
				Result.append_character ('?')
				Result.append (uri_parameters)
			end
		end

	status_code: NATURAL_16

	user_agent: STRING

feature -- Request parts

	uri_path: STRING
		-- `uri' path relative to root '/' and trimmed of any parameters

	uri_parameters: STRING

	uri_step: STRING
		-- lower case first path step of request URI with parameters after '?' cropped
		-- and leading '/' removed
		-- Eg. "/one/two?x=10" => "one"

	uri_extension: STRING
		-- dot extension of `request_uri'
		-- empty string if no dot extension or is not composed of alphabetical characters.

	uri_group: STRING
		-- used in report analysis and set externally

feature -- Access

	geographic_location: ZSTRING
		do
			Result := Geolocation.for_number (ip_number)
		end

	normalized_user_agent: STRING
		-- lower case `user_agent' stripped of punctuation and version numbers
		do
			Result := stripped_lower (user_agent).as_word_string
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
			across <<
				Agent_word_set, Http_command_set, Referer_set, Request_uri_path_set, Word_part_set
			>> as list loop
				list.item.wipe_out
			end
		end

end