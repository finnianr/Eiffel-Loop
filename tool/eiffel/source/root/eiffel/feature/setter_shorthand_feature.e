note
	description: "[
		Expand setter shorthand
		
			@set name
			
		AS
		
			set (a_name: like name)
				do
					name := a_name
				end
				
		However if the type of `name' is known, the explicit type name is used instead of the anchored name.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-05-29 9:24:34 GMT (Wednesday 29th May 2024)"
	revision: "7"

class
	SETTER_SHORTHAND_FEATURE

inherit
	CLASS_FEATURE
		rename
			make as make_feature
		end

create
	make

feature {NONE} -- Initialization

	make (line, a_attribute_name: ZSTRING; a_get_attribute_type: like get_attribute_type)
		do
			make_feature (line)
			attribute_name := a_attribute_name; get_attribute_type := a_get_attribute_type
		end

feature -- Element change

	expand_shorthand
		-- expand setter shorthand notation
		do
			Atttribute_setter_template.put (Var.name, attribute_name)
			if attached get_attribute_type (attribute_name) as type then
				if type.is_empty then
					Atttribute_setter_template.put (Var.type, Like_prefix + attribute_name)
				else
					Atttribute_setter_template.put (Var.type, type)
				end
			end
			lines.wipe_out
			if attached Atttribute_setter_template.substituted.lines as setter_lines then
				setter_lines.indent (1)
				lines.append (setter_lines)
			end
			name := Set_prefix + attribute_name
		end

feature {NONE} -- Internal attributes

	attribute_name: ZSTRING

	get_attribute_type: FUNCTION [ZSTRING, ZSTRING]

feature {NONE} -- Constants

	Atttribute_setter_template: EL_ZSTRING_TEMPLATE
		local
			str: STRING
		once
			str := "[
				set_$name (a_$name: $type)
					do
						$name := a_$name
					end
			]"
			str.append_character ('%N')
			create Result.make (str)
		end

feature {NONE} -- Constants

	Set_prefix: ZSTRING
		once
			Result := "set_"
		end

	Var: TUPLE [name, type: IMMUTABLE_STRING_8]
		once
			create Result
			Tuple.fill_immutable (Result, "name, type")
		end
end