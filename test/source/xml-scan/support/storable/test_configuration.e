note
	description: "Test configuration"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-30 11:01:40 GMT (Friday 30th December 2022)"
	revision: "17"

class
	TEST_CONFIGURATION

inherit
	EL_REFLECTIVE_BUILDABLE_AND_STORABLE_AS_XML
		rename
			field_included as is_any_field,
			xml_naming as eiffel_naming
		export
			{ANY} field_table
		redefine
			make_default
		end

create
	make_from_file, make

feature {NONE} -- Initialization

	make (a_image_path: like image_path; a_name: like name; a_values: like values)
		do
			make_default
			image_path := a_image_path; name := a_name; values := a_values
		end

	make_default
		do
			Precursor
			values_list.compare_objects
			colors.compare_objects
			clipping.enable
		end

feature -- Access

	colors: ARRAYED_LIST [STRING]

	image_path: FILE_PATH

	integer_list: ARRAYED_LIST [INTEGER]

	substring_interval: TUPLE [start_index, end_index: INTEGER]

	name: STRING

	values: TEST_VALUES

	values_list: ARRAYED_LIST [TEST_VALUES]

feature -- Status query

	clipping: EL_BOOLEAN_OPTION
end