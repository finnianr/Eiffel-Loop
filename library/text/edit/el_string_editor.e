note
	description: "Summary description for {EL_STRING_EDITOR}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:12 GMT (Tuesday 2nd September 2014)"
	revision: "6"

deferred class
	EL_STRING_EDITOR

inherit
	EL_TEXT_EDITOR
		export
			{NONE} all
			{ANY} full_match_succeeded
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

	edited_text: ASTRING
		-- Edited text

feature -- Basic operations

	edit (a_text: ASTRING)
			--
		do
			set_source_text (a_text)
			edited_text.wipe_out
			edit_text
		end

feature {NONE} -- Implementation

	new_output: EL_TEXT_IO_MEDIUM
			--
		do
			create Result.make_open_write_to_text (edited_text)
		end

end
