note
	description: "Summary description for {EL_PATH}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-11-22 11:49:14 GMT (Friday 22nd November 2013)"
	revision: "4"

deferred class
	EL_PATH

inherit
	HASHABLE
		redefine
			is_equal, default_create, out, copy
		end

	EL_MODULE_EXECUTION_ENVIRONMENT
		undefine
			is_equal, default_create, out, copy
		end

	COMPARABLE
		undefine
			is_equal, default_create, out, copy
		end

	EL_MODULE_STRING
		export
			{NONE} all
		undefine
			is_equal, default_create, out, copy
		end

	EL_MODULE_FILE_SYSTEM
		export
			{NONE} all
		undefine
			is_equal, default_create, out, copy
		end

feature {NONE} -- Initialization

	default_create
		do
			parent_path := Empty_path
			base := Empty_path
		end

	make_from_latin1 (a_path: STRING_8)
		do
			make (a_path)
		end

	make_from_unicode (a_path: STRING_32)
		do
			make (a_path)
		end

	make_from_path (a_path: PATH)
		do
			make_from_unicode (a_path.name)
		end

feature -- Initialization

	make, set_path (a_path: EL_ASTRING)
			--
		local
			pos_last_separator: INTEGER
			norm_path: EL_ASTRING
		do
			default_create

			-- Normalize path
			if {PLATFORM}.is_windows and then not a_path.has (Separator) then
				norm_path := a_path.twin
				String.subst_all_characters (norm_path, '/', Separator)
			else
				norm_path := a_path
			end

			if not norm_path.is_empty then
				pos_last_separator := norm_path.last_index_of (Separator, norm_path.count)
				if pos_last_separator = 0 then
					if {PLATFORM}.is_windows then
						pos_last_separator := norm_path.last_index_of (':', norm_path.count)
					end
				end
			end

			set_parent_path (norm_path.substring (1, pos_last_separator))
			base := norm_path.substring (pos_last_separator + 1, norm_path.count)
			is_absolute := is_path_absolute (norm_path)
		end

feature -- Access

	extension: EL_ASTRING
			--
		do
			Result := base.substring (base.last_index_of ('.', base.count) + 1, base.count)
		end

	base: EL_ASTRING

	steps: EL_PATH_STEPS
			--
		do
			create Result.make (to_string)
		end

	parent: EL_DIR_PATH
		local
			l_parent: EL_ASTRING
		do
			l_parent := parent_path.twin
			if l_parent.count > 1 then
				l_parent.prune_all_trailing (Separator)
			end
			Result := l_parent
		end

	hash_code: INTEGER
			-- Hash code value
		local
			i, nb: INTEGER
			l_area: SPECIAL [CHARACTER_8]
		do
			Result := internal_hash_code
			if Result = 0 then
				Result := parent_path.hash_code
				nb := base.count
				l_area := base.area
				from i := 0 until i = nb loop
					Result := ((Result \\ Magic_number) |<< 8) + l_area.item (i).code
					i := i + 1
				end
				internal_hash_code := Result
			end
		end

feature -- Status report

	out_abbreviated: BOOLEAN
		-- is the current directory in 'out string' abbreviated to $CWD

	is_absolute: BOOLEAN

	is_directory: BOOLEAN
		deferred
		end

	is_file: BOOLEAN
		do
			Result := not is_directory
		end

	exists: BOOLEAN
		deferred
		end

	is_empty: BOOLEAN
		do
			Result := parent_path.is_empty and base.is_empty
		end

feature -- Status change

	enable_out_abbreviation
		do
			out_abbreviated := True
		end

	set_relative
		do
			is_absolute := False
		end

