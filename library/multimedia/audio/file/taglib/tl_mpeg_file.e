note
	description: "TagLib mpeg file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-27 10:43:21 GMT (Sunday   27th   October   2019)"
	revision: "3"

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

	tag_v1: TL_ID3_V2_TAG
		require
			has_version_1: has_id3_v1_tag
		do
			create Result.make (cpp_ID3_v1_tag (self_ptr, False))
		end

	tag_v2: TL_ID3_V2_TAG
		require
			has_version_2: has_id3_v2_tag
		do
			create Result.make (cpp_ID3_v2_tag (self_ptr, False))
		end

	tag: TL_ID3_TAG
		do
			inspect tag_version
				when 1 then
					Result := tag_v2
				when 2 then
					Result := tag_v1
			else
				create {TL_DEFAULT_ID3_TAG} Result
			end
		end

	tag_version: INTEGER
		do
			if has_id3_v1_tag then
				Result := 1
			elseif has_id3_v2_tag then
				Result := 2
			end
		end

feature -- Status query

	has_id3_v1_tag: BOOLEAN
		do
			Result := cpp_has_id3_v2_tag (self_ptr)
		end

	has_id3_v2_tag: BOOLEAN
		do
			Result := cpp_has_id3_v2_tag (self_ptr)
		end

end