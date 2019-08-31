note
	description: "Syntax experiments"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-08-30 16:53:18 GMT (Friday 30th August 2019)"
	revision: "2"

class
	SYNTAX_EXPERIMENTS

inherit
	EXPERIMENTAL

feature -- Equality

	my_routine
		local
			a1, a2, a3: INTEGER_REF
			b1, b2: INTEGER
		do
			if a1 = a2 then
				-- something
			end
			if b1 = b2 then
				-- something
			end
			if a1 = b2 then

			end
		end

	ref_equal_to_expanded
		local
			a: INTEGER_REF; b: INTEGER
			bool: BOOLEAN
		do
			a := 1; b := 1
			bool := a = b
			bool := a ~ b
		end

end
