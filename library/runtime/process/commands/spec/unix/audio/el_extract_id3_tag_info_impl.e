note
	description: "Summary description for {EL_EXTRACT_ID3_TAG_INFO_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-16 22:49:34 GMT (Sunday 16th June 2013)"
	revision: "2"

class
	EL_EXTRACT_ID3_TAG_INFO_IMPL

inherit
	EL_COMMAND_IMPL

feature -- Access

	template: STRING_32 = "[
		extract "$path"
	]"

end
