note
	description: "Reflected field of type ${EL_ZSTRING}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-28 10:22:35 GMT (Monday 28th April 2025)"
	revision: "16"

class
	EL_REFLECTED_ZSTRING

inherit
	EL_REFLECTED_STRING [ZSTRING]
		redefine
			append_to_string
		end

create
	make

feature -- Basic operations

	append_to_string (object: ANY; str: ZSTRING)
		do
			if attached value (object) as v then
				str.append (v)
			end
		end

	reset (object: ANY)
		do
			value (object).wipe_out
		end

	set_from_memory (object: ANY; memory: EL_MEMORY_READER_WRITER)
		do
			if attached value (object) as str then
				memory.read_into_string (str)
			end
		end

	set_from_node (object: ANY; node: EL_STRING_NODE)
		do
			if is_value_cached then
				set (object, node.as_string (False))

			elseif attached value (object) as str then
				node.set (str)
			else
				set (object, node.as_string (True))
			end
		end

	set_from_readable (object: ANY; readable: EL_READABLE)
		do
			set (object, readable.read_string)
		end

	write (object: ANY; writeable: EL_WRITABLE)
		do
			writeable.write_string (value (object))
		end

	write_to_memory (object: ANY; memory: EL_MEMORY_READER_WRITER)
		do
			memory.write_string (value (object))
		end

feature {NONE} -- Implementation

	replaced (str: ZSTRING; general: READABLE_STRING_GENERAL): ZSTRING
		do
			Result := str
			str.wipe_out
			str.append_string_general (general)
		end

	strict_type_id: INTEGER
		-- type that matches generator name suffix EL_REFLECTED_*
		do
			Result := ({ZSTRING}).type_id
		end

end