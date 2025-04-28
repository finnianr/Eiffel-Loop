note
	description: "Reflected field of type ${STRING_8}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-28 10:22:47 GMT (Monday 28th April 2025)"
	revision: "17"

class
	EL_REFLECTED_STRING_8

inherit
	EL_REFLECTED_STRING [STRING_8]
		redefine
			set_from_utf_8
		end

create
	make

feature -- Basic operations

	reset (object: ANY)
		do
			value (object).wipe_out
		end

	set_from_memory (object: ANY; memory: EL_MEMORY_READER_WRITER)
		do
			if attached value (object) as str then
				memory.read_into_string_8 (str)
			end
		end

	set_from_node (object: ANY; node: EL_STRING_NODE)
		do
			if is_value_cached then
				set (object, node.as_string_8 (False))

			elseif attached value (object) as str_8 then
				node.set_8 (str_8)
			else
				set (object, node.as_string_8 (True))
			end
		end

	set_from_readable (object: ANY; readable: EL_READABLE)
		do
			set (object, readable.read_string_8)
		end

	set_from_utf_8 (object: ANY; utf_8: READABLE_STRING_8)
		local
			conv: EL_UTF_8_CONVERTER; count: INTEGER; str: STRING_8
		do
			count := conv.unicode_count (utf_8)
			if count = utf_8.count then
			-- ASCII characters
				set (object, utf_8)
			else
				if attached value (object) as v then
					str := v
					str.grow (count)
				else
					create str.make (count)
					set (object, str)
				end
				conv.string_8_into_string_general (str, str)
			end
		end

	write (object: ANY; writeable: EL_WRITABLE)
		do
			writeable.write_string_8 (value (object))
		end

	write_to_memory (object: ANY; memory: EL_MEMORY_READER_WRITER)
		do
			memory.write_string_8 (value (object))
		end

feature {NONE} -- Implementation

	replaced (str: STRING_8; general: READABLE_STRING_GENERAL): STRING_8
		do
			Result := str
			super_8 (str).replace (general)
		end

	strict_type_id: INTEGER
		-- type that matches generator name suffix EL_REFLECTED_*
		do
			Result := ({STRING_8}).type_id
		end

end