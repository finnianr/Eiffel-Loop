note
	description: "Parses string for name value pair using specified delimiter"
	notes: "[
		Q. Why not use `value.append_substring (source)' instead of assigning `source.substring' ?
		A. It is not as efficient because ${STRING_32}.append_substring_general contains loop

			from i := start_index until i > end_index loop
				append_code (s.code (i))
				i := i + 1
			end

		whereas `append' and `substring' directly use `area' if type of value is `S'.
		Also it is not necessary to use `value.twin' if repeatedly setting a shared instance.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-31 6:53:21 GMT (Saturday 31st August 2024)"
	revision: "16"

class
	EL_NAME_VALUE_PAIR [S -> STRING_GENERAL create make end]

inherit
	EL_MAKEABLE
		rename
			make as make_empty
		end

create
	make, make_empty, make_pair, make_quoted

feature {NONE} -- Initialization

	make (str: READABLE_STRING_GENERAL; delimiter: CHARACTER_32)
		require
			delimited: str.has (delimiter)
		do
			if str.has (delimiter) then
				set_from_string (str, delimiter)
			else
				make_empty
			end
		end

	make_quoted (str: READABLE_STRING_GENERAL; delimiter: CHARACTER_32)
		-- make with any quotes removed from `value'
		require
			delimited: str.has (delimiter)
		do
			make (str, delimiter)
			if value.count >= 2 and then value [1] = '"' and then value [value.count] = '"' then
				value.keep_tail (value.count - 1)
				value.keep_head (value.count - 1)
			end
		end

	make_empty
		do
			create name.make (0); create value.make (0)
		end

	make_pair (a_name: like name; a_value: like value)
		do
			name := a_name; value := a_value
		end

feature -- Access

	as_assignment: S
		do
			Result := joined ('=')
		end

	joined (separator: CHARACTER_32): S
		do
			create Result.make (name.count + value.count + 1)
			append_to (Result, separator)
		end

	name: S

	value: S

feature -- Basic operations

	append_to (str: S; separator: CHARACTER_32)
		do
			str.append (name)
			str.append_code (separator.natural_32_code)
			str.append (value)
		end

feature -- Element change

	set_from_string (str: READABLE_STRING_GENERAL; delimiter: CHARACTER_32)
		require
			delimited: str.has (delimiter)
		local
			index: INTEGER
		do
			index := str.index_of (delimiter, 1)
			if index > 0 then
				name := new_substring (str, 1, index - 1)
				value := new_substring (str, index + 1, str.count)
			else
				wipe_out
			end
		end

	wipe_out
		do
			name.keep_head (0); value.keep_head (0)
		end

feature {NONE} -- Implementation

	new_substring (source: READABLE_STRING_GENERAL; a_start_index, a_end_index: INTEGER): S
		-- set `target' from `source' substring without any leading and trailing white space
		local
			c32: EL_CHARACTER_32_ROUTINES; start_index, end_index: INTEGER
		do
			from
				start_index := a_start_index
			until
				start_index > a_end_index or else not c32.is_space (source [start_index])
			loop
				start_index := start_index + 1
			end
			from
				end_index := a_end_index
			until
				end_index < start_index or else not c32.is_space (source [end_index])
			loop
				end_index := end_index - 1
			end
			create Result.make (end_index - start_index + 1)
			if start_index <= end_index then
				Result.append (source.substring (start_index, end_index))
			else
				create Result.make (0)
			end
		end

end