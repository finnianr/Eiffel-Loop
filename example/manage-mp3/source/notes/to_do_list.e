note
	description: "Summary description for {TO_DO_LIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-09-24 13:11:54 GMT (Saturday 24th September 2016)"
	revision: "2"

class
	TO_DO_LIST

inherit
	PROJECT_NOTES

feature -- Access

	id3_editing
		do
			-- Make sure to use {RBOX_SONG}.write_id3_info for writing changes so that
			-- mtime is updated

			-- Look at EL_ID3_FRAME
		end

feature -- Year 2016

	pyxis_playlist -- Sep 24
		do
			-- Fix 1000 errors
			-- Exported song not found: Vals/Alfredo de Angelis/Pobre Flor.02.mp3
			-- Venue: The Globe Pub Date: 10/6/2010
		end

end
