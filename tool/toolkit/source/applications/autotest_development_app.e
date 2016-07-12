note
	description: "Developmental testing of AutoTest classes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-08 20:07:43 GMT (Friday 8th July 2016)"
	revision: "8"

class
	AUTOTEST_DEVELOPMENT_APP

inherit
	EL_SUB_APPLICATION
		rename
			run as test_publisher
		redefine
			Option_name
		end

	EL_MODULE_USER_INPUT

create
	make

feature {NONE} -- Initialization

	initialize
		do
		end

feature -- Basic operations

	test_publisher
		local
			test_set: EIFFEL_REPOSITORY_PUBLISHER_TEST_SET
			n: INTEGER
		do
			log.enter ("test_publisher")
			create test_set
			test_set.test_publisher
			n := User_input.integer ("Return to finish")
			test_set.clean (False)
			log.exit
		end

feature {NONE} -- Constants

	Description: STRING = "Call manual and automatic sets"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{AUTOTEST_DEVELOPMENT_APP}, All_routines],
				[{REPOSITORY_SOURCE_TREE}, All_routines],
				[{REPOSITORY_SOURCE_TREE_PAGE}, All_routines]
			>>
		end

	Option_name: STRING = "autotest"

end
