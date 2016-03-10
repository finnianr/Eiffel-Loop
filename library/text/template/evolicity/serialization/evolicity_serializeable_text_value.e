note
	description: "Summary description for {EVOLICITY_SERIALIZEABLE_TEXT_VALUE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-27 18:34:13 GMT (Thursday 27th June 2013)"
	revision: "2"

class
	EVOLICITY_SERIALIZEABLE_TEXT_VALUE

inherit
	EVOLICITY_SERIALIZEABLE_AS_XML

feature -- Access

	text: STRING

feature {NONE} -- Evolicity reflection

	Template: STRING_32 = "$text"

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["text", agent : STRING do Result := text end]
			>>)
		end

end
