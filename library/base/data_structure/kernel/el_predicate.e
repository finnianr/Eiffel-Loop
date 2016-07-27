note
	description: "Summary description for {EL_PREDICATE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-21 8:21:12 GMT (Tuesday 21st June 2016)"
	revision: "3"

class
	EL_PREDICATE

inherit
	PREDICATE [ANY, TUPLE]
		export
			{NONE} all
		end

create
	make, default_create

feature -- Initialization

	make (other: PREDICATE [ANY, TUPLE])
			--
		do
			encaps_rout_disp := other.encaps_rout_disp
		end

feature -- Comparison

	same_predicate (other: PREDICATE [ANY, TUPLE]): BOOLEAN
			--
		do
			Result := encaps_rout_disp = other.encaps_rout_disp
		end

end