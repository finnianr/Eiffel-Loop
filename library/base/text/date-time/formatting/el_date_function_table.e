note
	description: "Table of functions converting date measurements to type ${ZSTRING}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-22 13:39:38 GMT (Sunday 22nd September 2024)"
	revision: "8"

class
	EL_DATE_FUNCTION_TABLE

inherit
	EL_STRING_8_TABLE [FUNCTION [DATE, ZSTRING]]

create
	make_assignments
end