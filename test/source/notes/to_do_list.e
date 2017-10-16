note
	description: "Summary description for {TO_DO_LIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:02 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	TO_DO_LIST

inherit
	PROJECT_NOTES

feature -- Access

	optimise_EL_MATCH_COUNT_WITHIN_BOUNDS_TP2
		do
			-- Recycle instances of repeated pattern
		end

	output_medium
		do
			-- change put_zstring to put_string_z
		end

	myching_server
		do
			-- * Check if sub pack email is being delivered
			-- * Check why Jenny's name is not in database after being carefully cut and pasted
		end

	string_translate
		do
			-- Make sure that null characters are being explicitly interpreted as deletion using translate_and_delete
			-- Also check EL_PATH.translate
		end

	document_build
		do
			-- Refactor EL_CREATEABLE_FROM_XML to use class heirarchy instead of build_from_this, build_from_that
		end

	xml_routines
		do
			-- See which program is calling

			-- 	{EL_XML_ROUTINES}.data_payload_character_count  (xml_text: STRING_8)

			-- and see whether STRING_8 is appropriate argument. For the time being have changed it to ZSTRING
		end

end