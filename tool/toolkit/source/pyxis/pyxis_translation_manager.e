note
	description: "Summary description for {PYXIS_TRANSLATION_CHECK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PYXIS_TRANSLATION_MANAGER

inherit
	EL_COMMAND

	EL_MODULE_LOG

	EL_MODULE_OS

	EL_MODULE_FILE_SYSTEM

create
	make, default_create

feature {EL_COMMAND_LINE_SUB_APPLICATION} -- Initialization

	make (a_source_tree_path: EL_DIR_PATH; a_query: like query; a_edit: like edit)
		do
			source_tree_path := a_source_tree_path; query := a_query; edit := a_edit
		end

feature -- Basic operations

	execute
			--
		do
			log.enter ("execute")
			File_system.recursive_files_with_extension (source_tree_path, "pyx").do_all (agent do_with_file)
			log.exit
		end

feature {NONE} -- Implementation

	add_check_attribute (file_path: EL_FILE_PATH)
		local
			lines: EL_ZSTRING_LIST; line, trim_line: ZSTRING
			line_source: EL_FILE_LINE_SOURCE; file_out: EL_PLAIN_TEXT_FILE
		do
			lio.put_path_field (Edit_add_check_attribute, file_path)
			lio.put_new_line
			create line_source.make (file_path)
			create lines.make (100)
			from line_source.start until line_source.after loop
				line := line_source.item
				trim_line := line.stripped
				if trim_line.starts_with (Lang_equals)
					and then not trim_line.has_substring ("check") and then not trim_line.ends_with (EN)
				then
					lines.extend (line + "; check = false")
				else
					lines.extend (line)
				end
				line_source.forth
			end
			line_source.close

			create file_out.make_open_write (file_path)
			file_out.set_encoding_from_other (line_source)
			file_out.put_lines (lines)
			file_out.close
		end

	do_with_file (file_path: EL_FILE_PATH)
		do
			if edit ~ Edit_add_check_attribute then
				add_check_attribute (file_path)
			end
		end

	pyxis_file_path_list: like OS.file_list
		do
			Result := OS.file_list (source_tree_path, "*.pyx")
		end

feature {NONE} -- Internal attributes

	edit: STRING

	query: STRING

	source_tree_path: EL_DIR_PATH

feature {NONE} -- Constants

	Edit_add_check_attribute: STRING
		once
			Result := "add_check_attribute"
		end

	EN: ZSTRING
		once
			Result := "en"
		end

	Lang_equals: ZSTRING
		once
			Result := "lang = "
		end

end
