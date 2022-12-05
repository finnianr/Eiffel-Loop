note
	description: "Tar list file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-05 15:30:56 GMT (Monday 5th December 2022)"
	revision: "8"

deferred class
	TAR_LIST_FILE

inherit
	PLAIN_TEXT_FILE
		rename
			make as make_file
		export
			{NONE} all
		end

	EL_MODULE_NAMING

feature {NONE} -- Initialization

	make (a_backup: FTP_BACKUP)
			--
		local
			l_file_path: FILE_PATH
		do
			backup := a_backup
			l_file_path := backup.archive_dir + File_name

			make_open_write (l_file_path)

			write_specifiers

			close
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
			steps: DIR_PATH
		do
			steps := file_specifier
			Result := steps.base.starts_with_zstring (Star_dot)
							or else steps.first_step.starts_with_zstring (Star)
							or else steps.base.ends_with_zstring (Star)
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
			across specifier_list as specifier loop
				put_file_specifier (specifier.item)
			end
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