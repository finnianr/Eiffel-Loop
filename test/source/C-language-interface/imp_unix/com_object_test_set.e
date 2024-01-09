note
	description: "Dummy test set for Unix compilation (Microsoft COM object)"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-07 9:53:13 GMT (Sunday 7th January 2024)"
	revision: "2"

class
	COM_OBJECT_TEST_SET

inherit
	EL_FILE_DATA_TEST_SET

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<< >>)
		end

end