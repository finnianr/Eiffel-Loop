note
	description: "A reflected [$source INTEGER_32] representing a [$source TIME]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "4"

class
	EL_TIME_REPRESENTATION

inherit
	EL_STRING_REPRESENTATION [INTEGER, TIME]
		rename
			item as time
		redefine
			default_create
		end

create
	make

feature {NONE} -- Initialization

	make (a_format: STRING)
		do
			format := a_format
			create time.make_now
		end

feature -- Access

	to_string (a_value: like to_value): STRING
		do
			time.make_by_compact_time (a_value)
			Result := time.formatted_out (format)
		end

	format: STRING

feature {NONE} -- Initialization

	default_create
		do
			create time.make_now
		end

feature -- Basic operations

	append_comment (field_definition: STRING)
		-- append comment to meta data `field_definition'
		do
			field_definition.append (" -- " + time.generator + ": " + format)
		end

	to_value (str: READABLE_STRING_GENERAL): INTEGER
		do
			time.make_from_string (Buffer_8.copied_general (str), format)
			Result := time.compact_time
		end

end