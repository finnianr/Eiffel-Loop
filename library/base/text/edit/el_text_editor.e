note
	description: "Summary description for {EL_TEXT_EDITOR}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-01-20 9:37:28 GMT (Wednesday 20th January 2016)"
	revision: "1"

deferred class
	EL_TEXT_EDITOR

inherit
	EL_FILE_PARSER
		rename
			new_pattern as delimiting_pattern
		redefine
			make_default
		end

	EL_ZTEXT_PATTERN_FACTORY

feature {NONE} -- Initialization

	make_default
			--
		do
			Precursor
			set_unmatched_action (agent on_unmatched_text)
		end

feature -- Basic operations

	edit
		do
			output := new_output
			find_all
			close
		end

feature {NONE} -- Implementation

	put_new_line
			--
		do
			output.put_new_line
		end

	put_string (str: READABLE_STRING_GENERAL)
			-- Write `s' at current position.
		do
			output.put_string (str)
		end

	new_output: EL_OUTPUT_MEDIUM
			--
		deferred
		end

	close
			--
		do
			output.close
		end

	on_unmatched_text (text: EL_STRING_VIEW)
			--
		do
			put_string (text)
		end

	replace (text: EL_STRING_VIEW; new_text: ZSTRING)
			--
		do
			put_string (new_text)
		end

	delete (text: EL_STRING_VIEW)
			--
		do
		end

	output: like new_output

end