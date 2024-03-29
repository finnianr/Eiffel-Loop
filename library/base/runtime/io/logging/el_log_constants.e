note
	description: "Log constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "3"

deferred class
	EL_LOG_CONSTANTS

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Show_all: NATURAL_8 = 1

	Show_none: NATURAL_8 = 2

	Show_selected: NATURAL_8 = 3

end