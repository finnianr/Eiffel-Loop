note
	description: "Identified main thread"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-12-24 12:55:48 GMT (Tuesday 24th December 2019)"
	revision: "6"

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
