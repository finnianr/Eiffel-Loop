note
	description: "[
		Procedure identifier based on address of Eiffel routine dispatcher
		As it is not possible to compare agent references this serves as a workaround
		allowing you to determine whether two agents refer to the same procedure.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-18 12:36:30 GMT (Tuesday 18th June 2013)"
	revision: "2"

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

	make (a_procedure: like procedure)
			--
		do
			procedure := a_procedure
		end

feature -- Status query

	same_procedure (other: like procedure): BOOLEAN
			--
		do
			Result := procedure.encaps_rout_disp = other.encaps_rout_disp
		end

feature {NONE} -- Implementation

	procedure: PROCEDURE [ANY, TUPLE]

end
