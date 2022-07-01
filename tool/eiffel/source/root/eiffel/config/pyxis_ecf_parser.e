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
	date: "2022-07-01 15:00:27 GMT (Friday 1st July 2022)"
	revision: "12"

class
	PYXIS_ECF_PARSER

inherit
	EL_PYXIS_PARSER
		redefine
			call_state_procedure, parse_line
		end

	EL_MODULE_TUPLE

create
	make

feature {NONE} -- State procedures

	call_state_procedure (line: STRING)
		local
			equal_index, platform_index, indent_count, end_index: INTEGER
			platform_value, value_line: STRING; s_8: EL_STRING_8_ROUTINES
		do
			line.right_adjust
			indent_count := cursor_8 (line).leading_occurrences ('%T')
			end_index := line.count - cursor_8 (line).trailing_white_count

			if platform_indent.to_boolean and then line.occurrences ('"') = 2 and then line.has (';') then
				across file_rule_lines (line) as list loop
					Precursor (list.item)
				end
				platform_indent := 0

			elseif setting_indent.to_boolean then
				if end_index.to_boolean and then line [end_index] = ':' then
					setting_indent := 0
					Precursor (line)

				elseif line.has ('=') then
					across setting_name_value_list (line, False) as list loop
						Precursor (list.item)
					end
				else
					Precursor (line)
				end

			elseif indent_count.to_boolean and then line.ends_with (Platform_list) then
				platform_indent := indent_count

			elseif is_attribute (line, Name.settings) then
				setting_indent := indent_count - 1
				tag_name.remove_tail (1)
				across setting_name_value_list (line, True) as list loop
					Precursor (list.item)
				end

			else
				equal_index := line.index_of ('=', 1)
				if equal_index > 0 and tag_name ~ Name.condition then
					platform_index := line.substring_index (Name.platform, 1)
					if platform_index > 1 and then line [platform_index - 1] = '%T'
						and then platform_index + Name.platform.count <= equal_index
						and then line [platform_index + Name.platform.count] /= ':'
					then
--						Expand:
--							platform = windows
--						as:
--							platform:
--								value = windows
						platform_value := line.substring (equal_index + 1, line.count)
						platform_value.adjust
						line.replace_substring (s_8.character_string (':'), platform_index + Name.platform.count, line.count)
						Precursor (line)
						create value_line.make_filled ('%T', platform_index)
						value_line.append (once "value = ")
						value_line.append (platform_value)
						Precursor (value_line)
					else
						Precursor (line)
					end
				else
					Precursor (line)
				end
			end
		end

	is_attribute (line, a_name: STRING): BOOLEAN
		do
			Result := line.has ('=') and then attached tag_name as tag and then tag ~ a_name
		end

	parse_line (line: STRING; start_index, end_index: INTEGER)
		local
			nvp_end, equal_index: INTEGER; assignment: EL_ASSIGNMENT_ROUTINES
			xml_ns: STRING; eiffel_url, configuration_name_value: ZSTRING
			s: EL_STRING_8_ROUTINES
		do
			equal_index := line.index_of ('=', start_index)
			if equal_index.to_boolean and then (equal_index - start_index) >= Name.configuration_ns.count
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
			q_start, q_end: INTEGER; filled_template: ZSTRING; platform: STRING
			is_unix: BOOLEAN
		do
			create Result.make ((File_rule_template.occurrences ('%N') + 1) * 2)
			q_start := line.index_of ('"', 1) + 1
			if q_start > platform_indent then
				q_end := line.last_index_of ('"', line.count) - 1
				across line.substring (q_start, q_end).split (';') as list loop
					platform := list.item
					platform.left_adjust
					is_unix := platform.has_substring (unix)
					filled_template := File_rule_template #$ [platform, Platform_name [not is_unix]]
					across filled_template.split ('%N') as split loop
						Result.extend (split.item)
					end
				end
				Result.indent (platform_indent)
			end
		end

	unix: STRING
		do
			Result := Platform_name [True]
		end

	name_value_list (line: STRING): detachable like Once_name_value_list
		local
			pair_splitter: like Once_pair_splitter
			nvp: EL_NAME_VALUE_PAIR [STRING]
		do
			pair_splitter := Once_pair_splitter
			pair_splitter.set_target (line)
			if attached Once_name_value_list as list then
				list.wipe_out
				across pair_splitter as split loop
					if split.item_has ('=') then
						create nvp.make (split.item, '=')
						nvp.name.adjust
						list.extend (nvp)
					end
				end
				if list.count > 0 then
					Result := list
				end
			end
		end

	setting_name_value_list (a_line: STRING; is_first: BOOLEAN): EL_STRING_8_LIST
		local
			setting_lines: ZSTRING
		do
			if attached name_value_list (a_line) as nvp_list then
				create Result.make (nvp_list.count * 2)
				across nvp_list as list loop
					setting_lines := Setting_template #$ [list.item.name, list.item.value]
					across setting_lines.split ('%N') as line loop
						Result.extend (line.item)
					end
				end
				if is_first then
					Result.start; Result.remove
				end
				Result.indent (setting_indent)
			else
				create Result.make_empty
			end
		end

feature {NONE} -- Internal attributes

	platform_indent: INTEGER

	setting_indent: INTEGER

feature {NONE} -- Constants

	Eiffel_configuration: ZSTRING
		once
			Result := "http://www.eiffel.com/developers/xml/configuration-"
		end

	Name: TUPLE [condition, configuration_ns, platform, settings: STRING]
		once
			create Result
			Tuple.fill (Result, "condition, configuration_ns, platform, settings" )
		end

	Once_name_value_list: EL_ARRAYED_LIST [EL_NAME_VALUE_PAIR [STRING]]
		once
			create Result.make (7)
		end

	Once_pair_splitter: EL_SPLIT_ON_CHARACTER [STRING]
		once
			create Result.make_adjusted ("", ';', {EL_STRING_ADJUST}.Left)
		end

	Platform_list: STRING = "platform_list:"

	Platform_name: EL_BOOLEAN_INDEXABLE [STRING]
		once
			create Result.make ("windows", "unix")
		end

	File_rule_template: ZSTRING
		once
			Result := "[
				file_rule:
					exclude:
						"/#$"
					condition:
						platform:
							value = #
			]"
		end

	Setting_template: ZSTRING
		once
			Result := "[
				setting:
					name = #; value = #
			]"
		end

	XMS_NS_template: ZSTRING
		once
			Result := "[
				xmlns = "#"; xmlns.xsi = "http://www.w3.org/2001/XMLSchema-instance"; xsi.schemaLocation = "# #.xsd"
			]"
		end

end