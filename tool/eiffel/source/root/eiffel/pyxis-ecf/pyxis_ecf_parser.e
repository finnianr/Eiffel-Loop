note
	description: "Pyxis ECF parser"
	notes: "[
		**Expansions**
		
		**1.** Schema and name space expansion
			configuration_ns = "1-16-00"
		
		**2.** Excluded directores file rule by platform
			platform_list:
				"imp_mswin; imp_unix"
				
		**3.** Abbreviated platform condition
			condition:
				platform = windows
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-07-06 15:56:56 GMT (Wednesday 6th July 2022)"
	revision: "18"

class
	PYXIS_ECF_PARSER

inherit
	EL_PYXIS_PARSER
		redefine
			call_state_procedure, parse_line
		end

	EL_STRING_8_CONSTANTS

	PYXIS_ECF_TEMPLATES

	PYXIS_ECF_CONSTANTS

create
	make

feature {NONE} -- Implemenatation

	call_state_procedure (line: STRING)
		local
			equal_index, indent_count, end_index: INTEGER
		do
			indent_count := cursor_8 (line).leading_occurrences ('%T')
			equal_index := line.index_of ('=', indent_count + 1)
			end_index := line.count - cursor_8 (line).trailing_white_count

			if platform_indent > 0 and then line.occurrences ('"') = 2 and then line.has (';') then
				across new_file_rule_lines (line) as list loop
					Precursor (list.item)
				end
				platform_indent := 0

			elseif indent_count > 0 and then attached element (line, indent_count + 1, end_index) as tag
				and then tag ~ Name.platform_list
			then
				platform_indent := indent_count
				 -- This might be an exit to cluster_tree group
				group_exit

			elseif attached grouped_lines as grouped then
				if equal_index > 0 then
					grouped.set_from_line (line, indent_count - 1)
					if grouped.count > 0 then
						across grouped as ln loop
							Precursor (ln.item)
						end
						if attached {SYSTEM_ECF_LINES} grouped then
							group_exit
						end
					end
				else
					if end_index > 0 and then line [end_index] = ':' then
						group_exit
					end
					Precursor (line)
				end

			elseif equal_index > 0 and then last_tag ~ Name.condition
				and then first_name_matches (line, Name.platform, equal_index, indent_count + 1)
			then
				across new_platform_lines (line, indent_count) as ln loop
					Precursor (ln.item)
				end

			else
				Precursor (line)
			end
		end

	element (line: STRING; start_index, end_index: INTEGER): detachable STRING
		-- name of element (tag) or Void if no element found
		do
			if end_index > 0 and then line [end_index] = ':' then
				Result := Buffer_8.copied_substring (line, start_index, end_index - 1)
			end
		end

	group_exit
		do
			if attached grouped_lines as group then
				group.exit
			end
			grouped_lines := Void
		end

	first_name_matches (line, a_name: STRING; equal_index, start_index: INTEGER): BOOLEAN
		local
			i: INTEGER
		do
			from i := equal_index - 1 until i = (start_index - 1) or else line [i].is_alpha_numeric loop
				i := i - 1
			end
			if i >= start_index then
				Result := a_name.same_characters (line, start_index, i, 1)
			end
		end

	last_tag: STRING
		do
			if attached tag_name as tag then
				Result := tag
			else
				Result := Empty_string_8
			end
		end

	parse_line (line: STRING; start_index, end_index: INTEGER)
		local
			nvp_end, equal_index: INTEGER; assignment: EL_ASSIGNMENT_ROUTINES
			xml_ns: STRING; eiffel_url, configuration_name_value: ZSTRING
			s: EL_STRING_8_ROUTINES
		do
			equal_index := line.index_of ('=', start_index)
			if equal_index > 0
				and then Template_table.has_key (last_tag)
				and then not first_name_matches (line, Name.name, equal_index, start_index)
				and then attached Empty_group.shared_name_value_list (line) as nvp_list
				and then nvp_list.count = 1
				and then attached substituted (Template_table.found_item, nvp_list.first) as l_line
			then
				l_line.prepend (s.n_character_string ('%T', start_index - 1))
				Precursor (l_line, start_index, l_line.count)

			elseif attached element (line, start_index, end_index) as tag
				and then attached Expansion_table as table
				and then table.has_key (tag)
				and then attached table.found_item.tag_name as ecf_tag_name
			then
				line.replace_substring (ecf_tag_name, start_index, end_index - 1)
				grouped_lines := table.found_item
				table.found_item.reset
				Precursor (line, start_index, end_index - (tag.count - ecf_tag_name.count))
			else
				Precursor (line, start_index, end_index)
			end
		end

	substituted (template: EL_TEMPLATE [STRING]; nvp: EL_NAME_VALUE_PAIR [STRING]): STRING
		do
			template.put (Var.name, nvp.name)
			template.put (Var.value, nvp.value)
			Result := template.substituted
		end

	unix: STRING
		do
			Result := Platform_name [True]
		end

