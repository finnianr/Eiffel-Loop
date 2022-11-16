note
	description: "Identified main thread"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "8"

class
	EL_IDENTIFIED_MAIN_THREAD

inherit
	EL_IDENTIFIED_THREAD_I

create
	make

feature {NONE} -- Initialization

	make (a_name: like name)
		do
			actual_name := a_name
		end

feature -- Access

	thread_id: POINTER
			--
		do
			Result := {THREAD_ENVIRONMENT}.current_thread_id
		end
end