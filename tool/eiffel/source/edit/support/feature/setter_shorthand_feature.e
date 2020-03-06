note
	description: "[
		Expand setter shorthand
		
			@set name
			
		AS
		
			set (a_name: like name)
				do
					name := a_name
				end
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-06 13:31:06 GMT (Friday 6th March 2020)"
	revision: "1"

class
	SETTER_SHORTHAND_FEATURE

inherit
	CLASS_FEATURE

create
	make

feature -- Element change

	expand_shorthand
		-- expand setter shorthand notation
		local
			line: ZSTRING; pos_space: INTEGER
			variable_name: ZSTRING; setter_lines: EL_ZSTRING_LIST
		do
			line := lines.first

			variable_name := line.substring_end (line.index_of (' ', 1) + 1)

			Atttribute_setter_template.set_variable (once "name", variable_name)
			lines.wipe_out
			create setter_lines.make_with_lines (Atttribute_setter_template.substituted)
			setter_lines.indent (1)
			lines.append (setter_lines)

			name.wipe_out
			name.append_string_general ("set_")
			name.append (variable_name)
		end

feature {NONE} -- Constants

	Atttribute_setter_template: EL_ZSTRING_TEMPLATE
		local
			str: STRING
		once
			str := "[
				set_$name (a_$name: like $name)
					do
						$name := a_$name
					end
			]"
			str.append_character ('%N')
			create Result.make (str)
		end

end
