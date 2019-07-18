note
	description: "[
		Provides global access to the Evolicity template substitution engine.

		The templating substitution language was named "Evolicity" as a portmanteau of "Evolve" and "Felicity" 
		which is also a partial anagram of "Velocity" the Apache project which inspired it. 
		It also bows to an established tradition of naming Eiffel orientated projects starting with the letter 'E'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 8:59:44 GMT (Monday 1st July 2019)"
	revision: "5"

deferred class
	EL_MODULE_EVOLICITY_TEMPLATES

inherit
	EL_MODULE

feature {NONE} -- Constants

	Evolicity_templates: EVOLICITY_TEMPLATES
			--
		once
			create Result.make
		end

end
