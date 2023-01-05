note
	description: "String escaper"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-05 10:46:17 GMT (Thursday 5th January 2023)"
	revision: "15"

class
	EL_STRING_ESCAPER [S -> STRING_GENERAL create make end]

create
	make

feature {NONE} -- Initialization

	make (escape_table: EL_ESCAPE_TABLE)
		do
			set_implementation
			escape_code := implementation.to_code (escape_table.escape_character)

			create code_table.make (escape_table.count)
			across escape_table as table loop
				code_table.extend (implementation.to_code (table.item), implementation.to_code (table.key))
			end
		end

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

			if has_escaped (code_table, str, start_index, end_index) then
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
			if attached code_table as table and then attached adjusted_implementation as imp then
				from i := start_index until i > min_index loop
					if compatible_type then
						code := str.code (i)
					else
						code := imp.to_code (str [i])
					end
					if imp.is_escaped (code, table) then
						imp.append_escape_sequence (output, escape_code, code, table)
					else
						output.append_code (code)
					end
					i := i + 1
				end
			end
		end

feature {NONE} -- Internal attributes

	code_table: HASH_TABLE [NATURAL, NATURAL]

	escape_code: NATURAL

	implementation: EL_STRING_ESCAPER_IMP [S]

feature {NONE} -- Implementation

	adjusted_implementation: like implementation
		do
			Result := implementation
		end

	has_escaped (table: like code_table; str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): BOOLEAN
		local
			i, min_index: INTEGER; compatible_type: BOOLEAN
		do
			min_index := str.count.min (end_index)
			compatible_type := attached {S} str
			if attached adjusted_implementation as imp then
				from i := start_index until Result or i > min_index loop
					if compatible_type then
						Result := imp.is_escaped (str.code (i), table)
					else
						Result := imp.is_escaped (imp.to_code (str [i]), table)
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

	Zstring_imp: EL_ZSTRING_ESCAPER_IMP
		once
			create Result.make
		end

	String_8_imp: EL_STRING_8_ESCAPER_IMP
		once
			create Result.make
		end

	String_32_imp: EL_STRING_32_ESCAPER_IMP
		once
			create Result.make
		end
end