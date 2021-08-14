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
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-08-14 11:14:25 GMT (Saturday 14th August 2021)"
	revision: "1"

deferred class
	EL_DATE_TIME_UTILITY

inherit
	EL_STRING_8_CONSTANTS

	EL_MODULE_DATE_TIME

feature {NONE} -- Initialization

	make_with_format (s: STRING; format: STRING)
		do
			if attached String_8_pool.new_scope as pool and then attached pool.reuse_item as str then
				str.append (s)
				if attached Parser_table.item (format) as parser then
					parser.set_source_string (str)
					parser.parse
					make_with_parser (parser)
				end
				pool.recycle_end (str)
			end
		end

	make_with_parser (parser: EL_DATE_TIME_PARSER)
		deferred
		end

feature -- Access

	formatted_out (format: STRING): STRING
		do
			if attached String_8_pool.new_scope as pool and then attached pool.reuse_item as str then
				append_to (str, format)
				Result := str.twin
				pool.recycle_end (str)
			end
		end

	to_string: STRING
		do
			Result := out
		end

feature -- Basic operations

	append_to (general: STRING_GENERAL; format: STRING)
		local
			index: INTEGER; str: STRING
			pool: like String_8_pool.new_scope
		do
			if attached {STRING_8} general as str_8 then
				str := str_8
			else
				pool := String_8_pool.new_scope
				str := pool.reuse_item
			end
			append_to_string_8 (str, format)
			if general /= str then
				general.append (str)
				pool.recycle_end (str)
			end
		end

	append_to_string_8 (str, format: STRING)
		deferred
		end

feature -- Contract support

	input_valid (s: STRING; format: STRING): BOOLEAN
		do
			if attached String_8_pool.new_scope as pool and then attached pool.reuse_item as str then
				str.append (s); str.to_upper
				Result := upper_input_valid (str, format)
				pool.recycle_end (str)
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