feature {NONE} -- Factory

	new_file_rule_lines (line: STRING): EL_STRING_8_LIST
		--	Expand:
		--		platform_list = "imp_mswin, imp_unix"
		--	as pair of platform/exclude file rules
		local
			q_start, q_end: INTEGER; platform: STRING
			is_unix: BOOLEAN
		do
			create Result.make (15)
			q_start := line.index_of ('"', 1) + 1
			if q_start > platform_indent then
				q_end := line.last_index_of ('"', line.count) - 1
				across line.substring (q_start, q_end).split (';') as list loop
					platform := list.item
					platform.left_adjust
					is_unix := platform.has_substring (unix)
					if attached File_rule_template as template then
						template.put (Var.directory, platform)
						template.put (Var.value, Platform_name [not is_unix])
						across template.substituted.split ('%N') as split loop
							Result.extend (split.item)
						end
					end
				end
				Result.indent (platform_indent)
			end
		end

	new_platform_lines (line: STRING; indent_count: INTEGER): PLATFORM_ECF_LINES
		do
			create Result.make
			Result.set_from_line (line, indent_count)
		end

feature {NONE} -- Internal attributes

	grouped_lines: detachable GROUPED_ECF_LINES

	platform_indent: INTEGER

feature {NONE} -- Constants

	Boolean_value: EL_BOOLEAN_INDEXABLE [STRING]
		once
			create Result.make ("false", "true")
		end

	Eiffel_configuration: ZSTRING
		once
			Result := "http://www.eiffel.com/developers/xml/configuration-"
		end

	Empty_group: SETTING_ECF_LINES
		once
			create Result.make
		end

	Expansion_table: EL_HASH_TABLE [GROUPED_ECF_LINES, STRING]
		once
			create Result.make (<<
				[Name.settings, create {SETTING_ECF_LINES}.make],
				[Name.libraries, create {LIBRARIES_ECF_LINES}.make],
				[Name.writeable_libraries, create {WRITEABLE_LIBRARIES_ECF_LINES}.make],
				[Name.debugging, create {DEBUG_OPTION_ECF_LINES}.make],
				[Name.warnings, create {WARNING_OPTION_ECF_LINES}.make],
				[Name.cluster_tree, create {CLUSTER_TREE_ECF_LINES}.make],
				[Name.sub_clusters, create {SUB_CLUSTERS_ECF_LINES}.make],
				[Name.system, create {SYSTEM_ECF_LINES}.make]
			>>)
			across Result as table loop
				table.item.enable_truncation
			end
		end

	Library_tags: ARRAY [STRING]
		once
			Result := << Name.libraries, Name.writeable_libraries >>
			Result.compare_objects
		end

	Platform_name: EL_BOOLEAN_INDEXABLE [STRING]
		once
			create Result.make ("windows", "unix")
		end

	Template_table: EL_HASH_TABLE [EL_TEMPLATE [STRING], STRING]
		once
			create Result.make (<<
				[Name.variable, Name_value_template],
				[Name.cluster, Name_location_template],
				[Name.library, Name_location_template],
				[Name.precompile, Name_location_template]
			>>)
		end

end