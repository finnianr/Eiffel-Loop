note
	description: "Syntax experiments"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-08-23 10:43:43 GMT (Friday 23rd August 2019)"
	revision: "1"

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
		end

end