feature -- Element change

	set_parent_path (a_parent: EL_ASTRING)
		local
			l_parent_set: like Parent_set
		do
			if a_parent.is_empty then
				parent_path := a_parent
			else
				l_parent_set := Parent_set
				l_parent_set.search (a_parent)
				if l_parent_set.found then
					parent_path := l_parent_set.found_item
				else
					l_parent_set.force_new (a_parent)
					parent_path := a_parent
				end
			end
		end

	set_base (a_base: like base)
		do
			base := a_base
		end

	append_file_path (a_file_path: EL_FILE_PATH)
		require
			current_not_a_file: not is_file
		do
			append (a_file_path)
		end

	append_dir_path (a_dir_path: EL_DIR_PATH)
		do
			append (a_dir_path)
		end

	add_extension (a_extension: EL_ASTRING)
		local
			l_base: EL_ASTRING
		do
			create l_base.make (base.count + a_extension.count + 1)
			l_base.append (base); l_base.append_character ('.'); l_base.append (a_extension)
			base := l_base
		end

	replace_extension (a_replacement: EL_ASTRING)
		do
			remove_extension
			add_extension (a_replacement)
		end

	change_to_unix
		do
			if {PLATFORM}.is_windows then
				String.subst_all_characters (parent_path, Separator, '/')
			end
		end

	change_to_windows
		do
			if not {PLATFORM}.is_windows then
				String.subst_all_characters (parent_path, Separator, '\')
			end
		end

	share (other: like Current)
		do
			base := other.base
			parent_path := other.parent_path
			is_absolute := other.is_absolute
		end

feature -- Removal

	remove_extension
		do
			base.remove_tail (base.count - base.last_index_of ('.', base.count) + 1 )
		end

feature -- Conversion

	 to_string: EL_ASTRING
			--
		do
			create Result.make (parent_path.count + base.count)
			Result.append (parent_path)
			Result.append (base)
		end

	to_path: PATH
		do
			create Result.make_from_string (unicode)
		end

	unicode: STRING_32
		do
			Result := to_string.to_unicode
		end

	relative_path (a_parent: EL_DIR_PATH): like Current
		require
			parent_is_parent: a_parent.is_parent_of (Current)
		do
			Result := twin
			Result.parent_path.remove_head (a_parent.parent_path.count + a_parent.base.count + 1)
			Result.set_relative
		end

	out: STRING
		local
			l_out: like to_string
		do
			l_out := to_string
			if out_abbreviated then
				-- Replaces String.abbreviate_working_directory
				l_out.replace_substring_all (Execution.current_working_directory.to_string, "$CWD")
			end
			Result := l_out
		end

	to_unix, as_unix: like Current
		do
			Result := twin
			Result.change_to_unix
		end

	to_windows, as_windows: like Current
		do
			Result := twin
			Result.change_to_windows
		end

	without_extension: like Current
		do
			Result := twin
			Result.remove_extension
		end

	with_new_extension (a_new_ext: EL_ASTRING): like Current
		do
			Result := twin
			Result.replace_extension (a_new_ext)
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
			--
		do
			Result := base.is_equal (other.base) and parent_path.is_equal (other.parent_path)
		end

	is_less alias "<" (other: like Current): BOOLEAN
			-- Is current object less than `other'?
		do
			if parent_path ~ other.parent_path then
				Result := base < other.base
			else
				Result := parent_path < other.parent_path
			end
		end

feature -- Duplication

	copy (other: like Current)
		do
			base := other.base.twin
			parent_path := other.parent_path.twin
			is_absolute := other.is_absolute
		end

feature -- Contract Support

	is_path_absolute (a_path: EL_ASTRING): BOOLEAN
		do
			if {PLATFORM}.is_windows then
				Result := a_path.count >= 3 and then a_path [2] = ':' and then a_path [3] = Separator
			else
				Result := not a_path.is_empty and then a_path [1] = Separator
			end
		end

feature {EL_PATH} -- Implementation

	parent_path: EL_ASTRING

	append (a_path: EL_PATH)
		require
			relative_path: not a_path.is_absolute
		local
			l_parent: EL_ASTRING
		do
			create l_parent.make (parent_path.count + base.count + parent_path.count + 2)
			l_parent.append (to_string)
			if not base.is_empty then
				l_parent.append_character (Separator)
			end
			if not a_path.parent_path.is_empty then
				l_parent.append (a_path.parent_path)
			end
			set_parent_path (l_parent)
			base := a_path.base
		end

feature {NONE} -- Implementation

	internal_hash_code: INTEGER

	parent_set: DS_HASH_SET [EL_ASTRING]
			--
		once
			create Result.make_equal (100)
		end

feature {NONE} -- Constants

	Magic_number: INTEGER = 8388593

	Empty_path: EL_ASTRING
		once
			create Result.make_empty
		end
		-- Greatest prime lower than 2^23
		-- so that this magic number shifted to the left does not exceed 2^31.

	Separator: CHARACTER
		once
			Result := Operating_environment.Directory_separator
		end

end
