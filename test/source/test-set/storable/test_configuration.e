note
	description: "Test configuration"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-06 19:22:52 GMT (Thursday 6th June 2019)"
	revision: "1"

class
	TEST_CONFIGURATION

inherit
	EL_REFLECTIVE_BUILDABLE_AND_STORABLE_AS_XML
		redefine
			make_default
		end

create
	make_from_file

feature {NONE} -- Initialization

	make_default
		do
			create values.make
			create values_list.make (2)
			Precursor
		end

feature -- Access

	file_path: EL_FILE_PATH

	values: TEST_VALUES

	values_list: ARRAYED_LIST [TEST_VALUES]
end
