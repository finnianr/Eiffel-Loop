note
	description: "Interface to Java class: `java.io.svg.OutputStreamWriter'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "7"

class
	J_OUTPUT_STREAM_WRITER

inherit
	J_WRITER

feature -- Access

	close
			--
		do
			Jagent_close.call (Current, [])
		end

feature {NONE} -- Constants

	Jagent_close: JAVA_PROCEDURE
			--
		once
			create Result.make ("close", agent close)
		end

end