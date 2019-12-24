note
	description: "Internal thread for class [$source EL_IDENTIFIED_THREAD]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-12-24 13:02:35 GMT (Tuesday 24th December 2019)"
	revision: "1"

class
	EL_INTERNAL_THREAD

inherit
	THREAD
		rename
			make as make_thread
		end

create
	make

feature {NONE} -- Initialization

	make (a_identified: like identified)
		do
			make_thread
			identified := a_identified
		end

feature -- Basic operations

	execute
		do
			identified.do_execution
		end

feature {NONE} -- Internal attributes

	identified: EL_IDENTIFIED_THREAD

end
