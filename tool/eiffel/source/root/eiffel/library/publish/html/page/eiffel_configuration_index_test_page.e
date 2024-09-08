note
	description: "Version of ${EIFFEL_CONFIGURATION_INDEX_PAGE} for debugging"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-08 15:20:42 GMT (Sunday 8th September 2024)"
	revision: "6"

class
	EIFFEL_CONFIGURATION_INDEX_TEST_PAGE

inherit
	EIFFEL_CONFIGURATION_INDEX_PAGE
		redefine
			sink_content
		end

create
	make

feature {NONE} -- Implementation

	sink_content (crc: like crc_generator)
		local
			same_count: BOOLEAN; e_class: EIFFEL_CLASS; mismatch_found: BOOLEAN
			checksum_list: EL_ARRAYED_LIST [NATURAL]
		do
			crc.add_file (content_template)
			crc.add_string (eiffel_config.name)
			across eiffel_config.description_lines as line loop
				crc.add_string (line.item)
			end
--			lio.put_natural_field (eiffel_config.html_index_path.base, crc.checksum)
--			lio.put_new_line
			if attached eiffel_config.sorted_class_list as class_list then
				if Checksum_list_table.has_key (eiffel_config.html_index_path) then
					checksum_list := Checksum_list_table.found_list
					if class_list.count + 1 = checksum_list.count then
						same_count := True
						if checksum_list [1] /= crc.checksum then
							if not mismatch_found then
								lio.put_path_field (Checksum_differs, eiffel_config.html_index_path)
								lio.put_new_line
								mismatch_found := True
							end
						end
					else
						checksum_list.wipe_out
						checksum_list.extend (crc.checksum)
					end
				else
					create checksum_list.make (class_list.count)
					checksum_list.extend (crc.checksum)
					Checksum_list_table.extend_area (checksum_list.area, eiffel_config.html_index_path)
				end
				across class_list as list loop
					e_class := list.item
					crc.add_natural (e_class.current_digest)
					if same_count then
						if checksum_list [list.cursor_index + 1] /= crc.checksum then
							if not mismatch_found then
								lio.put_labeled_string (Checksum_differs, e_class.name)
								lio.put_new_line
								mismatch_found := True
							end
						end
					else
						checksum_list.extend (crc.checksum)
					end
				end
			end
		end

feature {NONE} -- Constants

	Checksum_differs: STRING = "Checksum differs"

	Checksum_list_table: EL_GROUPED_LIST_TABLE [NATURAL, FILE_PATH]
		once
			create Result.make (200)
		end

end