note
	description: "Tag info test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-26 18:00:46 GMT (Saturday   26th   October   2019)"
	revision: "3"

class
	TAG_INFO_TEST_SET

inherit
	ID3_TEST_SET

	EL_MEMORY undefine default_create end

feature -- Tests

	test_read_id3
		do
			across file_list as path loop
				put_header (path.item)
			end
		end

	put_header (a_path: EL_FILE_PATH)
		local
			mp3: TL_MPEG_FILE; header: TL_ID3_V2_HEADER
		do
			lio.put_path_field ("ID3", a_path.relative_path (Work_area_dir))
			lio.put_new_line

			create mp3.make (a_path)
			if mp3.has_id3_v2_tag then
				header := mp3.tag_v2.header
				lio.put_integer_field ("major_version", header.major_version)
				lio.put_new_line
				lio.put_integer_field ("revision_number", header.revision_number)
				lio.put_new_line
			else
				lio.put_line ("No ID3 version 2 tags")
			end
			lio.put_new_line
			mp3.dispose -- Allow deletion of files
		end

feature {NONE} -- Constants

	Filter: STRING = "*"

end
