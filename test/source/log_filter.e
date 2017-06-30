note
	description: "Summary description for {LOG_FILTER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-06-29 14:48:58 GMT (Thursday 29th June 2017)"
	revision: "1"

class
	LOG_FILTER

inherit
	EL_LOG_FILTER
		redefine
			class_type
		end

create
	make_from_tuple

convert
	make_from_tuple ({TUPLE [class_type: TYPE [EL_MODULE_LOG]; routines: STRING]})

feature {NONE} -- Initialization

	make_from_tuple (tuple: TUPLE [class_type: TYPE [EL_MODULE_LOG]; routines: STRING])
		do

		end

feature -- Access

	class_type: TYPE [EL_MODULE_LOG]

end
