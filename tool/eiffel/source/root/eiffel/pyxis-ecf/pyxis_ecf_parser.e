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
	date: "2022-07-11 11:27:42 GMT (Monday 11th July 2022)"
	revision: "22"

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

	call_state_procedure (a_line: STRING)
		local
			equal_index: INTEGER; line: like Once_line
		do
			line := shared_pyxis_line (a_line)
			equal_index := line.index_of_equals

			if equal_index > 0 and then last_tag ~ Name.condition
				and then line.first_name_matches (Name.platform, equal_index)
				and then attached Platform_lines as group
			then
				group.set_indent (line.indent_count)
				group.set_from_line (line)
				across group as ln loop
					Precursor (ln.item)
				end

			elseif attached grouped_lines as grouped then
				if grouped.is_related_line (line, equal_index) then
					Precursor (line)
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

			else
				Precursor (line)
			end
		end

	group_exit
		do
			if attached grouped_lines as group then
				group.exit
			end
			grouped_lines := Void
		end

	parse_line (line: EL_PYXIS_LINE)
		local
			equal_index: INTEGER
		do
			equal_index := line.index_of_equals
			if equal_index > 0
				and then Name_value_table.has_key (last_tag)
				and then not line.first_name_matches (Name.name, equal_index)
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
				grouped_lines := group
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

	last_tag: STRING
		do
			if attached tag_name as tag then
				Result := tag
			else
				Result := Empty_string_8
			end
		end

feature {NONE} -- Internal attributes

	grouped_lines: detachable GROUPED_ECF_LINES

feature {NONE} -- Constants

	Expansion_table: EL_HASH_TABLE [GROUPED_ECF_LINES, STRING]
		once
			create Result.make (<<
				[Name.cluster_tree,			create {CLUSTER_TREE_ECF_LINES}.make],
				[Name.debugging,				create {DEBUG_OPTION_ECF_LINES}.make],
				[Name.settings,				create {SETTING_ECF_LINES}.make],
				[Name.libraries,				create {LIBRARIES_ECF_LINES}.make],
				[Name.platform_list,			create {PLATFORM_FILE_RULE_ECF_LINES}.make],
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
			create Result.make (<<
				[Name.custom,		create {NAME_VALUE_ECF_LINE}.make (Name.custom)],
				[Name.variable,	create {NAME_VALUE_ECF_LINE}.make (Name.variable)],
				[Name.cluster,		create {NAME_LOCATION_ECF_LINE}.make (Name.cluster)],
				[Name.library,		create {NAME_LOCATION_ECF_LINE}.make (Name.library)],
				[Name.precompile, create {NAME_LOCATION_ECF_LINE}.make (Name.precompile)],
				[Name.mapping,		create {OLD_NAME_NEW_NAME_ECF_LINE}.make (Name.mapping)],
				[Name.renaming,	create {OLD_NAME_NEW_NAME_ECF_LINE}.make (Name.renaming)]
			>>)
		end

	Platform_lines: PLATFORM_ECF_LINES
		once
			create Result.make
		end

end