note
	description: "Routines for date time classes"
	descendants: "[
			EL_DATE_TIME_UTILITY*
				[$source EL_DATE]
				[$source EL_TIME]
				[$source EL_DATE_TIME]
					[$source EL_ISO_8601_DATE_TIME]
					[$source PP_DATE_TIME]
					[$source EL_SHORT_ISO_8601_DATE_TIME]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "6"

deferred class
	EL_DATE_TIME_UTILITY

inherit
	EL_MODULE_DATE_TIME

	EL_MODULE_REUSEABLE

feature {NONE} -- Initialization

	make_with_format (s: STRING; format: STRING)
		do
			across Reuseable.string_8 as reuse loop
				if attached reuse.item as str then
					str.append (s)
					if attached Parser_table.item (format) as parser then
						parser.parse_source (str)
						make_with_parser (parser)
					end
				end
			end
		end

	make_with_parser (parser: EL_DATE_TIME_PARSER)
		deferred
		end

feature -- Access

	formatted_out (format: STRING): STRING
		do
			across Reuseable.string_8 as reuse loop
				if attached reuse.item as str then
					append_to (str, format)
					Result := str.twin
				end
			end
		end

	to_string: STRING
		do
			Result := out
		end

feature -- Basic operations

	append_to (general: STRING_GENERAL; format: STRING)
		do
			if attached {STRING_8} general as str_8 then
				append_to_string_8 (str_8, format)
			else
				across Reuseable.string_8 as reuse loop
					append_to_string_8 (reuse.item, format)
					general.append (reuse.item)
				end
			end
		end

	append_to_string_8 (str, format: STRING)
		local
			old_count: INTEGER
		do
			old_count := str.count
			if attached Code_string_table.item (format) as code then
				code.append_to (str, to_shared_date_time)
			end
			check_case (format, str, old_count + 1)
		ensure
			corresponds_to_format: attached Code_string_table.item (format) as code
											implies code.correspond (str.substring (old str.count + 1, str.count))
		end

feature -- Contract support

	input_valid (s: STRING; format: STRING): BOOLEAN
		do
			across Reuseable.string_8 as reuse loop
				if attached reuse.item as str then
					str.append (s); str.to_upper
					Result := upper_input_valid (str, format)
				end
			end
		end

feature {NONE} -- Implementation

	check_case (format, str: STRING; start_index: INTEGER)
		-- Turn Upper case month and day names into propercase if the
		-- format code is propercase
		local
			index: INTEGER
		do
			across Propercase_table as table loop
				if format.has_substring (table.key) then
					across table.item as values_list until index > 0 loop
						index := str.substring_index (values_list.item, start_index)
						if index > 0 then
							str [index + 1] := str [index + 1].as_lower
							str [index + 2] := str [index + 2].as_lower
						end
					end
				end
			end
		end

	new_code_string (format: STRING): EL_DATE_TIME_CODE_STRING
		do
			create Result.make (format)
		end

	new_parser (format: STRING): EL_DATE_TIME_PARSER
		do
			Result := Code_string_table.item (format).new_parser
		end

	to_shared_date_time: DATE_TIME
		deferred
		end

	upper_input_valid (upper_str: STRING; format: STRING): BOOLEAN
		do
			if attached Code_string_table.item (format) as code then
				Result := valid_string_for_code (upper_str, code)
			end
		end

	valid_string_for_code (str: STRING; code: EL_DATE_TIME_CODE_STRING): BOOLEAN
		deferred
		end

feature {NONE} -- Constants

	Code_string_table: EL_CACHE_TABLE [EL_DATE_TIME_CODE_STRING, STRING]
		once
			create Result.make (11, agent new_code_string)
		end

	Once_date_time: DATE_TIME
		once
			create Result.make (1, 1, 1, 1, 1, 1)
		end

	Parser_table: EL_CACHE_TABLE [EL_DATE_TIME_PARSER, STRING]
		once
			create Result.make (11, agent new_parser)
		end

	Propercase_table: EL_HASH_TABLE [ARRAY [STRING], STRING]
		once
			create Result.make (<<
				["Mmm", Date_time.Months_text],
				["Ddd", Date_time.Days_text]
			>>)
		end
end