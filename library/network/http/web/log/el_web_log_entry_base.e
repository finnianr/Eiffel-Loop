note
	description: "Implementation base for ${EL_WEB_LOG_ENTRY}"
	notes: "Rename *_IMPLEMENTATION to *_BASE"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-07 10:20:58 GMT (Friday 7th February 2025)"
	revision: "1"

deferred class
	EL_WEB_LOG_ENTRY_BASE

inherit
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

	Word_part_set: EL_HASH_SET [STRING]
		once
			create Result.make_equal (500)
		end

end