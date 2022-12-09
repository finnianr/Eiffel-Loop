note
	description: "[
		Fixed length alpha-numeric 8-bit codes stored in one of:
		
			1. [$source NATURAL_16] (2 byte code string)
			2. [$source NATURAL_32] (4 byte code string)
			3. [$source NATURAL_64] (8 byte code string)
	]"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-09 12:18:32 GMT (Friday 9th December 2022)"
	revision: "4"

deferred class
	EL_CODE_REPRESENTATION [N -> NUMERIC]

inherit
	EL_STRING_FIELD_REPRESENTATION [N, STRING]
		undefine
			append_to_string
		redefine
			to_value
		end

	EL_REFLECTION_HANDLER

	STRING_HANDLER

	EL_STRING_8_CONSTANTS

feature {NONE} -- Initialization

	make
		do
			item := Empty_string_8
		end

feature -- Basic operations

	append_comment (field_definition: STRING)
		-- append comment to meta data `field_definition'
		do
			field_definition.append (" -- " + ({N}).name + " code")
		end

feature -- Measurement

	byte_count: INTEGER
		deferred
		end

feature -- Conversion

	to_string (a_value: like to_value): STRING
		do
			if attached Buffer_8.empty as str then
				str.grow (byte_count)
				str.set_count (byte_count)
				str.fill_with ('%U')
				memory_copy (str.area, a_value)
				str.prune_all_trailing ('%U')
				Result := str.twin
			end
		end

feature -- Conversion

	to_value (general: READABLE_STRING_GENERAL): N
		require else
			valid_string: valid_string (general)
		deferred
		end

feature -- Contract Support

	valid_string (general: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := general.count <= byte_count
		end

feature {NONE} -- Implementation

	memory_copy (area: SPECIAL [CHARACTER]; a_value: like to_value)
		deferred
		end

note
	descendants: "[
			EL_CODE_REPRESENTATION* [N -> NUMERIC]
				[$source EL_CODE_16_REPRESENTATION]
				[$source EL_CODE_32_REPRESENTATION]
					[$source EL_IP_ADDRESS_REPRESENTATION]
				[$source EL_CODE_64_REPRESENTATION]
	]"

end