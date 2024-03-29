note
	description: "Predicate"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "7"

class
	EL_PREDICATE

inherit
	PREDICATE
		export
			{NONE} all
		end

create
	make, default_create

feature -- Initialization

	make (other: PREDICATE)
			--
		do
			encaps_rout_disp := other.encaps_rout_disp
		end

feature -- Comparison

	same_predicate (other: PREDICATE): BOOLEAN
			--
		do
			Result := encaps_rout_disp = other.encaps_rout_disp
		end

end