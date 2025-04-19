note
	description: "Routines to supplement handling of ${STRING_8} ${STRING_32} strings"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-19 7:47:32 GMT (Saturday 19th April 2025)"
	revision: "84"

deferred class
	EL_STRING_X_ROUTINES [
		STRING_X -> STRING_GENERAL create make end, READABLE_STRING_X -> READABLE_STRING_GENERAL,
		C -> COMPARABLE -- CHARACTER_X
	]

inherit
	EL_READABLE_STRING_X_ROUTINES [READABLE_STRING_X, C]

feature -- Factory

	new (n: INTEGER): STRING_X
			-- width * count spaces
		do
			create Result.make (n)
		end

	new_from_immutable_8 (
		str: IMMUTABLE_STRING_8; start_index, end_index: INTEGER_32; unindent, utf_8_encoded: BOOLEAN

	): STRING_X
		-- new string of type `STRING_X' consisting of decoded UTF-8 text

		--		`str.shared_substring (start_index, end_index)'

		-- if `unindent' is true, and character at `start_index' is a tab, then all lines
		-- are unindented by one tab.
		require
			valid_start_index: str.valid_index (start_index)
			valid_end_index: end_index >= start_index implies str.valid_index (end_index)
		do
			if end_index - start_index + 1 = 0 then
				create Result.make (0)

			elseif unindent and then str [start_index] = '%T' then
				if attached str.shared_substring (start_index + 1, end_index) as lines then
					if lines.has ('%N') and then attached Immutable_string_8_split_list [utf_8_encoded] as split_list then
						split_list.fill_by_string (lines, New_line_tab, 0)
						if split_list.count > 0 then
							create Result.make (split_list.unicode_count + split_list.count - 1)
							append_lines_to (Result, split_list)
						else
							create Result.make (0)
						end
					else
						Result := new_from_string_8 (lines, utf_8_encoded)
					end
				end
			else
				Result := new_from_string_8 (str.shared_substring (start_index, end_index), utf_8_encoded)
			end
		ensure
			calculated_correct_size: Result.count = Result.capacity
		end

	new_from_string_8 (str: READABLE_STRING_8; utf_8_encoded: BOOLEAN): STRING_X
		local
			u8: EL_UTF_8_CONVERTER
		do
			if utf_8_encoded then
				create Result.make (u8.unicode_count (str))
				append_utf_8_to (str, Result)
			else
				Result := new (str.count)
				Result.append (str)
			end
		end

	new_list (comma_separated: STRING_X): EL_STRING_LIST [STRING_X]
		deferred
		end

	new_retrieved (file_path: FILE_PATH): STRING_X
		-- new instace of type `STRING_X' restored from file saved by Studio debugger
		local
			file: RAW_FILE
		do
			create file.make_open_read (file_path)
			if attached {STRING_X} file.retrieved as debug_str then
				Result := debug_str
			else
				Result := new (0)
			end
			file.close
		end

feature -- List joining

	joined (a, b: READABLE_STRING_GENERAL): STRING_X
		do
			create Result.make (a.count + b.count)
			append_to (Result, a); append_to (Result, b)
		end

	joined_lines (list: ITERABLE [READABLE_STRING_GENERAL]): STRING_X
		do
			Result := joined_list (list, '%N')
		end

	joined_list (list: ITERABLE [READABLE_STRING_GENERAL]; separator: CHARACTER_32): STRING_X
		local
			char_count: INTEGER; code: NATURAL_32
		do
			code := to_code (separator) -- might be z_code for ZSTRING
			char_count := character_count (list, 1)
			create Result.make (char_count)
			across list as ln loop
				if Result.count > 0 then
					Result.append_code (code)
				end
				append_to (Result, ln.item)
			end
		end

	joined_list_with (list: ITERABLE [READABLE_STRING_GENERAL]; separator: READABLE_STRING_GENERAL): STRING_X
		local
			char_count: INTEGER
		do
			char_count := character_count (list, separator.count)
			create Result.make (char_count)
			across list as ln loop
				if Result.count > 0 then
					append_to (Result, separator)
				end
				append_to (Result, ln.item)
			end
		end

	joined_with (a, b, separator: READABLE_STRING_X): STRING_X
		do
			create Result.make (a.count + b.count + separator.count)
			append_to (Result, a); append_to (Result, separator); append_to (Result, b)
		end

feature -- Transform

	first_to_upper (str: STRING_GENERAL)
		do
			if not str.is_empty then
				str.put_code (to_code (str.item (1).as_upper), 1)
			end
		end

feature {NONE} -- Deferred

	append_lines_to (str: STRING_X; lines: EL_SPLIT_IMMUTABLE_STRING_8_LIST)
		deferred
		end

	append_to (str: STRING_X; extra: READABLE_STRING_GENERAL)
		deferred
		end

	append_utf_8_to (utf_8: READABLE_STRING_8; output: STRING_X)
		deferred
		end

	set_upper (str: STRING_X; i: INTEGER)
		require
			valid_index: 0 < i and i <= str.count
		deferred
		end

feature {NONE} -- Constants

	Immutable_string_8_split_list: EL_BOOLEAN_INDEXABLE [EL_SPLIT_IMMUTABLE_STRING_8_LIST]
		once
			create Result.make (
				create {EL_SPLIT_IMMUTABLE_STRING_8_LIST}.make_empty, -- False -> latin-1
				create {EL_SPLIT_IMMUTABLE_UTF_8_LIST}.make_empty		-- True  -> UTF-8
			)
		end

	New_line_tab: STRING = "%N%T"

end