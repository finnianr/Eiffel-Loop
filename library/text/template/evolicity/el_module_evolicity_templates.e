note
	description: "[
		Provides global access to the Evolicity template substitution engine.
	
		The templating substitution language was named "Evolicity" as a portmanteau of "Evolve" and "Felicity" 
		which is also a partial anagram of "Velocity" the Apache project which inspired it. 
		It also bows to an established tradition of naming Eiffel orientated projects starting with the letter 'E'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-04 7:50:54 GMT (Monday 4th July 2016)"
	revision: "4"

class
	EL_MODULE_EVOLICITY_TEMPLATES

inherit
	EL_MODULE

feature -- Access

	Evolicity_templates: EVOLICITY_TEMPLATES
			--
		once
			create Result.make
		end

end