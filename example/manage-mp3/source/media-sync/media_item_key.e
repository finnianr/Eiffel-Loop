note
	description: "Summary description for {MEDIA_ITEM_KEY}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-22 18:08:04 GMT (Monday 22nd July 2013)"
	revision: "3"

class
	MEDIA_ITEM_KEY

inherit
	HASHABLE
		undefine
			is_equal
		end

	PLATFORM
		undefine
			is_equal
		end

create
	make

feature {NONE} -- Initialization

	make (a_path: EL_ASTRING; a_id_code, a_hash_code: INTEGER)
			--
		do
			path := a_path
			id_code := a_id_code
			hash_code := a_hash_code
		end

feature -- Access

	path: EL_ASTRING

	id_code: INTEGER

	hash_code: INTEGER

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
			--
		do
			Result := path ~ other.path and then id_code = other.id_code
		end

end