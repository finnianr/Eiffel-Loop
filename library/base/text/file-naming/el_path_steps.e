note
	description: "Summary description for {EL_PATH_STEPS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-07 7:55:04 GMT (Thursday 7th July 2016)"
	revision: "7"

class
	EL_PATH_STEPS

inherit
	EL_ARRAYED_LIST [ZSTRING]
		rename
			make as make_list,
			make_from_array as make_list_from_array
		redefine
			extend, remove, append, replace, default_create
		end

	HASHABLE
		undefine
			is_equal, copy, default_create
		end

	EL_MODULE_EXECUTION_ENVIRONMENT
		undefine
			is_equal, copy, default_create
		end

	EL_MODULE_DIRECTORY
		undefine
			is_equal, copy, default_create
		end

	EL_MODULE_FILE_SYSTEM
		undefine
			is_equal, copy, default_create
		end

	STRING_HANDLER
		undefine
			is_equal, copy, default_create
		end

create
	default_create, make_with_count, make, make_from_latin_1, make_from_unicode,
	make_from_array, make_from_unicode_array, make_from_latin_1_array,
	make_from_directory_path, make_from_file_path

convert
	make_from_array ({ARRAY [ZSTRING]}),
	make_from_latin_1_array ({ARRAY [STRING]}),
	make_from_unicode_array ({ARRAY [STRING_32]}),

	make_from_latin_1 ({STRING}),
	make_from_unicode ({STRING_32}),
	make ({ZSTRING}),

	as_file_path: {EL_FILE_PATH}, as_directory_path: {EL_DIR_PATH}, unicode: {READABLE_STRING_GENERAL}

feature {NONE} -- Initialization

	default_create
			--
		do
			make_list (0)
			compare_objects
		end

	make_with_count (n: INTEGER)
			--
		do
			make_list (n)
			internal_hash_code := 0
			compare_objects
		end

	make_from_directory_path, make_from_file_path (a_path: EL_PATH)
		do
			make (a_path.to_string)
		end

	make_from_array, make_from_unicode_array, make_from_latin_1_array (a_steps: ARRAY [READABLE_STRING_GENERAL])
			-- Create list from array `steps'.
		local
			i: INTEGER
		do
			make_with_count (a_steps.count)
			from i := 1 until i > a_steps.count loop
				if attached {ZSTRING} a_steps [i] as l_step then
					extend (l_step)
				else
					extend (create {ZSTRING}.make_from_unicode (a_steps [i]))
				end
				i := i + 1
			end
		end

feature -- Initialization

	make, set_from_string, make_from_unicode, make_from_latin_1 (a_path: READABLE_STRING_GENERAL)

		local
			separator: like item.item
			l_separator_count: INTEGER
			l_path: ZSTRING
		do
			if attached {ZSTRING} a_path as el_string then
				l_path := el_string
			else
				create l_path.make_from_unicode (a_path)
			end
			separator:= Operating_environment.directory_separator
			l_separator_count := l_path.occurrences (separator)
			if l_separator_count = 0 then
				-- Uses unix separators as default fall back.
				separator := '/'
				l_separator_count := l_path.occurrences (separator)
			end
			make_with_count (l_separator_count + 1)
			append (l_path.split (separator))
				-- a_path.string required so we don't have steps of type FILE_NAME
		end

feature -- Element change

	extend (step: like item)
			-- Add `step' to end.
			-- Do not move cursor.
		do
			internal_hash_code := 0
			Precursor (step)
		end

	remove
			-- Remove current item.
		do
			internal_hash_code := 0
			Precursor
		end

	append (steps: SEQUENCE [like item])
			-- Append a copy of `steps'.
		do
			internal_hash_code := 0
			Precursor (steps)
		end

	replace (step: like first)
			-- Replace current item by `step'.
		do
			internal_hash_code := 0
			Precursor (step)
		end

	expand_variables
		local
			steps: like to_array; environ_path: EL_DIR_PATH
			variable_name: ZSTRING
		do
			steps := to_array.twin
			wipe_out
			across steps as step loop
				if is_variable_name (step.item) then
					variable_name := step.item; variable_name.remove_head (1)
					environ_path := Execution_environment.variable_dir_path (variable_name.to_unicode)
					if environ_path.is_empty then
						extend (step.item)
					else
						environ_path.steps.do_all (agent extend)
					end
				else
					extend (step.item)
				end
			end
		end

	is_variable_name (a_step: ZSTRING): BOOLEAN
		local
			i: INTEGER
		do
			if a_step.count > 1 and then a_step [1] = '$' and then a_step.is_alpha_item (2) then
				Result := True
				from i := 3 until not Result or i > a_step.count loop
					Result := a_step.is_alpha_numeric_item (i) or a_step [i] = '_'
					i := i + 1
				end
			end
		end

