note
	description: "Summary description for {J_OUTPUT_STREAM_WRITER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2011-07-24 9:48:02 GMT (Sunday 24th July 2011)"
	revision: "1"

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
			log.enter ("close")
			jagent_close.call (Current, [])
			log.exit
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
