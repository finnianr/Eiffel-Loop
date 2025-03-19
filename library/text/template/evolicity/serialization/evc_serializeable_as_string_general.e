note
	description: "Object that is serializeable to string of type `like once_medium.text'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-18 7:03:27 GMT (Tuesday 18th March 2025)"
	revision: "4"

deferred class
	EVC_SERIALIZEABLE_AS_STRING_GENERAL

inherit
	EVC_SERIALIZEABLE

feature -- Access

	as_text: like once_medium.text
		local
			medium: like once_medium
		do
			medium := once_medium
			medium.open_write
			Evolicity_templates.merge (template_name, Current, medium)
			Result := medium.text
			medium.close
		end

feature {NONE} -- Implementation

	once_medium: EL_STRING_IO_MEDIUM
		-- implement as once function
		deferred
		end

end