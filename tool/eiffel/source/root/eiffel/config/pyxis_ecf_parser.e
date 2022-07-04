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
	date: "2022-07-04 14:49:37 GMT (Monday 4th July 2022)"
	revision: "16"

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
			line.right_adjust
			indent_count := cursor_8 (line).leading_occurrences ('%T')
			end_index := line.count - cursor_8 (line).trailing_white_count
			equal_index := line.index_of ('=', indent_count + 1)

			if platform_indent > 0 and then line.occurrences ('"') = 2 and then line.has (';') then
				across file_rule_lines (line) as list loop
					Precursor (list.item)
				end
				platform_indent := 0

			elseif indent_count > 0 and then line.ends_with (platform_list) then
				platform_indent := indent_count
				 -- This might be an exit to cluster_tree group
				grouped_lines := Void

			elseif attached grouped_lines as grouped then
				if equal_index > 0 then
					grouped.set_from_line (line)
					across grouped as ln loop
						Precursor (ln.item)
					end
				else
					if end_index > 0 and then line [end_index] = ':' then
						grouped_lines := Void
					end
					Precursor (line)
				end

			elseif equal_index > 0 and then attached tag_name as tag and then Grouped_element_table.has_key (tag) then
				tag_name := Grouped_element_table.found_item

				if attached new_group_lines (tag, line, indent_count - 1) as new_lines then
					across new_lines as list loop
						Precursor (list.item)
					end
					grouped_lines := new_lines
				end

			elseif equal_index > 0 and then last_tag ~ Name.condition
				and then first_name (line, equal_index, indent_count) ~ Name.platform
			then
				across new_group_lines (Name.platform, line, indent_count) as ln loop
					Precursor (ln.item)
				end

			else
				Precursor (line)
			end
		end

	first_name (line: STRING; equal_index, indent_count: INTEGER): STRING
		do
			Result := Buffer_8.copied_substring (line, indent_count + 1, equal_index - 1)
			Result.right_adjust
		end

	new_group_lines (tag, line: STRING; indent_count: INTEGER): GROUPED_ECF_LINES
		do
			if attached Expansion_table as table and then table.has_key (tag) then
				-- Truncated first line
				table.found_item.set_target (Current)
				if Library_tags.has (tag) then
					create {LIBRARIES_ECF_LINES} Result.make_truncated (table.found_item, indent_count, line)
				else
					create Result.make_truncated (table.found_item, indent_count, line)
				end

			elseif tag ~ Name.platform then
				create Result.make (agent expanded_platform, indent_count, line)
			end
		end

	parse_line (line: STRING; start_index, end_index: INTEGER)
		local
			nvp_end, equal_index: INTEGER; assignment: EL_ASSIGNMENT_ROUTINES
			xml_ns: STRING; eiffel_url, configuration_name_value: ZSTRING
			s: EL_STRING_8_ROUTINES
		do
			equal_index := line.index_of ('=', start_index)
			if equal_index > 0 and then (equal_index - start_index) >= Name.configuration_ns.count
				and then s.occurs_at (line, Name.configuration_ns, start_index)
			then
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
			else
				Precursor (line, start_index, end_index)
			end
		end

	file_rule_lines (line: STRING): EL_STRING_8_LIST
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

	last_tag: STRING
		do
			if attached tag_name as tag then
				Result := tag
			else
				Result := Empty_string_8
			end
		end

	unix: STRING
		do
			Result := Platform_name [True]
		end

	substituted (template: EL_TEMPLATE [STRING]; nvp: EL_NAME_VALUE_PAIR [STRING]): STRING
		do
			template.put (Var.name, nvp.name)
			template.put (Var.value, nvp.value)
			Result := template.substituted
		end

feature {NONE} -- Internal attributes

	platform_indent: INTEGER

	grouped_lines: detachable GROUPED_ECF_LINES

feature {NONE} -- Constants

	Boolean_value: EL_BOOLEAN_INDEXABLE [STRING]
		once
			create Result.make ("false", "true")
		end

	Eiffel_configuration: ZSTRING
		once
			Result := "http://www.eiffel.com/developers/xml/configuration-"
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

	Name: TUPLE [
		cluster_tree, condition, configuration_ns, debugging, disabled, libraries,
		platform, settings, sub_clusters, warnings, writeable_libraries: STRING
	]
		once
			create Result
			Tuple.fill (Result,
				"cluster_tree, condition, configuration_ns, debugging, disabled, libraries, %
				%platform, settings, sub_clusters, warnings, writeable_libraries"
			)
		ensure
			aligned_correctly: Result.writeable_libraries ~ "writeable_libraries"
		end

	Grouped_element_table: EL_HASH_TABLE [STRING, STRING]
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

	Library_tags: ARRAY [STRING]
		once
			Result := << Name.libraries, Name.writeable_libraries >>
			Result.compare_objects
		end

	Platform_name: EL_BOOLEAN_INDEXABLE [STRING]
		once
			create Result.make ("windows", "unix")
		end

	Platform_list: STRING = "platform_list:"

end