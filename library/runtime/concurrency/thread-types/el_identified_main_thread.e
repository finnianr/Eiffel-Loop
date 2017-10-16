note
	description: "Summary description for {EL_IDENTIFIED_MAIN_THREAD}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:01 GMT (Thursday 12th October 2017)"
	revision: "2"

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