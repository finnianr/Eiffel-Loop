note
	description: "Summary description for {EVOLICITY_SERIALIZEABLE_TEXT_VALUE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-16 8:15:47 GMT (Wednesday 16th December 2015)"
	revision: "4"

class
	EVOLICITY_SERIALIZEABLE_TEXT_VALUE

inherit
	EVOLICITY_SERIALIZEABLE_AS_XML

feature -- Access

	text: ZSTRING

feature {NONE} -- Evolicity reflection

	Template: STRING_32 = "$text"

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["text", agent: ZSTRING do Result := text end]
			>>)
		end

end
