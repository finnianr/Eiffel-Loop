note
	description: "Accesses MPEG file meta-data"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "14"

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

	make (a_path: FILE_PATH)
		local
			file_name: TL_FILE_NAME
		do
			path := a_path
			file_name := a_path
			make_from_pointer (cpp_new (file_name.item))

			if has_version_2 then
				create {TL_ID3_V2_TAG} tag.make (cpp_ID3_v2_tag (self_ptr, False))

			elseif has_version_1 then
				create {TL_ID3_V1_TAG} tag.make (cpp_ID3_v1_tag (self_ptr, False))

			else
				create {TL_ID3_V0_TAG} tag
			end
		end

feature -- Access

	id3_version: TUPLE [version, major, revision: INTEGER]
		-- id3 version tuple of `tag'
		local
			h: TL_ID3_HEADER
		do
			create Result
			Result.version := tag.version
			h := tag.header
			Result.major := h.major_version
			Result.revision := h.revision_number
		end

	formatted_version: STRING
		local
			v: like id3_version
		do
			v := id3_version
			create Result.make (5)
			Result.append_integer (v.version)
			Result.append_character ('.')
			Result.append_integer (v.major)
		end

	duration: TIME_DURATION
			--
		do
			create Result.make_by_fine_seconds (tag.duration / 1000)
		end

	path: FILE_PATH

	tag: TL_ID3_TAG

feature -- Status query

	has_version_1: BOOLEAN
		do
			Result := cpp_has_id3_v1_tag (self_ptr)
		end

	has_version_2: BOOLEAN
		do
			Result := cpp_has_id3_v2_tag (self_ptr)
		end

	is_saved: BOOLEAN

feature -- Basic operations

	save
		-- save only the `tag' with `tag.type' and discard others
		do
			is_saved := cpp_save (self_ptr, tag.type)
		end

	save_version (v2_version: INTEGER)
		-- save only the `tag' with `tag.type' and discard others
		require
			valid_version: v2_version = 3 or v2_version = 4
		do
			is_saved := cpp_save_version (self_ptr, tag.type, True, v2_version)
		end

end