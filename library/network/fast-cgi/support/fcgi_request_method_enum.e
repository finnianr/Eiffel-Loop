note
	description: "Enumeration of HTTP request methods"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-01-31 8:34:23 GMT (Friday 31st January 2025)"
	revision: "3"

class
	FCGI_REQUEST_METHOD_ENUM

inherit
	EL_ENUMERATION_NATURAL_8
		rename
			description_table as No_descriptions,
			foreign_naming as Snake_case_upper
		end

create
	make

feature -- Codes

	GET: NATURAL_8

	HEAD: NATURAL_8

	POST: NATURAL_8

	PUT: NATURAL_8

	DELETE: NATURAL_8

	CONNECT: NATURAL_8

	OPTIONS: NATURAL_8

	TRACE: NATURAL_8

	PATCH: NATURAL_8

feature {NONE} -- Constants

	Snake_case_upper: EL_SNAKE_CASE_TRANSLATER
		once
			Result := {EL_CASE}.Upper
		end
end