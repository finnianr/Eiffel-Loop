note
	description: "Test management task"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-05 7:21:00 GMT (Thursday 5th September 2019)"
	revision: "2"

deferred class
	TEST_MANAGEMENT_TASK

inherit
	RBOX_MANAGEMENT_TASK
		redefine
			root_node_name
		end

feature {NONE} -- Implementation

	root_node_name: STRING
			--
		do
			Result := Naming.class_as_snake_lower (Current, 0, 2)
		end

end
