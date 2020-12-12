note
	description: "Reflected boolean"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-12-11 13:20:41 GMT (Friday 11th December 2020)"
	revision: "10"

class
	EL_REFLECTED_BOOLEAN

inherit
	EL_REFLECTED_EXPANDED_FIELD [BOOLEAN]
		rename
			field_value as boolean_field
		redefine
			set_from_command_line
		end

create
	make

feature -- Access

	to_string (a_object: EL_REFLECTIVE): STRING
		do
			if value (a_object) then
				Result := True_string
			else
				Result := False_string
			end
		end

	reference_value (a_object: EL_REFLECTIVE): like value.to_reference
		do
			create Result
			Result.set_item (value (a_object))
		end

feature -- Basic operations

	set (a_object: EL_REFLECTIVE; a_value: BOOLEAN)
		do
			enclosing_object := a_object
			set_boolean_field (index, a_value)
		end

	set_from_command_line (a_object: EL_REFLECTIVE; args: EL_COMMAND_LINE_ARGUMENTS)
		do
			set (a_object, args.word_option_exists (name))
		end

	set_from_integer (a_object: EL_REFLECTIVE; a_value: INTEGER)
		do
			set (a_object, a_value.to_boolean)
		end

	set_from_readable (a_object: EL_REFLECTIVE; readable: EL_READABLE)
		do
			set (a_object, readable.read_boolean)
		end

	set_from_string (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL)
		do
			set (a_object, string.to_boolean)
		end

	write (a_object: EL_REFLECTIVE; writeable: EL_WRITEABLE)
		do
			writeable.write_boolean (value (a_object))
		end

feature {NONE} -- Constants

	False_string: STRING = "False"

	True_string: STRING = "True"

end