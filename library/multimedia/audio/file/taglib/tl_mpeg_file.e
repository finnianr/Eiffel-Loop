note
	description: "Accesses MPEG file meta-data"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-11 12:19:21 GMT (Wednesday 11th March 2020)"
	revision: "8"

class
	TL_MPEG_FILE

inherit
	EL_OWNED_CPP_OBJECT
		export
			{ANY} dispose
		end

	TL_MPEG_FILE_CPP_API

create
	make

feature {NONE} -- Implementation

	make (path: EL_FILE_PATH)
		local
			file_name: TL_FILE_NAME
		do
			file_name := path
			make_from_pointer (cpp_new (file_name.item))
		end

feature -- Access

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

feature {NONE} -- Internal attributes



end
