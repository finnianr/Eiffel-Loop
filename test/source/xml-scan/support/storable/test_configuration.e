note
	description: "Test configuration"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-16 9:17:45 GMT (Thursday 16th June 2022)"
	revision: "13"

class
	TEST_CONFIGURATION

inherit
	EL_REFLECTIVE_BUILDABLE_AND_STORABLE_AS_XML
		rename
			xml_naming as eiffel_naming
		redefine
			make_default, new_instance_functions
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
			create values_list.make (3)
			values_list.compare_objects
			create colors.make (3)
			create integer_list.make (3)
			colors.compare_objects
			create clipping.make_enabled
			Precursor
		end

feature {NONE} -- Implementation

	new_instance_functions: like Default_initial_values
		do
			create Result.make_from_array (<<
				agent: like values do create Result.make_default end
			>>)
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