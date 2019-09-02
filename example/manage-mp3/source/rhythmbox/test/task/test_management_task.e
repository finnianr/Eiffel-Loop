note
	description: "Test management task"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-01 12:16:00 GMT (Sunday 1st September 2019)"
	revision: "1"

deferred class
	TEST_MANAGEMENT_TASK

inherit
	MANAGEMENT_TASK
		redefine
			root_node_name
		end

feature {NONE} -- Implementation

	root_node_name: STRING
			--
		do
			Result := Naming.class_as_lower_snake (Current, 0, 2)
		end

end
