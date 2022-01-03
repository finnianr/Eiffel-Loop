note
	description: "Tar list file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:52:09 GMT (Monday 3rd January 2022)"
	revision: "3"

deferred class
	TAR_LIST_FILE

inherit
	PLAIN_TEXT_FILE
		rename
			make as make_file
		export
			{NONE} all
		end

	EL_MODULE_LOG

	EL_MODULE_NAMING

feature {NONE} -- Initialization

	make (a_backup: FTP_BACKUP)
			--
		local
			l_file_path: FILE_PATH
		do
			log.enter ("make")
			backup := a_backup
			l_file_path := backup.archive_dir + File_name
			l_file_path.enable_out_abbreviation

			make_open_write (l_file_path)

			log.put_path_field ("file_name", l_file_path)
			log.put_new_line

			write_specifiers

			close
			log.exit
		end

feature -- Access

	file_path: FILE_PATH
		do
			Result := path
		end

feature {NONE} -- Implementation

	file_name: STRING
		deferred
		end

	is_wild_card (file_specifier: ZSTRING): BOOLEAN
		local
			steps: EL_PATH_STEPS
		do
			steps := file_specifier
			Result := steps.last.starts_with (Star_dot)
							or else steps.first.starts_with (Star)
							or else steps.last.ends_with (Star)
		end

	put_file_specifier (file_specifier: ZSTRING)
			--
		do
			put_string (file_specifier)
			put_new_line
		end

	specifier_list: EL_ZSTRING_LIST
		deferred
		end

	write_specifiers
			--
		do
			log.enter ("write_specifiers")
			across specifier_list as specifier loop
				lio.put_string_field (Naming.class_as_snake_lower (Current, 0, 1), specifier.item)
				lio.put_new_line
				put_file_specifier (specifier.item)
			end
			log.exit
		end

feature {NONE} -- Internal attributes

	backup: FTP_BACKUP

feature {NONE} -- Constants

	Star: ZSTRING
		once
			Result := "*"
		end

	Star_dot: ZSTRING
		once
			Result := "*."
		end

end
