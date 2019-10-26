note
	description: "TagLib mpeg file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-26 17:54:19 GMT (Saturday   26th   October   2019)"
	revision: "2"

class
	TL_MPEG_FILE

inherit
	EL_OWNED_CPP_OBJECT
		export
			{ANY} dispose
		end

	TL_MPEG_FILE_CPP_API

	EL_SHARED_ONCE_ZSTRING

create
	make

feature {NONE} -- Implementation

	make (path: EL_FILE_PATH)
		local
			file_name: TL_FILE_NAME; str: ZSTRING
		do
			str := empty_once_string; path.append_to (str)
			create file_name.make (str)
			make_from_pointer (cpp_new (file_name.item))
		end

feature -- Access

	tag_v2: TL_ID3_V2_TAG
		require
			has_version_2: has_id3_v2_tag
		do
			create Result.make (cpp_ID3_v2_tag (self_ptr, False))
		end

feature -- Status query

	has_id3_v2_tag: BOOLEAN
		do
			Result := cpp_has_id3_v2_tag (self_ptr)
		end

end
