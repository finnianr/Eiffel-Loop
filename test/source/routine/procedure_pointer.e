note
	description: "Find out if C routine pointer is linked to ROUTINE attribute"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-08-11 14:25:18 GMT (Thursday 11th August 2016)"
	revision: "1"

class
	PROCEDURE_POINTER

inherit
	EL_PROCEDURE
		rename
			make as make_procedure
		end

create
	make

feature -- Initialization

	make (other: PROCEDURE; procedure_address: POINTER)
			--
		do
			make_procedure (other)
		end
end
