note
	description: "Summary description for {EL_TEXT_EDITOR}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-10-06 16:35:42 GMT (Monday 6th October 2014)"
	revision: "4"

deferred class
	EL_TEXT_EDITOR

inherit
	EL_FILE_PARSER
		rename
			new_pattern as delimiting_pattern,
			consume_events as write_events_text
		redefine
			make_default
		end

	EL_TEXTUAL_PATTERN_FACTORY

	EL_MODULE_STRING

feature {NONE} -- Initialization

	make_default
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
				write_new_text
			end
		end

feature {NONE} -- Implementation

	write_new_text
		do
			output := new_output
			if is_utf8_encoded then
				output.put_string (UTF.utf_8_bom_to_string_8)
			end
			write_events_text
			close
		end

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
			if is_utf8_encoded then
				output.put_string (String.as_utf8 (str))
			else
				output.put_string (str.to_string_8)
			end
		end

	new_output: IO_MEDIUM
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

	replace (text: EL_STRING_VIEW; new_text: ASTRING)
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
