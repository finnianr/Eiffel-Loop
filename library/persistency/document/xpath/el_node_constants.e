note
	description: "Constants for document node scanning"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-23 15:43:42 GMT (Sunday 23rd July 2023)"
	revision: "1"

class
	EL_NODE_CONSTANTS

feature {NONE} -- Constants

	Node_START: INTEGER = 0

	Node_END: INTEGER = 1

	on_close: BOOLEAN = False

	on_open: BOOLEAN = True

end