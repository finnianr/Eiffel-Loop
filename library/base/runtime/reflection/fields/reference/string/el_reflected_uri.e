note
	description: "Reflected uri"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-02-13 13:39:58 GMT (Saturday 13th February 2021)"
	revision: "2"

class
	EL_REFLECTED_URI

inherit
	EL_REFLECTED_STRING [EL_URI]

create
	make

feature -- Basic operations

	reset (a_object: EL_REFLECTIVE)
		do
			value (a_object).wipe_out
		end

	set_from_memory (a_object: EL_REFLECTIVE; memory: EL_MEMORY_READER_WRITER)
		do
			if attached value (a_object) as uri then
				memory.read_into_string_8 (uri)
			end
		end

	set_from_readable (a_object: EL_REFLECTIVE; readable: EL_READABLE)
		do
			set (a_object, create {EL_URI}.make (readable.read_string_8))
		end

	set_from_string (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL)
		local
			l_value: like value
		do
			l_value := value (a_object)
			if attached {EL_URI} string as uri then
				set (a_object, uri)
			else
				l_value.wipe_out
				if attached {ZSTRING} string as zstr then
					zstr.append_to_string_8 (l_value)
				else
					l_value.append_string_general (string)
				end
			end
		end

	write (a_object: EL_REFLECTIVE; writeable: EL_WRITEABLE)
		do
			writeable.write_string_8 (value (a_object))
		end

feature {NONE} -- Unused

	read_from_set (a_object: EL_REFLECTIVE; reader: EL_CACHED_FIELD_READER; a_set: EL_HASH_SET [EL_URI])
		require else
			never_called: False
		do
		end

end