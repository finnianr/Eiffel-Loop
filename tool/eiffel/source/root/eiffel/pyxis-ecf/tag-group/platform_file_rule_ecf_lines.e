note
	description: "Expand cluster exclusion file rule for platform"
	notes: "[
		The shorthand rule:
		
			platform_list = "imp_mswin, imp_unix"
			
		is expanded as a pair of platform/exclude file rules
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-07-08 9:33:51 GMT (Friday 8th July 2022)"
	revision: "4"

class
	PLATFORM_FILE_RULE_ECF_LINES

inherit
	GROUPED_ECF_LINES
		redefine
			is_platform_rule, set_variables, set_from_line, Template
		end

create
	make

feature -- Access

	tag_name: STRING
		do
			Result := Name.file_rule
		end

feature -- Status query

	is_platform_rule (line: STRING): BOOLEAN
		do
			Result := line.occurrences ('"') = 2 and then line.has (';')
		end

feature -- Element change

	set_from_line (line: STRING)
		--	Expand:
		--		platform_list = "imp_mswin, imp_unix"
		--	as pair of platform/exclude file rules
		local
			q_start, q_end: INTEGER; nvp: EL_NAME_VALUE_PAIR [STRING]
			platform: STRING; is_unix: BOOLEAN
		do
			wipe_out
			q_start := line.index_of ('"', 1) + 1
			if q_start > tab_count then
				q_end := line.last_index_of ('"', line.count) - 1
				if attached Once_name_value_list as nvp_list then
					nvp_list.wipe_out
					across line.substring (q_start, q_end).split (';') as list loop
						platform := list.item; platform.left_adjust
						is_unix := platform.has_substring (unix)
						create nvp.make_pair (platform, Platform_name [not is_unix])
						nvp_list.extend (nvp)
					end
					set_from_pair_list (nvp_list)
					remove_first
				end
			end
		end

feature {NONE} -- Implementation

	set_variables (nvp: EL_NAME_VALUE_PAIR [STRING])
		do
			template.put (Var.directory, nvp.name)
			template.put (Var.value, nvp.value)
		end

	unix: STRING
		do
			Result := Platform_name [True]
		end

feature {NONE} -- Constants

	Platform_name: EL_BOOLEAN_INDEXABLE [STRING]
		once
			create Result.make ("windows", "unix")
		end

	Template: EL_TEMPLATE [STRING]
		once
			Result := "[
				file_rule:
					exclude:
						"/$DIRECTORY%$"
					condition:
						platform:
							value = $VALUE
			]"
		end

end