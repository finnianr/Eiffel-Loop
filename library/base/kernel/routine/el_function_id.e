note
	description: "Function id"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "7"

class
	EL_FUNCTION_ID

inherit
	FUNCTION [ANY]
		export
			{NONE} all
			{EL_FUNCTION_ID} encaps_rout_disp
		redefine
			is_equal
		end

create
	make, default_create

feature -- Initialization

	make (other: FUNCTION [ANY])
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