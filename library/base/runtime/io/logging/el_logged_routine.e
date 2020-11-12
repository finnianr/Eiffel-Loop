note
	description: "Logged routine"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-11-12 15:32:51 GMT (Thursday 12th November 2020)"
	revision: "9"

class
	EL_LOGGED_ROUTINE

inherit
	EL_ROUTINE_KEY
		rename
			make as make_key
		redefine
			make_empty
		end

create
	make, make_empty

feature {NONE} -- Initialization

	make (type: TYPE [ANY]; a_name: STRING)
		do
			make_key (type.type_id, a_name)
			type_name := type.name
		end

	make_empty
		do
			Precursor
			create type_name.make_empty
		end

feature -- Access

	type_name: IMMUTABLE_STRING_8

end