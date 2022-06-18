note
	description: "[
		Fixed length alpha-numeric code representated by one of:
		
			1. [$source NATURAL_16] (2 bytes)
			2. [$source NATURAL_32] (4 bytes)
			3. [$source NATURAL_64] (8 bytes)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-18 17:27:43 GMT (Saturday 18th June 2022)"
	revision: "1"

deferred class
	EL_CODE_REPRESENTATION [N -> NUMERIC]

inherit
	EL_STRING_REPRESENTATION [N, STRING]
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
			valid_size: general.count <= byte_count
		deferred
		end

feature {NONE} -- Implementation

	memory_copy (area: SPECIAL [CHARACTER]; a_value: like to_value)
		deferred
		end
end