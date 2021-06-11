note
	description: "Reflected uri"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-06-11 16:09:11 GMT (Friday 11th June 2021)"
	revision: "5"

class
	EL_REFLECTED_URI

inherit
	EL_REFLECTED_STRING [EL_URI]
		rename
			set_string as set_uri
		end

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

	write (a_object: EL_REFLECTIVE; writeable: EL_WRITEABLE)
		do
			writeable.write_string_8 (value (a_object))
		end

	write_to_memory (a_object: EL_REFLECTIVE; memory: EL_MEMORY_READER_WRITER)
		do
			memory.write_string_8 (value (a_object))
		end

feature {NONE} -- Implementation

	set_uri (uri: EL_URI; general: READABLE_STRING_GENERAL)
		do
			if general.is_valid_as_string_8 then
				uri.wipe_out
				if attached {READABLE_STRING_8} general as str_8 then
					uri.append (str_8)
				else
					uri.append (general.to_string_8)
				end
			else
				uri.make_from_general (general)
			end
		end

end