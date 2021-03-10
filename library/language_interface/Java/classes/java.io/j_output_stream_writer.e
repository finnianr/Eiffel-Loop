note
	description: "Interface to Java class: `java.io.svg.OutputStreamWriter'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-10 15:49:47 GMT (Wednesday 10th March 2021)"
	revision: "5"

class
	J_OUTPUT_STREAM_WRITER

inherit
	J_WRITER

feature -- Access

	close
			--
		do
			jagent_close.call (Current, [])
		end

feature {NONE} -- Implementation

	jagent_close: JAVA_PROCEDURE
			--
		once
			create Result.make ("close", agent close)
		end

end