note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-02-17 14:40:15 GMT (Saturday 17th February 2018)"
	revision: "3"

class
	EVOLICITY_FREE_TEXT_DIRECTIVE

inherit
	EVOLICITY_DIRECTIVE

create
	make

feature {NONE} -- Initialization

	make (a_text: like text)
		do
			text := a_text
		end

feature -- Access

	text: ZSTRING

feature -- Basic operations

	execute (context: EVOLICITY_CONTEXT; output: EL_OUTPUT_MEDIUM)
			--
		do
			output.put_string (text)
		end

end
