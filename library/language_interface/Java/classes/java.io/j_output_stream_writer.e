note
	description: "Summary description for {J_OUTPUT_STREAM_WRITER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:59 GMT (Thursday 12th October 2017)"
	revision: "2"

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