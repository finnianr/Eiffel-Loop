note
	description: "Summary description for {EL_PATH_STEPS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-27 12:49:14 GMT (Saturday 27th May 2017)"
	revision: "6"

class
	EL_PATH_STEPS

inherit
	EL_ZSTRING_LIST
		rename
			make as make_list,
			make_from_array as make_from_zstring_array,
			joined as joined_list,
			extend as extend_path
		export
			{NONE} extend_path
		redefine
			remove, append, replace, default_create, wipe_out
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

	EL_ZSTRING_ROUTINES
		rename
			Tab_string as Tab_zstring
		export
			{NONE} all
		undefine
			is_equal, copy, default_create
		end

	STRING_HANDLER
		undefine
			is_equal, copy, default_create
		end

create
	default_create, make_with_count, make,
	make_from_array, make_from_directory_path, make_from_file_path

convert
	make_from_array ({ARRAY [ZSTRING], ARRAY [STRING], ARRAY [STRING_32]}),

	make ({STRING_32, STRING, ZSTRING}),

	as_file_path: {EL_FILE_PATH}, as_directory_path: {EL_DIR_PATH}, unicode: {READABLE_STRING_GENERAL}

feature {NONE} -- Initialization

	default_create
			--
		do
			make_list (0)
			compare_objects
		end

	make_from_array, make_from_strings (a_steps: INDEXABLE [READABLE_STRING_GENERAL, INTEGER])
			-- Create list from array `steps'.
		local
			i: INTEGER
		do
			make_with_count (a_steps.upper - a_steps.lower + 1)
			from i := a_steps.lower until i > a_steps.upper loop
				extend (a_steps [i])
				i := i + 1
			end
		end

	make_from_directory_path, make_from_file_path (a_path: EL_PATH)
		do
			make (a_path.to_string)
		end

	make_with_count (n: INTEGER)
			--
		do
			make_list (n)
			internal_hash_code := 0
			compare_objects
		end

feature -- Initialization

	make, set_from_string (a_path: READABLE_STRING_GENERAL)

		local
			separator: CHARACTER_32
		do
			separator:= Operating_environment.directory_separator
			if not a_path.has (separator) then
				-- Uses unix separators as default fall back.
				separator := '/'
			end
			make_with_separator (as_zstring (a_path), separator, False)
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

feature -- Element change

	append (steps: SEQUENCE [like item])
			-- Append a copy of `steps'.
		do
			internal_hash_code := 0
			Precursor (steps)
		end

	expand_variables
		local
			steps: like to_array; environ_path: EL_DIR_PATH
			variable_name: ZSTRING
		do
			internal_hash_code := 0
			steps := to_array.twin
			wipe_out
			across steps as step loop
				if is_variable_name (step.item) then
					variable_name := step.item; variable_name.remove_head (1)
					environ_path := Execution_environment.variable_dir_path (variable_name.to_unicode)
					if environ_path.is_empty then
						extend (step.item)
					else
						environ_path.steps.do_all (agent extend_path)
					end
				else
					extend_path (step.item)
				end
			end
		end

	extend (step: READABLE_STRING_GENERAL)
			-- Add `step' to end.
			-- Do not move cursor.
		do
			internal_hash_code := 0
			extend_path (as_zstring (step))
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

	replace (step: like first)
			-- Replace current item by `step'.
		do
			internal_hash_code := 0
			Precursor (step)
		end

feature -- Status query

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

feature -- Conversion

	as_directory_path: EL_DIR_PATH
		do
			Result := to_string
		end

	as_expanded_directory_path: EL_DIR_PATH
		do
			Result := expanded_path.to_string
		end

	as_expanded_file_path: EL_FILE_PATH
		do
			Result := expanded_path.to_string
		end

	as_file_path: EL_FILE_PATH
		do
			Result := to_string
		end

	expanded_path: like Current
		do
			Result := twin
			result.expand_variables
		end

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
			create Result.make_from_array (to_array.subarray (index_from, index_to))
		end

	to_string: like item
			--
		do
			Result := joined_list (Operating_environment.Directory_separator)
		end

	unicode: STRING_32
		do
			Result := to_string.to_unicode
		end

feature -- Removal

	remove
			-- Remove current item.
		do
			internal_hash_code := 0
			Precursor
		end

	wipe_out
		do
			internal_hash_code := 0
			Precursor
		end

feature {NONE} -- Internal attributes

	internal_hash_code: INTEGER

	is_volume_name (name: STRING): BOOLEAN
		do
			Result := name.count = 2 and then name.item (1).is_alpha and then name @ 2 = ':'
		end

feature -- Constants

	Magic_number: INTEGER = 8388593
		-- Greatest prime lower than 2^23
		-- so that this magic number shifted to the left does not exceed 2^31.

end
