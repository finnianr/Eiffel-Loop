note
	description: "Find out if C routine pointer is linked to ROUTINE attribute"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-21 20:21:04 GMT (Sunday 21st May 2017)"
	revision: "2"

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
