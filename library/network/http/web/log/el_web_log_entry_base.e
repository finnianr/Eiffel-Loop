note
	description: "Implementation base for ${EL_WEB_LOG_ENTRY}"
	notes: "Rename *_IMPLEMENTATION to *_BASE"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-20 12:14:13 GMT (Thursday 20th February 2025)"
	revision: "4"

deferred class
	EL_WEB_LOG_ENTRY_BASE

inherit
	EL_URI_FILTER_BASE
		export
			{NONE} all
			{ANY} set_maximum_uri_digits, maximum_uri_digits
		end

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

	EL_SHARED_STRING_8_BUFFER_POOL; EL_SHARED_ZSTRING_BUFFER_POOL

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

	keep_first_step (uri: STRING)
		-- keep only the first step of `uri'
		local
			slash_index: INTEGER
		do
			slash_index := uri.index_of ('/', 1)
			if slash_index > 0 then
				uri.keep_head (slash_index - 1)
			end
		end

	match_output_dir: DIR_PATH
		-- location of "match-*.txt" files for use in EL_URI_FILTER_TABLE
		do
			create Result
		end

	new_uri_extension (uri: STRING): STRING
		local
			dot_index, slash_index: INTEGER; s8: EL_STRING_8_ROUTINES
			extension: STRING
		do
			Result := Empty_string_8

			dot_index := uri.last_index_of ('.', uri.count)
			slash_index := uri.last_index_of ('/', uri.count)
			if dot_index > 0 and then dot_index > slash_index + 1 then
				extension := uri.substring (dot_index + 1, uri.count)
				if s8.is_alpha_numeric (Result) then
					Result := extension
				end
			end
		end

	shared_string (string_set: EL_HASH_SET [STRING]; str: STRING): STRING
		do
			if str.is_empty then
				Result := Empty_string_8
			else
				string_set.put_copy (str)
				Result := string_set.found_item
			end
		end

	stripped_lower (a_name: STRING): EL_STRING_8_LIST
		-- if `a_name' is "Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101 Firefox/78.0"
		-- `Result.joined_words' is "firefox linux rv x11 x86_64"
		local
			name: STRING; name_split: EL_SPLIT_ON_CHARACTER_8 [STRING]
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
			create Result.make_equal (500)
		end

	Http_command_set: EL_HASH_SET [STRING]
		once
			create Result.make_equal (5)
		end

	Referer_set: EL_HASH_SET [STRING]
		once
			create Result.make_equal (500)
		end

	Request_uri_path_set: EL_HASH_SET [STRING]
		once
			create Result.make_equal (500)
		end

	Word_part_set: EL_HASH_SET [STRING]
		once
			create Result.make_equal (500)
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

end