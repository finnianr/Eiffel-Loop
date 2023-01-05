note
	description: "String escaper"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-05 15:49:43 GMT (Thursday 5th January 2023)"
	revision: "16"

class
	EL_STRING_ESCAPER [S -> STRING_GENERAL create make end]

inherit
	HASH_TABLE [NATURAL, NATURAL]
		rename
			make as make_table,
			found_item as found_code,
			has_key as has_code
		export
			{NONE} all
			{EL_STRING_ESCAPER_IMP} has_code, found_code
		end

create
	make

feature {NONE} -- Initialization

	make (escape_table: EL_ESCAPE_TABLE)
		do
			set_implementation
			escape_code := implementation.to_code (escape_table.escape_character)

			make_table (escape_table.count)
			across escape_table as table loop
				extend (implementation.to_code (table.item), implementation.to_code (table.key))
			end
		end

feature -- Access

	escape_code: NATURAL

feature -- Conversion

	escaped (str: READABLE_STRING_GENERAL; keeping_ref: BOOLEAN): S
		do
			Result := escaped_substring (str, 1, str.count, keeping_ref)
		end

	escaped_substring (str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER; keeping_ref: BOOLEAN): S
		-- escaped `str' in once buffer
		-- when keeping a reference to `Result' specify `keeping_ref' as `True'
		do
			Result := implementation.empty_buffer

			if has_escaped (str, start_index, end_index) then
				escape_substring_into (str, start_index, end_index, Result)

			elseif start_index = 1 and then end_index = str.count and then attached {S} str as same_str then
				Result := same_str
			else
				Result.append_substring (str, start_index, end_index.min (str.count))
			end
			if keeping_ref then
				Result := Result.twin
			end
		end

feature -- Basic operations

	escape_into (str: READABLE_STRING_GENERAL; output: S)
		do
			escape_substring_into (str, 1, str.count, output)
		end

	escape_substring_into (str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER; output: S)
		local
			i, min_index: INTEGER; code: NATURAL; compatible_type: BOOLEAN
		do
			min_index := str.count.min (end_index)
			compatible_type := attached {S} str
			if attached implementation as imp then
				from i := start_index until i > min_index loop
					if compatible_type then
						code := str.code (i)
					else
						code := imp.to_code (str [i])
					end
					if imp.is_escaped (Current, code) then
						imp.append_escape_sequence (Current, output, code)
					else
						output.append_code (code)
					end
					i := i + 1
				end
			end
		end

feature {NONE} -- Internal attributes

	implementation: EL_STRING_ESCAPER_IMP [S]

feature {NONE} -- Implementation

	has_escaped (str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): BOOLEAN
		local
			i, min_index: INTEGER; compatible_type: BOOLEAN
		do
			min_index := str.count.min (end_index)
			compatible_type := attached {S} str
			if attached implementation as imp then
				from i := start_index until Result or i > min_index loop
					if compatible_type then
						Result := imp.is_escaped (Current, str.code (i))
					else
						Result := imp.is_escaped (Current, imp.to_code (str [i]))
					end
					i := i + 1
				end
			end
		end

	set_implementation
		do
			if attached {like implementation} Zstring_imp as imp then
				implementation := imp

			elseif attached {like implementation} String_32_imp as imp then
				implementation := imp

			elseif attached {like implementation} String_8_imp as imp then
				implementation := imp
			end
		ensure
			attached_implementation: attached implementation
		end

feature {NONE} -- Constants

	String_32_imp: EL_STRING_32_ESCAPER_IMP
		once
			create Result.make
		end
	String_8_imp: EL_STRING_8_ESCAPER_IMP
		once
			create Result.make
		end

	Zstring_imp: EL_ZSTRING_ESCAPER_IMP
		once
			create Result.make
		end

end