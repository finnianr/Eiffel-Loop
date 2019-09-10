note
	description: "Table of functions converting date measurements to type [$source EL_ZSTRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-06 13:48:40 GMT (Friday 6th September 2019)"
	revision: "2"

class
	EL_DATE_FUNCTION_TABLE

inherit
	EL_HASH_TABLE [FUNCTION [DATE, ZSTRING], STRING]

create
	make
end
