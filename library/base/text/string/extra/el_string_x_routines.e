note
	description: "Create and join lists of strings conforming to ${STRING_GENERAL}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-06 9:53:51 GMT (Tuesday 6th May 2025)"
	revision: "90"

deferred class
	EL_STRING_X_ROUTINES [
		STRING_X -> STRING_GENERAL create make end, READABLE_STRING_X -> READABLE_STRING_GENERAL,
		CHAR -> COMPARABLE -- CHARACTER_X
	]

inherit
	EL_READABLE_STRING_X_ROUTINES [READABLE_STRING_X, CHAR]

	EL_CONTAINER_CONVERSION [READABLE_STRING_GENERAL]

feature -- Factory

	new (n: INTEGER): STRING_X
		do
			create Result.make (n)
		end

	new_list (comma_separated: STRING_X): EL_STRING_LIST [STRING_X]
		deferred
		end

	new_retrieved (file_path: FILE_PATH): STRING_X
		-- new instance of type `STRING_X' restored from file saved by Studio debugger
		local
			file: RAW_FILE
		do
			create file.make_open_read (file_path)
			if attached {STRING_X} file.retrieved as debug_str then
				Result := debug_str

			elseif attached {READABLE_STRING_GENERAL} file.retrieved as debug_general then
				Result := new (debug_general.count)
				append_to (Result, debug_general)
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
		ensure
			correct_character_count: Result.count = capacity (Result)
		end

	joined_lines (container: CONTAINER [READABLE_STRING_GENERAL]): STRING_X
		do
			Result := joined_list (container, '%N')
		end

	joined_list (container: CONTAINER [READABLE_STRING_GENERAL]; separator: CHARACTER_32): STRING_X
		local
			code: NATURAL_32
		do
			code := to_code (separator) -- might be z_code for ZSTRING
			if attached as_structure (container).to_special_shared as special_area then
				Result := new (character_count (special_area, 1))
				across special_area as area loop
					if Result.count > 0 then
						Result.append_code (code)
					end
					append_to (Result, area.item)
				end
			else
				Result := new (0)
			end
		ensure
			correct_character_count: Result.count = capacity (Result)
		end

	joined_with_string (container: CONTAINER [READABLE_STRING_GENERAL]; separator: READABLE_STRING_GENERAL): STRING_X
		do
			if attached as_structure (container).to_special_shared as special_area then
				Result := new (character_count (special_area, separator.count))
				across special_area as area loop
					if Result.count > 0 then
						append_to (Result, separator)
					end
					append_to (Result, area.item)
				end
			else
				Result := new (0)
			end
		ensure
			correct_character_count: Result.count = capacity (Result)
		end

	joined_with (a, b, separator: READABLE_STRING_X): STRING_X
		do
			Result := new (a.count + b.count + separator.count)
			append_to (Result, a); append_to (Result, separator); append_to (Result, b)
		ensure
			correct_character_count: Result.count = capacity (Result)
		end

feature {NONE} -- Implementation

	character_count (area: SPECIAL [READABLE_STRING_GENERAL]; separator_count: INTEGER): INTEGER
		local
			i: INTEGER
		do
			Result := separator_count * (area.count - 1)
			from i := 0 until i = area.count loop
				Result := Result + area [i].count
				i := i + 1
			end
		end

feature {NONE} -- Deferred

	capacity (str: STRING_X): INTEGER
		deferred
		end

	append_to (str: STRING_X; extra: READABLE_STRING_GENERAL)
		deferred
		end

end