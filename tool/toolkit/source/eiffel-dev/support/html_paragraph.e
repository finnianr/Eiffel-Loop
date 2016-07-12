note
	description: "Summary description for {HTML_PARAGRAPH}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-05 8:25:53 GMT (Tuesday 5th July 2016)"
	revision: "6"

class
	HTML_PARAGRAPH

inherit
	EVOLICITY_SERIALIZEABLE_TEXT_VALUE
		redefine
			getter_function_table
		end

create
	make

feature -- Status query

	is_preformatted: BOOLEAN
		do
			Result := False
		end

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			Result := Precursor
			Result.append_tuples (<<
				["is_preformatted", 	agent: BOOLEAN_REF do Result := is_preformatted end]
			>>)
		end

end
