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
	date: "2022-07-05 15:34:02 GMT (Tuesday 5th July 2022)"
	revision: "17"

class
	PYXIS_ECF_PARSER

inherit
	EL_PYXIS_PARSER
		redefine
			call_state_procedure, parse_line
		end

	EL_STRING_8_CONSTANTS

	PYXIS_ECF_TEMPLATES

create
	make

feature {NONE} -- Template Expansion

	expanded_option_settings (nvp: EL_NAME_VALUE_PAIR [STRING]): STRING
		-- option/debug OR option/warning
		local
			boolean: STRING
		do
			boolean := Boolean_value [nvp.value /~ Name.disabled]
			if attached Option_setting_template as template then
				template.put (Var.element, last_tag)
				template.put (Var.name, nvp.name)
				template.put (Var.value, boolean)
				Result := template.substituted
			end
		end

	expanded_platform (nvp: EL_NAME_VALUE_PAIR [STRING]): STRING
		do
			if attached Platform_template as template then
				template.put (Var.value, nvp.value)
				Result := template.substituted
			end
		end

	expanded_sub_cluster (nvp: EL_NAME_VALUE_PAIR [STRING]): STRING
		local
			s: EL_STRING_8_ROUTINES
		do
			if attached Sub_clusters_template as template then
				template.put (Var.name, nvp.name)
				s.remove_double_quote (nvp.value)
				template.put (Var.value, nvp.value)
				Result := template.substituted
			end
		end

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
				grouped_lines := Void

			elseif attached grouped_lines as grouped then
				if equal_index > 0 then
					grouped.set_from_line (line, indent_count - 1)
					across grouped as ln loop
						Precursor (ln.item)
					end
				else
					if end_index > 0 and then line [end_index] = ':' then
						grouped_lines := Void
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
			if equal_index > 0 and then first_name_matches (line, Name.configuration_ns, equal_index, start_index) then
				-- expand line
				nvp_end := line.index_of (';', start_index)
				if nvp_end = 0 then
					nvp_end := end_index
				else
					nvp_end := nvp_end - 1
				end
				configuration_name_value := line.substring (start_index, nvp_end)

				eiffel_url := Eiffel_configuration + assignment.value (configuration_name_value)
				xml_ns := XMS_NS_template #$ [eiffel_url, eiffel_url, eiffel_url]
				line.replace_substring (xml_ns, start_index, nvp_end)

				Precursor (line, start_index, end_index + (xml_ns.count - configuration_name_value.count))

			elseif equal_index > 0
				and then Template_table.has_key (last_tag)
				and then not first_name_matches (line, Name.name, equal_index, start_index)
				and then attached Empty_group.shared_name_value_list (line) as nvp_list
				and then nvp_list.count = 1
				and then attached substituted (Template_table.found_item, nvp_list.first) as l_line
			then
				l_line.prepend (s.n_character_string ('%T', start_index - 1))
				Precursor (l_line, start_index, l_line.count)

			elseif attached element (line, start_index, end_index) as tag and then Original_tag_table.has_key (tag) then
				line.replace_substring (Original_tag_table.found_item, start_index, end_index - 1)
				grouped_lines := new_group_lines (tag)
				Precursor (line, start_index, end_index - (tag.count - Original_tag_table.found_item.count))
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

	new_group_lines (tag: STRING): GROUPED_ECF_LINES
		do
			if attached Expansion_table as table and then table.has_key (tag) then
				-- Truncated first line
				table.found_item.set_target (Current)
				if Library_tags.has (tag) then
					create {LIBRARIES_ECF_LINES} Result.make (table.found_item)
				else
					create Result.make (table.found_item)
				end
				Result.enable_truncation
			else
				Result := Empty_group
			end
		ensure
			not_empty: Result /= Empty_group
		end

	new_platform_lines (line: STRING; indent_count: INTEGER): GROUPED_ECF_LINES
		do
			create Result.make (agent expanded_platform)
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

	Empty_group: GROUPED_ECF_LINES
		once
			create Result.make_empty
		end

	Expansion_table: EL_HASH_TABLE [FUNCTION [EL_NAME_VALUE_PAIR [STRING], STRING], STRING]
		once
			create Result.make (<<
				[Name.settings, agent substituted (Setting_template, ?)],
				[Name.libraries, agent substituted (Library_template, ?)],
				[Name.writeable_libraries, agent substituted (Writeable_library_template, ?)],
				[Name.debugging, agent expanded_option_settings],
				[Name.warnings, agent expanded_option_settings],
				[Name.cluster_tree, agent substituted (Cluster_tree_template, ?)],
				[Name.sub_clusters, agent expanded_sub_cluster]
			>>)
		end

	Library_tags: ARRAY [STRING]
		once
			Result := << Name.libraries, Name.writeable_libraries >>
			Result.compare_objects
		end

	Name: TUPLE [
		cluster, cluster_tree, condition, configuration_ns, debugging, disabled,
		library, libraries, name,
		platform, platform_list, precompile, settings, sub_clusters,
		variable, warnings, writeable_libraries: STRING
	]
		once
			create Result
			Tuple.fill (Result,
				"cluster, cluster_tree, condition, configuration_ns, debugging, disabled, %
				%library, libraries, name, %
				%platform, platform_list, precompile, settings, sub_clusters, %
				%variable, warnings, writeable_libraries"
			)
		ensure
			aligned_correctly: Result.writeable_libraries ~ "writeable_libraries"
		end

	Original_tag_table: EL_HASH_TABLE [STRING, STRING]
		-- map group element to original element
		-- eg. libraries -> library
		once
			create Result.make (<<
				[Name.settings, "setting"],
				[Name.libraries, "library"],
				[Name.writeable_libraries, "library"],
				[Name.debugging, "debug"],
				[Name.cluster_tree, "cluster"],
				[Name.sub_clusters, "cluster"],
				[Name.warnings, "warning"]
			>>)
		end

	Platform_name: EL_BOOLEAN_INDEXABLE [STRING]
		once
			create Result.make ("windows", "unix")
		end

	Template_table: EL_HASH_TABLE [ EL_TEMPLATE [STRING], STRING]
		once
			create Result.make (<<
				[Name.variable, Name_value_template],
				[Name.cluster, Name_location_template],
				[Name.library, Name_location_template],
				[Name.precompile, Name_location_template]
			>>)
		end

end