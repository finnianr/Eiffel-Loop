note
	description: "[
		Provides global access to the Evolicity template substitution engine.
	
		The templating substitution language was named "Evolicity" as a portmanteau of "Evolve" and "Felicity" 
		which is also a partial anagram of "Velocity" the Apache project which inspired it. 
		It also bows to an established tradition of naming Eiffel orientated projects starting with the letter 'E'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-14 15:47:39 GMT (Friday 14th June 2013)"
	revision: "2"

class
	EL_MODULE_EVOLICITY_ENGINE

inherit
	EL_MODULE

feature {NONE} -- Implementation

	Evolicity_engine: EVOLICITY_ENGINE
			--
		once
			create Result
		end

end
