note
	description: "Check for invalid class references in note links"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-06-04 7:53:28 GMT (Tuesday 4th June 2024)"
	revision: "17"

class
	REPOSITORY_NOTE_LINK_CHECKER

inherit
	REPOSITORY_PUBLISHER
		redefine
			execute
		end

	EL_MODULE_FILE_SYSTEM

	EL_APPLICATION_COMMAND

	SHARED_INVALID_CLASSNAMES

create
	make

feature -- Access

	Description: STRING = "Checks for invalid class references in repository note links"

feature -- Basic operations

	execute
		local
			file_out: EL_PLAIN_TEXT_FILE
		do
			lio.put_new_line
			lio.put_line ("Checking ${CLASS_NAME} links")
			across ecf_list as tree loop
				lio.put_character ('.')
				across tree.directory_list as directory loop
					across directory.class_list as eiffel_class loop
						eiffel_class.check_class_references
					end
				end
			end
			lio.put_new_line
			if Invalid_source_name_table.count > 0 then
				lio.put_labeled_substitution ("Total", "%S classes contain invalid references", [Invalid_source_name_table.count])
				lio.put_new_line
				lio.put_path_field ("See %S", config.invalid_names_output_path)
				lio.put_new_line
				create file_out.make_open_write (config.invalid_names_output_path)
				file_out.byte_order_mark.enable

				across Invalid_source_name_table as invalid_source_name loop
					file_out.put_line ("class " + @ invalid_source_name.key.base_name.as_upper)
					file_out.put_line (Source_file_comment + @ invalid_source_name.key.to_unix)
					file_out.put_line (Invalid_references_comment)
					across invalid_source_name as class_name loop
						file_out.put_line (Source_reference #$ [class_name])
					end
					file_out.put_new_line
				end
				file_out.close
			else
				lio.put_line ("All ${XXX} class references OK")
				if config.invalid_names_output_path.exists then
					File_system.remove_file (config.invalid_names_output_path)
				end
			end
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
			Result := "%T${%S}"
		end

end
