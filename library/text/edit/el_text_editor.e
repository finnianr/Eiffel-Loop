note
	description: "Summary description for {EL_TEXT_EDITOR}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-28 12:25:21 GMT (Sunday 28th July 2013)"
	revision: "2"

deferred class
	EL_TEXT_EDITOR

inherit
	EL_FILE_PARSER
		rename
			new_pattern as delimiting_pattern,
			consume_events as write_new_text
		redefine
			make
		end

	EL_TEXTUAL_PATTERN_FACTORY

	EL_MODULE_STRING

feature {NONE} -- Initialization

	make
			--
		do
			Precursor
			set_unmatched_text_action (agent on_unmatched_text)
			set_source_text (create {STRING}.make_empty)
		end

feature -- Basic operations

	edit_text
			--
		do
			find_all
			if at_least_one_match_found then
				output := new_output
				write_new_text
				close
			end
		end

feature {NONE} -- Implementation

	put_new_line
			--
		require
			valid_output: output /= Void
		do
			output.put_new_line
		end

	put_string (str: READABLE_STRING_GENERAL)
			-- Write `s' at current position.
		do
			output.put_string (String.as_utf8 (str))
		end

	new_output: like output
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

	replace (text: EL_STRING_VIEW; new_text: EL_ASTRING)
			--
		do
			put_string (new_text)
		end

	delete (text: EL_STRING_VIEW)
			--
		do
		end

	output: IO_MEDIUM

end
