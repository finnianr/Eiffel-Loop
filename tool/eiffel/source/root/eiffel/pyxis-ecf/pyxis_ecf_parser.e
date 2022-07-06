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
	date: "2022-07-06 17:39:54 GMT (Wednesday 6th July 2022)"
	revision: "19"

class
	PYXIS_ECF_PARSER

inherit
	EL_PYXIS_PARSER
		redefine
			call_state_procedure, parse_line
		end

	EL_STRING_8_CONSTANTS

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

			if attached grouped_lines as grouped then
				if equal_index > 0 or else
					(attached {PLATFORM_FILE_RULE_ECF_LINES} grouped_lines
						and then line.occurrences ('"') = 2 and then line.has (';'))
				then
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
			equal_index: INTEGER
		do
			equal_index := line.index_of ('=', start_index)
			if equal_index > 0
				and then Name_value_table.has_key (last_tag)
				and then not first_name_matches (line, Name.name, equal_index, start_index)
				and then attached substituted (Name_value_table.found_item, line, start_index - 1) as l_line
			then
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

	substituted (line: NAME_VALUE_ECF_LINE; text: STRING; a_tab_count: INTEGER): detachable STRING
		do
			line.set_from_line (text, a_tab_count)
			if line.count = 1 then
				Result := line.first
			end
		end

feature {NONE} -- Factory

	new_platform_lines (line: STRING; indent_count: INTEGER): PLATFORM_ECF_LINES
		do
			create Result.make
			Result.set_from_line (line, indent_count)
		end

feature {NONE} -- Internal attributes

	grouped_lines: detachable GROUPED_ECF_LINES

feature {NONE} -- Constants

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
				[Name.system, create {SYSTEM_ECF_LINES}.make],
				[Name.platform_list, create {PLATFORM_FILE_RULE_ECF_LINES}.make]
			>>)
			across Result as table loop
				table.item.enable_truncation
			end
		end

	Name_value_table: EL_HASH_TABLE [NAME_VALUE_ECF_LINE, STRING]
		once
			create Result.make (<<
				[Name.variable, create {NAME_VALUE_ECF_LINE}.make (Name.variable)],
				[Name.cluster, create {NAME_LOCATION_ECF_LINE}.make (Name.cluster)],
				[Name.library, create {NAME_LOCATION_ECF_LINE}.make (Name.library)],
				[Name.precompile, create {NAME_LOCATION_ECF_LINE}.make (Name.precompile)]
			>>)
		end

end