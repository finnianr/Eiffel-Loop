note
	description: "Pyxis ECF parser"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-28 16:33:50 GMT (Tuesday 28th June 2022)"
	revision: "10"

class
	PYXIS_ECF_PARSER

inherit
	EL_PYXIS_PARSER
		redefine
			call_state_procedure, parse_line
		end

create
	make

feature {NONE} -- State procedures

	call_state_procedure (line: STRING)
		local
			s_8: EL_STRING_8_ROUTINES; equal_index, platform_index: INTEGER
			platform_value, value_line: STRING
		do
			line.right_adjust
			if line.ends_with (Platform_list) and then line [1] = '%T' then
				platform_indent := s_8.leading_occurences (line, '%T')

--			insert platform/exclude rules
			elseif platform_indent.to_boolean and then line.occurrences ('"') = 2 and then line.has (';') then
				across platform_lines (line) as list loop
					Precursor (list.item)
				end
				platform_indent := 0

			else
				equal_index := line.index_of ('=', 1)
				if equal_index > 0 then -- and then element_stack.count > 0 and then element_stack.item ~ Condition
					platform_index := line.substring_index (Platform_attribute, 1)
					if platform_index > 1 and then line [platform_index - 1] = '%T'
						and then platform_index + Platform_attribute.count <= equal_index
						and then line [platform_index + Platform_attribute.count] /= ':'
						and then tag_name ~ Condition
					then
--						Change:
--							platform = windows
--						to:
--							platform:
--								value = windows
						platform_value := line.substring (equal_index + 1, line.count)
						platform_value.adjust
						line.replace_substring (s_8.character_string (':'), platform_index + Platform_attribute.count, line.count)
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

	parse_line (line: STRING; start_index, end_index: INTEGER)
		local
			nvp_end, equal_index: INTEGER; assignment: EL_ASSIGNMENT_ROUTINES
			xml_ns: STRING; eiffel_url, configuration_name_value: ZSTRING
		do
			equal_index := line.index_of ('=', start_index)
			if equal_index.to_boolean and then (equal_index - start_index) >= Configuration_ns.count
				and then line.same_characters (Configuration_ns, 1, Configuration_ns.count, start_index)
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

	platform_lines (line: STRING): EL_STRING_8_LIST
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

feature {NONE} -- Internal attributes

	platform_indent: INTEGER

feature {NONE} -- Constants

	Configuration_ns: STRING = "configuration_ns"

	Condition: STRING = "condition"

	Eiffel_configuration: ZSTRING
		once
			Result := "http://www.eiffel.com/developers/xml/configuration-"
		end

	Platform_list: STRING = "platform_list:"

	Platform_attribute: STRING = "platform"

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

	XMS_NS_template: ZSTRING
		once
			Result := "[
				xmlns = "#"; xmlns.xsi = "http://www.w3.org/2001/XMLSchema-instance"; xsi.schemaLocation = "# #.xsd"
			]"
		end

end