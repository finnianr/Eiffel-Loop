note
	description: "Log constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-11-10 9:49:57 GMT (Tuesday 10th November 2020)"
	revision: "2"

deferred class
	EL_LOG_CONSTANTS

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Show_all: NATURAL_8 = 1

	Show_none: NATURAL_8 = 2

	Show_selected: NATURAL_8 = 3

end