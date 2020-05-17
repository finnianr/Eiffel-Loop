note
	description: "Conforming singleton"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-17 9:25:47 GMT (Sunday 17th May 2020)"
	revision: "2"

class
	EL_CONFORMING_SINGLETON [G]

inherit
	EL_SINGLETON [G]
		redefine
			exception_insert, match_conforming
		end

convert
	item: {G}

feature {NONE} -- Implementation

	exception_insert: TUPLE
		do
			Result := ["conforming to " + base_type.name]
		end

feature {NONE} -- Constants

	Match_conforming: BOOLEAN = True
		--  if `True' then a type conforming to `G' may be also be assigned
end
