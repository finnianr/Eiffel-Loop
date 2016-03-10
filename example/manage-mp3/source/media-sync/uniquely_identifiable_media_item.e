note
	description: "Summary description for {UNIQUELY_IDENTIFIABLE_MEDIA_ITEM}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:19 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	UNIQUELY_IDENTIFIABLE_MEDIA_ITEM

inherit
	MEDIA_ITEM
		redefine
			make, key
		end

	EL_MODULE_LOG

	EL_MODULE_STRING

feature {NONE} -- Initialization

	make (a_mp3_path: like mp3_path; a_root_path: like root_path)
			--
		do
			Precursor (a_mp3_path, a_root_path)
		end

feature -- Access

	key: MEDIA_ITEM_KEY
			--
		do
			create Result.make (once "", unique_id, unique_id.hash_code)
		end

	unique_id: INTEGER

feature -- Status report

	has_unique_id: BOOLEAN
			--
		do
			Result := unique_id > 0
		end

end
