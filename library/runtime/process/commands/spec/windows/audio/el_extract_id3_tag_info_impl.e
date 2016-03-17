note
	description: "Summary description for {EL_EXTRACT_ID3_TAG_INFO_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-09-16 10:02:08 GMT (Wednesday 16th September 2015)"
	revision: "3"

class
	EL_EXTRACT_ID3_TAG_INFO_IMPL

inherit
	EL_COMMAND_IMPL

feature -- Access

	template: STRING =
		--
	"[
		extract $path
	]"

end
