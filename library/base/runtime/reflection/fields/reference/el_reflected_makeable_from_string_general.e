note
	description: "Field that conforms to type [$source]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-04 14:54:13 GMT (Friday 4th May 2018)"
	revision: "6"

class
	EL_REFLECTED_MAKEABLE_FROM_STRING_GENERAL

inherit
	EL_REFLECTED_REFERENCE [EL_MAKEABLE_FROM_STRING_GENERAL]
		redefine
			default_defined, initialize_default, reset,
			set_from_string, set_from_readable, to_string
		end

	EL_REFLECTOR_CONSTANTS

create
	make

feature -- Basic operations

	set_from_readable (a_object: EL_REFLECTIVE; readable: EL_READABLE)
		local
			l_value: like value
		do
			l_value := value (a_object)
			if attached {EL_MAKEABLE_FROM_ZSTRING} l_value as from_zstring then
				from_zstring.make (readable.read_string)
			elseif attached {EL_MAKEABLE_FROM_STRING_8} l_value as from_string_8 then
				from_string_8.make (readable.read_string_8)
			elseif attached {EL_MAKEABLE_FROM_STRING_32} l_value as from_string_32 then
				from_string_32.make (readable.read_string_32)
			end
		end

	set_from_string (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL)
		do
			value (a_object).make_from_general (string)
		end

feature -- Access

	to_string (a_object: EL_REFLECTIVE): READABLE_STRING_GENERAL
		do
			Result := value (a_object).to_string
		end

feature -- Status query

	default_defined: BOOLEAN
		do
			if not Default_value_table.has (type_id)
				and then field_conforms_to (type_id, Makeable_from_string_general_type)
			then
				Result := True
			end
		end

feature -- Basic operations

	reset (a_object: EL_REFLECTIVE)
		do
			if attached value (a_object) as l_value then
				l_value.make_default
			end
		end

feature {NONE} -- Implementation

	initialize_default
		do
			if attached {like default_value} new_default_value as new_value then
				new_value.make_default
				default_value := new_value
			end
		end

end
