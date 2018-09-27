note
	description: "J output stream writer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "4"

class
	J_OUTPUT_STREAM_WRITER

inherit
	J_WRITER
		undefine
			Jclass
		end

feature -- Access

	close
			--
		do
			jagent_close.call (Current, [])
		end

feature {NONE} -- Implementation

	jagent_close: JAVA_PROCEDURE [J_OUTPUT_STREAM_WRITER]
			--
		once
			create Result.make ("close", agent close)
		end

feature {NONE} -- Constant

	Jclass: JAVA_CLASS_REFERENCE
			--
		once
			create Result.make (Package_name, "OutputStreamWriter")
		end

end