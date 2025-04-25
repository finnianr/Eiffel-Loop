note
	description: "Routines to supplement handling of ${STRING_8} ${STRING_32} strings"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-25 6:57:38 GMT (Friday 25th April 2025)"
	revision: "87"

deferred class
	EL_STRING_X_ROUTINES [
		STRING_X -> STRING_GENERAL create make end, READABLE_STRING_X -> READABLE_STRING_GENERAL,
		CHAR -> COMPARABLE -- CHARACTER_X
	]

inherit
	EL_READABLE_STRING_X_ROUTINES [READABLE_STRING_X, CHAR]

	EL_MODULE_ITERABLE

feature -- Factory

	new (n: INTEGER): STRING_X
		do
			create Result.make (n)
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
			Result := new (a.count + b.count)
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
			char_count := Iterable.character_count (list, 1)
			Result := new (char_count)
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
			char_count := Iterable.character_count (list, separator.count)
			Result := new (char_count)
			across list as ln loop
				if Result.count > 0 then
					append_to (Result, separator)
				end
				append_to (Result, ln.item)
			end
		end

	joined_with (a, b, separator: READABLE_STRING_X): STRING_X
		do
			Result := new (a.count + b.count + separator.count)
			append_to (Result, a); append_to (Result, separator); append_to (Result, b)
		end

feature {NONE} -- Deferred

	append_to (str: STRING_X; extra: READABLE_STRING_GENERAL)
		deferred
		end

	set_upper (str: STRING_X; i: INTEGER)
		require
			valid_index: 0 < i and i <= str.count
		deferred
		end

end