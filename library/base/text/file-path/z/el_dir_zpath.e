note
	description: "Path to directory"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-13 11:30:56 GMT (Sunday 13th February 2022)"
	revision: "1"

class
	EL_DIR_ZPATH

inherit
	EL_ZPATH

create
	default_create, make, make_from_steps

create {EL_ZPATH} make_tokens

convert
	make ({IMMUTABLE_STRING_8, ZSTRING, STRING, STRING_32}),

	to_string: {ZSTRING}, as_string_32: {STRING_32, READABLE_STRING_GENERAL},
	to_obsolete: {DIR_PATH}

feature -- Access

	relative_path (a_parent: EL_DIR_ZPATH): EL_DIR_ZPATH
		do
			if a_parent.step_count <= step_count then
				create Result.make_tokens (step_count - a_parent.step_count)
				Result.append_subpath (Current, a_parent.step_count + 1)
			else
				create Result
			end
		end

feature -- Conversion

	to_obsolete: DIR_PATH
		do
			create Result.make (to_string)
		end

feature -- Status report

	is_parent_of (other: EL_ZPATH): BOOLEAN
		-- `True' is `Current' directory is parent of `other'
		local
			i: INTEGER
		do
			if step_count < other.step_count then
				Result := True
				from i := 1 until not Result or i > step_count loop
					Result := i_th (i) = other.i_th (i)
					i := i + 1
				end
			end
		end

feature -- Aliased joins

	plus alias "+" (path: EL_FILE_ZPATH): like Type_file_path
		do
			create Result.make_tokens (step_count + path.step_count - path.leading_backstep_count)
			Result.append (Current); Result.append_path (path)
		end

feature {NONE} -- Implementation

	new_path (n: INTEGER): like Current
		do
			create Result.make_tokens (n)
		end

feature {NONE} -- Type definitions

	Type_file_path: EL_FILE_ZPATH
		require
			never_called: False
		once
			create Result.make_tokens (0)
		end

end