note
	description: "Accesses MPEG file meta-data"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-29 11:00:57 GMT (Tuesday   29th   October   2019)"
	revision: "5"

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

	tag_v1: TL_ID3_V1_TAG
		require
			has_version_1: has_version_1
		do
			create Result.make (cpp_ID3_v1_tag (self_ptr, False))
		end

	tag_v2: TL_ID3_V2_TAG
		require
			has_version_2: has_version_2
		do
			create Result.make (cpp_ID3_v2_tag (self_ptr, False))
		end

	tag: TL_ID3_TAG
		do
			inspect tag_version
				when 1 then
					Result := tag_v1
				when 2 then
					Result := tag_v2
			else
				create {TL_DEFAULT_ID3_TAG} Result
			end
		end

	tag_version: INTEGER
		-- highest available tag version
		do
			-- prioritize v2 tag over v1, because maybe both exist
			if has_version_2 then
				Result := 2
			elseif has_version_1 then
				Result := 1
			end
		end

feature -- Status query

	has_version_1: BOOLEAN
		do
			Result := cpp_has_id3_v1_tag (self_ptr)
		end

	has_version_2: BOOLEAN
		do
			Result := cpp_has_id3_v2_tag (self_ptr)
		end

end
