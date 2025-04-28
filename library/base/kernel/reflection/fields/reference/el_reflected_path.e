note
	description: "Reflected field conforming to type ${EL_PATH}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-28 10:22:18 GMT (Monday 28th April 2025)"
	revision: "24"

class
	EL_REFLECTED_PATH

inherit
	EL_REFLECTED_HASHABLE_REFERENCE [EL_PATH]
		redefine
			is_abstract, reset, set_from_readable, set_from_string, to_string, write
		end

create
	make

feature -- Access

	to_string (object: ANY): READABLE_STRING_GENERAL
		do
			if attached value (object) as path then
				Result := path.to_string
			else
				create {STRING} Result.make_empty
			end
		end

feature -- Basic operations

	expand (object: ANY)
		do
			if attached value (object) as path then
				path.expand
			end
		end

	reset (object: ANY)
		do
			if attached value (object) as path then
				path.wipe_out
			end
		end

	set_from_readable (object: ANY; a_value: EL_READABLE)
		do
			if attached value (object) as path then
				path.set_path (a_value.read_string)
			end
		end

	set_from_string (object: ANY; string: READABLE_STRING_GENERAL)
		do
			if attached value (object) as path then
				path.set_path (string)
			end
		end

	write (object: ANY; writeable: EL_WRITABLE)
		do
			if attached value (object) as path then
				writeable.write_string (path.parent_string (False))
				writeable.write_string (path.base)
			end
		end

feature {NONE} -- Constants

	Is_abstract: BOOLEAN = True
		-- `True' if field type is deferred

end