note
	description: "Logged routine info"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:13 GMT (Thursday 20th September 2018)"
	revision: "5"

class
	EL_LOGGED_ROUTINE_INFO

create
	make

feature {NONE} -- Initialization

	make (a_id, a_class_type_id: INTEGER; a_name, a_class_name: STRING)
		do
			id := a_id; class_type_id := a_class_type_id; name := a_name; class_name := a_class_name
		end

feature -- Access

	class_name: STRING

	class_type_id: INTEGER

	id: INTEGER

	name: STRING

end