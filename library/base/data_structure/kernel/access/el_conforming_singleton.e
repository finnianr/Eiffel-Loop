note
	description: "Summary description for {EL_CONFORMING_SINGLETON}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_CONFORMING_SINGLETON [G]

inherit
	EL_SINGLETON [G]
		redefine
			exception_insert, match_conforming
		end

convert
	singleton: {G}

feature {NONE} -- Implementation

	exception_insert: TUPLE
		do
			Result := ["conforming to " + ({G}).name]
		end

feature {NONE} -- Constants

	Match_conforming: BOOLEAN = True
		--  if `True' then a type conforming to `G' may be also be assigned
end
