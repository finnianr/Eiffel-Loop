note
	description: "Summary description for {EL_STRING_EDITOR}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-08-05 8:30:13 GMT (Friday 5th August 2016)"
	revision: "2"

deferred class
	EL_STRING_EDITOR

inherit
	EL_PARSER_TEXT_EDITOR
		export
			{NONE} all
			{ANY} fully_matched
		redefine
			make_default
		end

feature {NONE} -- Initialization

	make_default
			--
		do
			Precursor
			create edited_text.make_empty
		end

feature -- Access

	edited_text: ZSTRING
		-- Edited text

feature -- Basic operations

	edit_text (a_text: ZSTRING)
			--
		do
			set_source_text (a_text)
			edited_text.wipe_out
			edit
		end

feature {NONE} -- Implementation

	new_output: EL_ZSTRING_IO_MEDIUM
			--
		do
			create Result.make_open_write_to_text (edited_text)
		end

end
