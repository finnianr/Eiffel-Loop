note
	description: "[
		Implementation of ${EL_PATH} for `parent_path', status properties, comparison and hashing
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-03-13 10:51:37 GMT (Wednesday 13th March 2024)"
	revision: "4"

deferred class
	EL_PATH_PARENT

inherit
	COMPARABLE
		redefine
			is_equal
		end

	HASHABLE undefine is_equal end

	EL_PATH_BUFFER_ROUTINES

	EL_PATH_CONSTANTS
		export
			{NONE} all
			{ANY} Separator
		end

	DEBUG_OUTPUT undefine is_equal end

	STRING_HANDLER undefine is_equal end

	EL_MODULE_DIRECTORY; EL_MODULE_FILE_SYSTEM; EL_MODULE_FORMAT

	EL_READABLE_STRING_GENERAL_ROUTINES_IMP
		export
			{NONE} all
		end

	EL_SHARED_STRING_8_BUFFER_SCOPES; EL_SHARED_STRING_32_BUFFER_SCOPES; EL_SHARED_ZSTRING_BUFFER_SCOPES

	EL_SHARED_PATH_MANAGER; EL_SHARED_WORD

feature -- Measurement

	hash_code: INTEGER
			-- Hash code value
		local
			i: INTEGER
		do
			Result := internal_hash_code
			if Result = 0 then
				from i := 1 until i > part_count loop
					Result := Result + part_string (i).hash_code
					i := i + 1
				end
				Result := Result.abs
				internal_hash_code := Result
			end
		end

feature -- Status Query

	exists: BOOLEAN
		do
			Result := not is_empty and then File_system.path_exists (current_path)
		end

	has_parent: BOOLEAN
		do
			if is_absolute then
				if base.count > 0 then
					Result := parent_path.count >= 1 and then parent_path.ends_with_character (Separator)
				end
			else
				Result := parent_path.ends_with_character (Separator)
			end
		end

	has_step (a_step: READABLE_STRING_GENERAL): BOOLEAN
			-- true if path has directory step
		local
			step: ZSTRING; pos_left_separator, pos_right_separator: INTEGER
		do
			across String_scope as scope loop
				step := scope.same_item (a_step)
				pos_left_separator := parent_path.substring_index (step, 1) - 1
				pos_right_separator := pos_left_separator + step.count + 1
				if 0 <= pos_left_separator and pos_right_separator <= parent_path.count then
					if parent_path [pos_right_separator] = Separator then
						Result := pos_left_separator > 0 implies parent_path [pos_left_separator] = Separator
					end
				end
			end
		end

	is_absolute: BOOLEAN
		local
			z: EL_ZSTRING_ROUTINES
		do
			if {PLATFORM}.is_windows then
				Result := z.starts_with_drive (parent_path)
			else
				Result := is_unix_absolute
			end
		end

	is_unix_absolute: BOOLEAN
		-- is absolute using Unix definition
		do
			Result := parent_path.starts_with_character (Separator)
		end

	is_directory: BOOLEAN
		deferred
		end

	is_empty: BOOLEAN
		do
			Result := parent_path.is_empty and base.is_empty
		end

	is_expandable: BOOLEAN
		-- `True' if `base' or `parent' contain what maybe expandable variables
		do
			Result := has_expansion_variable (parent_path) or else has_expansion_variable (base)
		end

	is_file: BOOLEAN
		do
			Result := not is_directory
		end

	is_uri: BOOLEAN
		do
		end

	is_valid_ntfs: BOOLEAN
		local
			ntfs: EL_NT_FILE_SYSTEM_ROUTINES
		do
			Result := ntfs.is_valid (parent_path, True) and then ntfs.is_valid (base, False)
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
			--
		do
			Result := base.is_equal (other.base) and parent_path.is_equal (other.parent_path)
		end

	is_less alias "<" (other: like Current): BOOLEAN
			-- Is current object less than `other'?
		local
			other_parent: like parent_path
		do
			other_parent := other.parent_path
			if parent_path ~ other_parent then
				Result := base < other.base
			else
				Result := parent_path < other_parent
			end
		end

feature -- Contract Support

	invalid_ntfs_character (c: CHARACTER): BOOLEAN
		local
			ntfs: EL_NT_FILE_SYSTEM_ROUTINES
		do
			Result := ntfs.invalid_ntfs_character (c)
		end

feature -- Element change

	set_parent_path (a_parent: ZSTRING)
		local
			l_path: ZSTRING; last_index: INTEGER
		do
			last_index := a_parent.count
			inspect last_index
				when 0 then
					parent_path := Empty_path
			else
				l_path := a_parent
				if l_path [last_index] /= Separator then
					if l_path /= Temp_path then
						l_path := empty_temp_path
						l_path.append (a_parent)
					end
					l_path.append_character (Separator)
				end
				Parent_set.put_copy (l_path)
				parent_path := Parent_set.found_item
			end
			internal_hash_code := 0
		end

	set_parent_path_general (a_parent: READABLE_STRING_GENERAL)
		do
			set_parent_path (temporary_copy (a_parent))
		end

	set_parent (dir_path: EL_DIR_PATH)
		do
			set_parent_path (dir_path.temporary_path)
		end

	set_path (a_path: READABLE_STRING_GENERAL)
		-- set `parent_path' and `base' from `a_path' string
		do
			make (a_path)
		end

feature {NONE} -- Implementation

	has_expansion_variable (a_path: ZSTRING): BOOLEAN
		-- a step contains what might be an expandable variable
		local
			pos_dollor: INTEGER
		do
			pos_dollor := a_path.index_of ('$', 1)
			Result := pos_dollor > 0 and then (pos_dollor = 1 or else a_path [pos_dollor - 1] = Separator)
		end

	part_count: INTEGER
		-- count of string components
		-- (5 in the case of URI paths)
		do
			Result := 2
		end

	part_string (index: INTEGER): READABLE_STRING_GENERAL
		require
			valid_index: 1 <= index and index <= part_count
		do
			inspect index
				when 1 then
					Result := parent_path
			else
				Result := base
			end
		end

	reset_hash
		do
			internal_hash_code := 0
		end

feature {EL_PATH_PARENT} -- Internal attributes

	parent_path: ZSTRING

	internal_hash_code: INTEGER

feature {EL_PATH_PARENT} -- Deferred implementation

	base: ZSTRING
		deferred
		end

	current_path: EL_PATH
		deferred
		end

	make (a_path: READABLE_STRING_GENERAL)
		deferred
		end

feature {NONE} -- Constants

	Parent_set: EL_HASH_SET [ZSTRING]
		-- cached set of all `parent_path' strings
		once
			create Result.make (100)
		end

end