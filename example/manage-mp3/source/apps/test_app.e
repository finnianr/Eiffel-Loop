note
	description: "Test app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-19 9:04:54 GMT (Saturday 19th October 2019)"
	revision: "3"

class
	TEST_APP

inherit
	EL_SUB_APPLICATION

	EL_MODULE_OS

	EL_MODULE_DIRECTORY

create
	make

feature {NONE} -- Initiliazation

	initialize
		do

		end

feature -- Basic operations

	run
		do
			lio.enter ("test_id3")
			test_id3

			lio.exit
		end


feature -- Tests

	test_id3
		local
			underbit: EL_UNDERBIT_ID3_TAG_INFO
		do
			create underbit.make
--			info.link_and_read (Directory.home + "Music/Tango/Carlos di Sarli/Al Compás Del Corazón.02.mp3")
--			lio.put_integer_field ("", field_value: INTEGER_32)
--			put_frames (info.frame_list)
--			info.wipe_out

			print_id3 (underbit, Projects_data, "*")
--			print_id3 (create {EL_LIBID3_TAG_INFO}.make)
		end

	print_id3 (info: EL_ID3_INFO_I; a_dir: EL_DIR_PATH; filter: STRING)
		local

		do
			lio.put_line (info.generator)
			across OS.file_list (a_dir, filter) as tag loop
				info.link_and_read (tag.item)
				lio.put_path_field ("tag", tag.item.relative_path (Projects_data))
				lio.put_new_line
				put_frames (info.frame_list)
			end
		end

	put_frames (frame_list: ARRAYED_LIST [EL_ID3_FRAME])
		do
			across frame_list as frame loop
				lio.put_string_field (
					template #$ [frame.cursor_index, frame.item.code, frame.item.encoding_name],
					frame.item.string
				)
				if frame.item.has_description then
					lio.put_string (" (")
					lio.put_string (frame.item.description)
					lio.put_string (")")
				end
				if frame.item.has_binary_data then
					lio.put_string (" (count = ")
					lio.put_integer (frame.item.binary_data.count)
					lio.put_string (")")
				end
				lio.put_new_line
			end
			lio.put_new_line
		end

feature {NONE} -- Constants

	Description: STRING = "Perform development tests"

	Rhythmdb_tasks_dir: EL_DIR_PATH
		once
			Result := "test-data/rhythmdb-tasks"
		end

	Projects_data: EL_DIR_PATH
		once
			Result := "$EIFFEL_LOOP/projects.data/id3$"
			Result.expand
		end

	Template: ZSTRING
		once
			Result := "frame [%S]: %S (%S)"
		end
end