feature -- Status query

	starts_with (other: like Current): BOOLEAN
			--
		local
			mismatch_found: BOOLEAN
		do
			if Current = other then
				Result := True

			elseif other.count > count then
				Result := False

			else
				from
					start; other.start
				until
					mismatch_found or after or other.after
				loop
					mismatch_found := item /~ other.item
					forth; other.forth
				end
				Result := other.after and not mismatch_found
			end
		end

	is_absolute: BOOLEAN
		do
			if not is_empty then
				if {PLATFORM}.is_windows then
					Result := is_volume_name (first)
				else
					Result := first.is_empty
				end
			end
		end

	is_createable_dir: BOOLEAN
			-- True if steps are createable as a directory
		do
			if is_absolute then
				if count > 1 and then sub_steps (1, count - 1).as_directory_path.exists_and_is_writeable then
					Result := true
				end
			else
				Result := Directory.current_working.exists_and_is_writeable
			end
		end

feature -- Conversion

	joined alias "+" (other: like Current): like Current
		do
			create Result.make_with_count (count + other.count)
			Result.append (Current)
			Result.append (other)
		end

	last_steps (step_count: INTEGER): like Current
		require
			valid_count: step_count <= count
		do
			Result := sub_steps (count - step_count + 1, count)
		end

	sub_steps (index_from, index_to: INTEGER): like Current
		require
			valid_indices: (1 <= index_from) and (index_from <= index_to) and (index_to <= count)
		do
			create Result.make_with_count (index_to - index_from + 1)
			Result.append (subchain (index_from, index_to))
		end

	to_string: like item
			--
		local
			current_index, l_capacity: INTEGER
			separator: like item.item
		do
			current_index := index
			separator := Operating_environment.Directory_separator
			from start until after loop
				if index > 1 then
					l_capacity := l_capacity + 1
				end
				l_capacity := l_capacity + item.count
				forth
			end
			create Result.make (l_capacity)
			from start until after loop
				if index > 1 then
					Result.append_character (separator)
				end
				Result.append (item)
				forth
			end
			index := current_index
		end

	unicode: STRING_32
		do
			Result := to_string.to_unicode
		end

	as_file_path: EL_FILE_PATH
		do
			Result := to_string
		end

	as_directory_path: EL_DIR_PATH
		do
			Result := to_string
		end

	as_expanded_file_path: EL_FILE_PATH
		do
			Result := expanded_path.to_string
		end

	as_expanded_directory_path: EL_DIR_PATH
		do
			Result := expanded_path.to_string
		end

	expanded_path: like Current
		do
			Result := twin
			result.expand_variables
		end

feature -- Access

	hash_code: INTEGER
			-- Hash code value
		local
			i, nb: INTEGER; l_area: SPECIAL [CHARACTER_8]
		do
			Result := internal_hash_code
			if Result = 0 then
				from start until after loop
					nb := item.count
					l_area := item.area
					from i := 0 until i = nb loop
						Result := ((Result \\ Magic_number) |<< 8) + l_area.item (i).code
						i := i + 1
					end
					forth
				end
				internal_hash_code := Result
			end
		end

feature -- Removal

	remove_tail (n: INTEGER)
			--
		local
			i: INTEGER
		do
			from i := 1 until i > n or is_empty loop
				finish; remove
				i := i + 1
			end
		end

feature {NONE} -- Implementation

	is_volume_name (name: STRING): BOOLEAN
		do
			Result := name.count = 2 and then name.item (1).is_alpha and then name @ 2 = ':'
		end

	internal_hash_code: INTEGER

feature -- Constants

	Magic_number: INTEGER = 8388593
		-- Greatest prime lower than 2^23
		-- so that this magic number shifted to the left does not exceed 2^31.

end
