note
	description: "Test set for class ${TANGO_MP3_FILE_COLLATOR}"
	notes: "[
		TANGO_MP3_FILE_COLLATOR is actually a command and not a task but it's possible
		to test it like this.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "8"

class
	TANGO_MP3_FILE_COLLATOR_TEST_SET

inherit
	RBOX_MANAGEMENT_TASK_TEST_SET [DEFAULT_TASK]
		redefine
			make
		end

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["mp3_file_collator", agent test_mp3_file_collator]
			>>)
		end

feature -- Tests

	test_mp3_file_collator
		do
			do_test ("execute", checksum, agent collate)
		end

feature {NONE} -- Implementation

	collate
		local
			command: TANGO_MP3_FILE_COLLATOR
		do
			create command.make (task.music_dir, True)
			command.execute
		end

feature {NONE} -- Constants

	Checksum: NATURAL = 2149331763

	Task_config: STRING = "[
		default:
			music_dir = "workarea/rhythmdb/Music"
	]"

end