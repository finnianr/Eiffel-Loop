note
	description: "[
		Procedure identifier based on address of Eiffel routine dispatcher
		As it is not possible to compare agent references this serves as a workaround
		allowing you to determine whether two agents refer to the same procedure.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-06-01 12:20:21 GMT (Monday 1st June 2015)"
	revision: "3"

class
	EL_PROCEDURE

inherit
	PROCEDURE [ANY, TUPLE]
		export
			{NONE} all
		end

create
	make, default_create

convert
	make ({PROCEDURE [ANY, TUPLE]})

feature -- Initialization

	make (other: PROCEDURE [ANY, TUPLE])
			--
		do
			encaps_rout_disp := other.encaps_rout_disp
		end

feature -- Comparison

	same_procedure (other: PROCEDURE [ANY, TUPLE]): BOOLEAN
			--
		do
			Result := encaps_rout_disp = other.encaps_rout_disp
		end

end
