note
	description: "Implemention routines for class [$source EL_PATH]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-27 23:03:51 GMT (Friday 27th September 2019)"
	revision: "2"

deferred class
	EL_PATH_IMPLEMENTATION

inherit
	EL_PATH_CONSTANTS
		export
			{NONE} all
			{ANY} Separator
		end

	DEBUG_OUTPUT
		rename
			debug_output as as_string_32
		end

	STRING_HANDLER

	EL_MODULE_ZSTRING

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_DIRECTORY

	EL_MODULE_FORMAT


feature -- Measurement

	count: INTEGER
		-- character count
		-- (works for uri paths too)
		local
			i: INTEGER
		do
			from i := 1 until i > part_count loop
				Result := Result + part_string (i).count
				i := i + 1
			end
		end

	dot_index: INTEGER
		-- index of last dot, 0 if none
		do
			Result := base.last_index_of ('.', base.count)
		end

	parent_count: INTEGER
		do
			Result := parent_path.count
		end

	step_count: INTEGER
		do
			Result := parent_path.occurrences (Separator) + 1
		end

feature -- Conversion

	as_string_32: STRING_32
		local
			i: INTEGER
		do
			create Result.make (count)
			from i := 1 until i > part_count loop
				part_string (i).append_to_string_32 (Result)
				i := i + 1
			end
		ensure then
			same_as_to_string: to_string.as_string_32 ~ Result
		end

	to_string: ZSTRING
			--
		local
			i: INTEGER
		do
			create Result.make (count)
			from i := 1 until i > part_count loop
				Result.append (part_string (i))
				i := i + 1
			end
		end

feature -- Basic operations

	append_to (str: ZSTRING)
		-- append path to string `str'
		local
			i: INTEGER
		do
			str.grow (str.count + count)
			from i := 1 until i > part_count loop
				str.append (part_string (i))
				i := i + 1
			end
		end

feature {NONE} -- Deferred implementation

	base: ZSTRING
		deferred
		end

	parent_path: ZSTRING
		deferred
		end

	set_path (a_path: READABLE_STRING_GENERAL)
		deferred
		end

	set_parent_path (a_parent: READABLE_STRING_GENERAL)
		deferred
		end

feature {EL_PATH, STRING_HANDLER} -- Implementation

	append (a_path: EL_PATH)
		require
			relative_path: not a_path.is_absolute
		local
			l_path: ZSTRING
		do
			if not a_path.is_empty then
				l_path := temporary_path

				if not l_path.is_empty then
					l_path.append_unicode (Separator.natural_32_code)
				end
				l_path.append (a_path.parent_path)
				l_path.append (a_path.base)
				set_path (l_path)
			end
		end

	part_count: INTEGER
		-- count of string components
		-- (5 in the case of URI paths)
		do
			Result := 2
		end

	part_string (index: INTEGER): ZSTRING
		require
			valid_index:  1 <= index and index <= part_count
		do
			inspect index
				when 1 then
					Result := parent_path
			else
				Result := base
			end
		end

	replace_separator (separator_old, separator_new: CHARACTER_32)
		local
			l_path: ZSTRING
		do
			l_path := temporary_copy (parent_path)
			l_path.replace_character (separator_old, separator_new)
			set_parent_path (l_path)
		end

feature {EL_PATH} -- Implementation

	is_potenially_expandable (a_path: ZSTRING): BOOLEAN
		local
			pos_dollor: INTEGER
		do
			pos_dollor := a_path.index_of ('$', 1)
			Result := pos_dollor > 0 and then (pos_dollor = 1 or else a_path [pos_dollor - 1] = Separator)
		end

	relative_temporary_path (a_parent: EL_DIR_PATH): ZSTRING
		local
			remove_count: INTEGER
		do
			Result := temporary_path
			remove_count := a_parent.count
			if Result.count > remove_count and then Result [remove_count + 1] = Separator then
				remove_count := remove_count + 1
			end
			Result.remove_head (remove_count)
		end

	temporary_copy (path: READABLE_STRING_GENERAL): ZSTRING
		do
			Result := Temp_path
			if Result /= path then
				Result.wipe_out
				Result.append_string_general (path)
			end
		end

	temporary_path: ZSTRING
		-- temporary shared copy of current path
		do
			Result := Temp_path
			Result.wipe_out
			append_to (Result)
		end

feature {NONE} -- Constants

	Back_dir_step: ZSTRING
		once
			Result := "../"
		end

	Empty_path: ZSTRING
		once
			create Result.make_empty
		end
		-- Greatest prime lower than 2^23
		-- so that this magic number shifted to the left does not exceed 2^31.

	Forward_slash: ZSTRING
		once
			Result := "/"
		end

	Magic_number: INTEGER = 8388593

	Parent_set: EL_HASH_SET [ZSTRING]
			--
		once
			create Result.make_equal (100)
		end

	Single_dot: ZSTRING
		once
			Result := "."
		end

	Temp_path: ZSTRING
		once
			create Result.make_empty
		end

	Variable_cwd: ZSTRING
		once
			Result := "$CWD"
		end

end
