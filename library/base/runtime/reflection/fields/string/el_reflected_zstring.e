note
	description: "Summary description for {EL_ZSTRING_SETTABLE_REFERENCE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-25 16:19:08 GMT (Wednesday 25th April 2018)"
	revision: "5"

class
	EL_REFLECTED_ZSTRING

inherit
	EL_REFLECTED_STRING
		redefine
			set_from_string, set_from_readable, to_string, write, default_value
		end

create
	make

feature -- Access

	to_string (a_object: EL_REFLECTIVE): ZSTRING
		do
			Result := value (a_object)
		end

feature -- Basic operations

	set_from_string (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL)
		local
			l_value: like value
		do
			l_value := value (a_object)
			l_value.wipe_out; l_value.append_string_general (string)
		end

	set_from_readable (a_object: EL_REFLECTIVE; readable: EL_READABLE)
		do
			set (a_object, readable.read_string)
		end

	write (a_object: EL_REFLECTIVE; writer: EL_WRITEABLE)
		do
			writer.write_string (value (a_object))
		end

feature {NONE} -- Implementation

	initialize_default
		do
			default_value := Empty_string
		end

feature {NONE} -- Internal attributes

	default_value: ZSTRING
end
