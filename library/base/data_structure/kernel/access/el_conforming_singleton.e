note
	description: "Conforming singleton"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-04 17:39:16 GMT (Friday   4th   October   2019)"
	revision: "1"

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
