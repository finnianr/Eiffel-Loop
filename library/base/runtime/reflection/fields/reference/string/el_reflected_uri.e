note
	description: "Reflected uri"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-29 15:47:47 GMT (Wednesday 29th June 2022)"
	revision: "7"

class
	EL_REFLECTED_URI

inherit
	EL_REFLECTED_STRING [EL_URI]
		rename
			set_string as set_uri
		end

	EL_SHARED_STRING_8_CURSOR

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
			uri.wipe_out
			if general.has_substring (uri.Colon_slash_x2) then
				if attached {READABLE_STRING_8} general as str_8 and then cursor_8 (str_8).all_ascii then
					uri.append (str_8)
				else
					uri.append_general (general)
				end
			end
		end

end