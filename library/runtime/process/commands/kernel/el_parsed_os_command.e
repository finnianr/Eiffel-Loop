note
	description: "[
		A [$source EL_OS_COMMAND] with arguments parsed and set in the attribute **var** with type
		defined as a class parameter
	]"
	notes: "[
		The names in **VARIABLES** type must occur in the same order as they do in the **template**
	]"
	descendants: "[
			EL_PARSED_OS_COMMAND* [VARIABLES -> TUPLE create default_create end]
				[$source EL_CREATE_TAR_COMMAND]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-08-20 11:37:23 GMT (Friday 20th August 2021)"
	revision: "1"

deferred class
	EL_PARSED_OS_COMMAND [VARIABLES -> TUPLE create default_create end]

inherit
	EL_OS_COMMAND
		rename
			template as command_template,
			make as make_command
		export
			{NONE} all
			{ANY} set_working_directory, execute
		redefine
			make_command
		end

feature {NONE} -- Initialization

	make
		do
			make_command (template)
			create var; fill_variables (var)
		ensure
			valid_variable_names: valid_variable_names
		end

	make_command (a_template: READABLE_STRING_GENERAL)
		do
			Precursor (a_template)
		ensure then
			valid_types: valid_tuple (create {VARIABLES})
		end

feature {NONE} -- Implementation

	template: READABLE_STRING_GENERAL
		deferred
		end

	valid_variable_names: BOOLEAN
		local
			i, pos: INTEGER; var_name: STRING
			l_template: like template
		do
			create var_name.make_filled ('$', 1)
			l_template := template
			Result := True
			from i := 1 until i > var.count or else not Result loop
				if attached {STRING} var.reference_item (i) as name then
					var_name.keep_head (1)
					var_name.append (name)
					pos := l_template.substring_index (var_name, pos + 1)
					if pos > 0 then
						pos := pos + var_name.count - 1
					else
						Result := False
					end
				else
					Result := False
				end
				i := i + 1
			end
		end

feature {NONE} -- Internal attributes

	var: VARIABLES

end