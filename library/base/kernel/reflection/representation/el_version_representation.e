note
	description: "A reflected ${NATURAL_32} representing a ${EL_VERSION_ARRAY}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-26 17:43:33 GMT (Thursday 26th January 2023)"
	revision: "8"

class
	EL_VERSION_REPRESENTATION

inherit
	EL_STRING_FIELD_REPRESENTATION [NATURAL_32, EL_VERSION_ARRAY]
		rename
			item as version
		end

create
	make

feature {NONE} -- Initialization

	make (a_version: like version)
		do
			version := a_version
			digit_count := a_version.digit_count
			part_count := a_version.count
		end

feature -- Access

	digit_count: INTEGER
		-- maximum number of decimal digits per part item

	part_count: INTEGER
		-- number of version parts

	to_string (compact_version: NATURAL_32): STRING
		do
			version.set_from_compact (compact_version)
			Result := version.out
		end

feature -- Basic operations

	append_comment (field_definition: STRING)
		-- append comment to meta data `field_definition'
		do
			field_definition.append ((Comment #$ [version.generator, part_count, digit_count]).to_latin_1)
		end

	to_value (str: READABLE_STRING_GENERAL): NATURAL_32
		do
			version.make_from_string (digit_count, Buffer_8.copied_general (str))
			Result := version.compact
		end

feature {NONE} -- Constants

	Comment: ZSTRING
		once
			Result := " -- %S: [%S, %S]"
		end

end