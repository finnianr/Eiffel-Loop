note
	description: "Summary description for {EL_FUNCTION_ID}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:27 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_FUNCTION_ID

inherit
	FUNCTION [ANY, TUPLE, ANY]
		export
			{NONE} all
			{EL_FUNCTION_ID} encaps_rout_disp
		redefine
			is_equal
		end

create
	make, default_create

feature -- Initialization

	make (other: FUNCTION [ANY, TUPLE, ANY])
			--
		do
			encaps_rout_disp := other.encaps_rout_disp
		end

feature -- Status report

	is_equal (other: like Current): BOOLEAN
			--
		do
			Result := encaps_rout_disp = other.encaps_rout_disp
		end

end
