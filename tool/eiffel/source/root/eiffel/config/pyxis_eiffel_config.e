note
	description: "Parse basic project information from Eiffel Pyxis configuration file. (Extension: **pecf**)"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-03 15:49:44 GMT (Friday 3rd March 2023)"
	revision: "1"

class
	PYXIS_EIFFEL_CONFIG

inherit
	EL_BUILDABLE_FROM_PYXIS
		redefine
			make_default
		end

	EL_MODULE_FILE

create
	make

feature {NONE} -- Initialization

	make (a_pecf_path: FILE_PATH)
		do
			make_default

			pecf_path.copy (a_pecf_path)
			source_text := File.plain_text (a_pecf_path)
			create line_intervals.make (source_text, '%N')
			build_from_string (partial_source_text)
		end

	make_default
		do
			Precursor
			create pecf_path
			create source_text.make_empty
			create executable_name.make_empty
			create system.make_default
		end

feature -- Access

	executable_name: STRING

	pecf_path: FILE_PATH

	system: SYSTEM_VERSION

feature {NONE} -- Implementation

	partial_source_text: STRING
		-- source_text up as far as end of version information
		local
			found: BOOLEAN; s: EL_STRING_8_ROUTINES
		do
			if attached line_intervals as list then
				list.go_i_th (version_element_index + 1)
--				Find end of version information
				from until found or list.after loop
					if attached list.item as item then
						item.adjust
						if item.count > 0 and then item [item.count] = ':' then
							found := s.is_identifier_boundary (item, 1, item.count - 1)
						end
					end
					if not found then
						list.forth
					end
				end
				if found then
					list.back
					Result := source_text.substring (1, list.item_end_index)
				else
					create Result.make_empty
				end
			end
		end

feature -- Element change

	set_version (a_version: EL_SOFTWARE_VERSION)
		local
			found: BOOLEAN; l_count, tab_count: INTEGER
			item, new_version: STRING; s: EL_STRING_8_ROUTINES
		do
			create item.make_empty
			system.set_version (a_version)

			if attached line_intervals as list then
				list.go_i_th (version_element_index + 1)
--				Find version information line
				from until found or list.after loop
					item := list.item
					if item.occurrences ('=') = 4
						and then across Version_parts as part all item.has_substring (part.item) end
					then
						found := True
					else
						list.forth
					end
				end
				if found then
					l_count := item.count
					item.prune_all_leading ('%T')
					tab_count := l_count - item.count
					new_version := s.n_character_string ('%T', tab_count) + a_version.pyxis_attributes
					source_text.replace_substring (new_version, list.item_start_index, list.item_end_index)
					File.write_text (pecf_path, source_text)
					line_intervals.wipe_out
					line_intervals.fill (source_text, '%N', 0)
				end
			end
		end

feature {NONE} -- Implementation

	version_element_index: INTEGER
		do
			if attached line_intervals as list then
				from list.start until Result > 0 or list.after loop
					if list.item_has_substring (Version_element)
						and then source_text [list.item_end_index] = ':'
					then
						Result := list.index
					else
						list.forth
					end
				end
			end
		end

feature {NONE} -- Build from XML

	building_action_table: EL_PROCEDURE_TABLE [STRING]
			--
		do
			create Result.make (<<
				["target/version", agent do set_next_context (system) end],
				["@name", agent do executable_name.share (node) end]
			>>)
		end

feature {NONE} -- Internal attributes

	line_intervals: EL_SPLIT_STRING_8_LIST

	source_text: STRING

feature {NONE} -- Constants

	Version_parts: EL_STRING_8_LIST
		once
			Result := "major, minor, release, build"
		end

	Root_node_name: STRING = "system"

	Version_element: STRING = "version:"

end