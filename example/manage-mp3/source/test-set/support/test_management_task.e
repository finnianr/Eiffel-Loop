note
	description: "Test management task"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-28 8:40:20 GMT (Tuesday 28th April 2020)"
	revision: "3"

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
