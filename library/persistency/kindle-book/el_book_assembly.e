note
	description: "[
		Assembly of all book components including OPF package, navigation control file and HTML table of contents
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-08 9:25:49 GMT (Thursday 8th May 2025)"
	revision: "15"

class
	EL_BOOK_ASSEMBLY

inherit
	EL_ARRAYED_MAP_LIST [NATURAL, EL_BOOK_CHAPTER]
		rename
			value_list as chapter_list,
			item_key as chapter_number,
			make as make_with_count
		export
			{NONE} all
			{ANY} chapter_list, chapter_number
		end

	EL_MODULE_EXECUTABLE

create
	make

feature {NONE} -- Initialization

	make (a_info: EL_BOOK_INFO; a_chapter_list: CONTAINER [EL_BOOK_CHAPTER]; a_output_dir: DIR_PATH)
		do
			make_from_values (a_chapter_list, agent {EL_BOOK_CHAPTER}.number)
			output_dir := a_output_dir
			info := a_info
			sort_by_key (True)
		end

feature -- Access

	image_path_set: EL_HASH_SET [FILE_PATH]
		local
			list: like chapter_list
		do
			list := chapter_list
			create Result.make_equal (list.sum_integer (agent image_list_count))
			across list as chapter loop
				across chapter.item.image_list as path loop
					Result.put (path.item)
				end
			end
		end

	info: EL_BOOK_INFO

	output_dir: DIR_PATH

feature -- Basic operations

	write_files
		local
			parts: ARRAY [EL_SERIALIZEABLE_BOOK_INDEXING]
			package: EL_BOOK_PACKAGE
		do
			create package.make (Current)
			parts := <<
				create {EL_BOOK_NAVIGATION_CONTROL_FILE}.make (Current),
				create {EL_BOOK_HTML_CONTENTS_TABLE}.make (Current),
				package
			>>
			parts.do_all (agent {EL_SERIALIZEABLE_BOOK_INDEXING}.serialize)
			if Executable.is_finalized then
				Kindlegen.set_working_directory (output_dir)
				Kindlegen.put_string ("name", package.output_path.base)
				Kindlegen.execute
			end
		end

feature {NONE} -- Implementation

	image_list_count (chapter: EL_BOOK_CHAPTER): INTEGER
		do
			Result := chapter.image_list.count
		end

feature {NONE} -- Constants

	Kindlegen: EL_OS_COMMAND
		once
			create Result.make ("kindlegen $name")
		end
end