note
	description: "Test configuration"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-09 9:15:09 GMT (Sunday 9th June 2019)"
	revision: "4"

class
	TEST_CONFIGURATION

inherit
	EL_REFLECTIVE_BUILDABLE_AND_STORABLE_AS_XML
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
			register_default_values
			create values_list.make (3)
			values_list.compare_objects
			create colors.make (3)
			colors.compare_objects
			Precursor
		end

feature {NONE} -- Implementation

	register_default_values
		once
			Default_value_table.extend_from_array (<< create {like values}.make_default >>)
		end

feature -- Access

	image_path: EL_FILE_PATH

	colors: ARRAYED_LIST [STRING]

	name: STRING

	values: TEST_VALUES

	values_list: ARRAYED_LIST [TEST_VALUES]
end
