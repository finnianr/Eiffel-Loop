note
	description: "Summary description for {EL_STRING_EDITOR}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-22 18:08:02 GMT (Monday 22nd July 2013)"
	revision: "4"

deferred class
	EL_STRING_EDITOR

inherit
	EL_TEXT_EDITOR
		export
			{NONE} all
			{ANY} full_match_succeeded
		redefine
			make
		end

feature {NONE} -- Initialization

	make
			--
		do
			Precursor
			create utf8_output_text.make_empty
		end

feature -- Access

	edited_text: EL_ASTRING
		-- Edited text
		do
			create Result.make_from_utf8 (utf8_output_text)
		end

feature -- Basic operations

	edit (a_text: EL_ASTRING)
			--
		do
			set_source_text (a_text)
			utf8_output_text.wipe_out
			edit_text
		end

feature {NONE} -- Implementation

	utf8_output_text: STRING

	new_output: EL_TEXT_IO_MEDIUM
			--
		do
			create Result.make_open_write_to_string (utf8_output_text)
		end

end
