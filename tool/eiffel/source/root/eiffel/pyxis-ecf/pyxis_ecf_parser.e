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
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-14 8:48:07 GMT (Monday 14th April 2025)"
	revision: "35"

class
	PYXIS_ECF_PARSER

inherit
	EL_PYXIS_PARSER
		redefine
			call_state_procedure, make, parse_line
		end

	PYXIS_ECF_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make (a_scanner: like scanner)
			--
		do
			Precursor (a_scanner)
			create grouped_lines_stack.make (3)
		end

feature {NONE} -- Implemenatation

	call_state_procedure (a_line: STRING)
		local
			equal_index: INTEGER; line: EL_PYXIS_LINE; sg: EL_STRING_GENERAL_ROUTINES
		do
			line := to_pyxis_line (a_line)
			equal_index := line.index_of_equals

			if attached c_platform as platform then
				-- Add platform condition to externals group and unindent
				if a_line /= line and then line.indent_count = c_platform_indent and line.is_element then
					-- Exit C compile group of lines
					c_platform := Void; c_platform_indent := 0
					call_state_procedure (line)

				elseif equal_index > 0 and Name.C_attributes.there_exists (agent line.first_name_matches (?, equal_index)) then
					line.tab_left
					Precursor (line)
					Platform_condition_lines.set (c_platform, line.indent_count)
					across Platform_condition_lines as ln loop
						Precursor (ln.item)
					end
				else
					if a_line /= line and then line.indent_count > 0 then
						line.tab_left
					end
					Precursor (line)
				end

			elseif equal_index > 0 and then is_condition_context (line)
				and then not line.first_name_matches (Name.name, equal_index)
				and then attached Condition_lines as group
			then
				group.set_indent (line.indent_count)
				group.set_from_line (line)
				across group as ln loop
					Precursor (ln.item)
				end

			elseif grouped_lines_stack.count > 0 and then attached grouped_lines_stack.item as grouped then
				if grouped.is_related_line (line, equal_index) then
					Precursor (line)

				elseif equal_index > 0 and then attached previous_grouped_lines as previous
					and then line.indent_count = previous.tab_count + 1
				then
					grouped_lines_stack.remove
					call_state_procedure (line)

				elseif equal_index > 0 or else grouped.is_platform_rule (line) then
					grouped.set_from_line (a_line) -- use argument `a_line' here
					if grouped.count > 0 then
						across grouped as ln loop
							Precursor (ln.item)
						end
						if attached {SYSTEM_ECF_LINES} grouped then
							group_exit
						end
					end
				else
					if line.is_element then
						group_exit
					end
					Precursor (line)
				end
			elseif attached line.element_name as tag and then Name.externals_set.has (tag) then
				c_platform := sg.super_8 (tag).substring_to ('_')
				c_platform_indent := line.indent_count
			else
				Precursor (line)
			end
		end

	group_exit
		do
			if grouped_lines_stack.count > 0 then
				grouped_lines_stack.item.exit
				grouped_lines_stack.remove
			end
		end

	parse_line (line: EL_PYXIS_LINE)
		local
			equal_index: INTEGER
		do
			equal_index := line.index_of_equals
			if equal_index > 0
				and then attached tag_name as tag and then Name_value_table.has_key (tag)
				and then not Name_value_table.found_item.is_first_name_reserved (line, equal_index)
				and then attached substituted (Name_value_table.found_item, line) as text
			then
				line.replace (text)
				Precursor (line)

			elseif attached line.element_name as tag
				and then attached Expansion_table as table
				and then table.has_key (tag) and then attached table.found_item as group
				and then attached group.tag_name as ecf_tag_name
			then
				line.rename_element (ecf_tag_name)
				group.reset; group.set_indent (line.indent_count)
				grouped_lines_stack.put (group)
				Precursor (line)
			else
				Precursor (line)
			end
		end

	substituted (line: NAME_VALUE_ECF_LINE; text: STRING): detachable STRING
		do
			line.set_from_line (text)
			if line.count = 1 then
				Result := line.text
			end
		end

feature {NONE} -- Implementation

	is_condition_context (line: EL_PYXIS_LINE): BOOLEAN
		do
			if attached tag_name as tag and then tag ~ Name.condition then
				Result := True

			elseif attached element_stack as stack and then stack.count > 0 then
				Result := element_stack.count = line.indent_count and then stack.item ~ Name.condition
			end
		end

	new_name_value_list: ARRAY [NAME_VALUE_ECF_LINE]
		do
			Result := <<
				create {NAME_VALUE_ECF_LINE}.make (Name.custom, << Name.excluded_value >>),
				create {NAME_VALUE_ECF_LINE}.make (Name.variable, No_extra),
				create {NAME_LOCATION_ECF_LINE}.make (Name.cluster, << Name.readonly, Name.recursive >>),
				create {NAME_LOCATION_ECF_LINE}.make (Name.library, << Name.readonly >>),
				create {NAME_LOCATION_ECF_LINE}.make (Name.precompile, No_extra),
				create {OLD_NAME_NEW_NAME_ECF_LINE}.make (Name.mapping, No_extra),
				create {OLD_NAME_NEW_NAME_ECF_LINE}.make (Name.renaming, No_extra)
			>>
		end

	previous_grouped_lines: detachable GROUPED_ECF_LINES
		-- item underneath `grouped_lines_stack.item' or `Void' if none
		do
			if attached {LIST [GROUPED_ECF_LINES]} grouped_lines_stack as stack and then stack.count > 1 then
				Result := stack [stack.count - 1]
			end
		end

feature {NONE} -- Internal attributes

	c_platform: detachable STRING
		-- C externals platform

	c_platform_indent: INTEGER
		-- C externals group tag tab count

	grouped_lines_stack: ARRAYED_STACK [GROUPED_ECF_LINES]

feature {NONE} -- Constants

	Condition_lines: CONDITION_ECF_LINE
		once
			create Result.make
		end

	No_extra: ARRAY [STRING]
		once
			create Result.make_empty
		end

	Expansion_table: EL_HASH_TABLE [GROUPED_ECF_LINES, STRING]
		once
			create Result.make_assignments (<<
				[Name.cluster_tree,			create {CLUSTER_TREE_ECF_LINES}.make],
				[Name.debugging,				create {DEBUG_OPTION_ECF_LINES}.make],
				[Name.settings,				create {SETTING_ECF_LINES}.make],
				[Name.libraries,				create {LIBRARIES_ECF_LINES}.make],
				[Name.platform_list,			create {PLATFORM_FILE_RULE_ECF_LINES}.make],
				[Name.renaming_map,			create {RENAMING_MAP_ECF_LINES}.make],
				[Name.sub_clusters,			create {SUB_CLUSTERS_ECF_LINES}.make],
				[Name.system,					create {SYSTEM_ECF_LINES}.make],
				[Name.writeable_libraries, create {WRITEABLE_LIBRARIES_ECF_LINES}.make],
				[Name.warnings,				create {WARNING_OPTION_ECF_LINES}.make]
			>>)
			across Result as table loop
				table.item.enable_truncation
			end
		end

	Name_value_table: EL_HASH_TABLE [NAME_VALUE_ECF_LINE, STRING]
		once
			if attached new_name_value_list as name_value_list then
				create Result.make (name_value_list.count)
				across name_value_list as list loop
					Result.extend (list.item, list.item.tag_name)
				end
			end
		end

	Platform_condition_lines: PLATFORM_CONDITION_ECF_LINES
		once
			create Result.make
		end

end