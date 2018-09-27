note
	description: "Identified main thread"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:15 GMT (Thursday 20th September 2018)"
	revision: "5"

class
	EL_IDENTIFIED_MAIN_THREAD

inherit
	EL_IDENTIFIED_THREAD_I
		redefine
			name
		end

create
	make
	
feature {NONE} -- Initialization

	make (a_name: like name)
		do
			name := a_name
		end

feature -- Access

	thread_id: POINTER
			--
		do
			Result := {THREAD_ENVIRONMENT}.current_thread_id
		end

	name: ZSTRING
end