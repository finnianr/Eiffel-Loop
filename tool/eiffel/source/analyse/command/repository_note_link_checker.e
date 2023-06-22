note
	description: "Check for invalid class references in note links"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-06-21 14:17:37 GMT (Wednesday 21st June 2023)"
	revision: "13"

class
	REPOSITORY_NOTE_LINK_CHECKER

inherit
	REPOSITORY_PUBLISHER
		redefine
			execute, building_action_table, make_default
		end

	EL_MODULE_FILE_SYSTEM

	EL_APPLICATION_COMMAND

	SHARED_INVALID_CLASSNAMES

create
	make

feature {NONE} -- Initialization

	make_default
		do
			create invalid_names_output_path
			Precursor
		end

feature -- Access

	Description: STRING = "Checks for invalid class references in repository note links"

	invalid_names_output_path: FILE_PATH

feature -- Basic operations

	execute
		local
			file_out: EL_PLAIN_TEXT_FILE
		do
			lio.put_new_line
			lio.put_line ("Checking $source links")
			across ecf_list as tree loop
				lio.put_character ('.')
				across tree.item.directory_list as directory loop
					across directory.item.class_list as eiffel_class loop
						eiffel_class.item.check_class_references
					end
				end
			end
			lio.put_new_line
			if Invalid_source_name_table.count > 0 then
				lio.put_labeled_substitution ("Total", "%S classes contain invalid references", [Invalid_source_name_table.count])
				lio.put_new_line
				lio.put_path_field ("See %S", invalid_names_output_path)
				lio.put_new_line
				create file_out.make_open_write (invalid_names_output_path)
				file_out.byte_order_mark.enable

				across Invalid_source_name_table as table loop
					file_out.put_line ("class " + table.key.base_name.as_upper)
					file_out.put_line (Source_file_comment + table.key.to_unix)
					file_out.put_line (Invalid_references_comment)
					across table.item as class_name loop
						file_out.put_line (Source_reference #$ [class_name.item])
					end
					file_out.put_new_line
				end
				file_out.close
			else
				lio.put_line ("All [$source XXX] class references OK")
				if invalid_names_output_path.exists then
					File_system.remove_file (invalid_names_output_path)
				end
			end
		end

feature {NONE} -- Build from Pyxis

	building_action_table: EL_PROCEDURE_TABLE [STRING]
		do
			Result := Precursor +
				["@invalid_names_output_path", agent do invalid_names_output_path := node.to_expanded_file_path end]
		end

feature {NONE} -- Constants

	Invalid_references_comment: ZSTRING
		once
			Result := "-- Invalid references:"
		end

	Source_file_comment: ZSTRING
		once
			Result := "-- Source: "
		end

	Source_reference: ZSTRING
		once
			Result := "%T[$source %S]"
		end

end