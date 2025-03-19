note
	description: "[
		Provides global access to the Evolicity template substitution engine.

		The templating substitution language was named "Evolicity" as a portmanteau of "Evolve" and "Felicity" 
		which is also a partial anagram of "Velocity" the Apache project which inspired it. 
		It also bows to an established tradition of naming Eiffel orientated projects starting with the letter 'E'.
	]"
	notes: "See end of page"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-18 7:13:26 GMT (Tuesday 18th March 2025)"
	revision: "13"

deferred class
	EVC_SHARED_TEMPLATES

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Evolicity_templates: EVC_TEMPLATES
			--
		once
			create Result.make
		end

end