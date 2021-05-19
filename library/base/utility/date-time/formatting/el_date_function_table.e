note
	description: "Table of functions converting date measurements to type [$source EL_ZSTRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-19 7:33:42 GMT (Wednesday 19th May 2021)"
	revision: "3"

class
	EL_DATE_FUNCTION_TABLE

inherit
	EL_HASH_TABLE [FUNCTION [DATE, ZSTRING], STRING]

create
	make
end