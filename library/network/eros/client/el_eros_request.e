note
	description: "Eros request"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-12 18:58:03 GMT (Sunday 12th January 2020)"
	revision: "7"

class
	EL_EROS_REQUEST

inherit
	EVOLICITY_SERIALIZEABLE_AS_XML
		rename
			make_default as make
		redefine
			make
		end

	EL_MODULE_NAMING

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			create argument_list.make_empty
			create expression.make_empty
			serializeable_argument := Default_serializeable_argument
			Precursor
		end

feature -- Access

	expression: STRING
		-- Call expression

feature -- Element change

	set_expression_and_serializeable_argument (
		proxy_object: EL_REMOTE_PROXY; a_routine_name: STRING; args: TUPLE
	)
			-- Set call expression for processing instruction 'call' and serializeable_argument
		require
			class_name_has_proxy_suffix: proxy_object.generator.ends_with (Underscore_proxy)
		local
			l_template: EL_STRING_8_TEMPLATE; class_name: STRING
		do
			class_name := Naming.class_as_upper_snake (proxy_object, 0, 1)

			serializeable_argument := Default_serializeable_argument

			if args.is_empty then
				l_template := Empty_arguments_expression_template
			else
				l_template := Expression_template
				set_argument_list_and_serializeable_argument (args)
				l_template.set_variable ("argument_list", argument_list)
			end
			l_template.set_variable ("class_name", class_name)
			l_template.set_variable ("routine_name", a_routine_name)
			expression := l_template.substituted
		end

feature {NONE} -- Implementation

	set_argument_list_and_serializeable_argument (args: TUPLE)
			--
		local
			i: INTEGER
			argument: ANY
			list: STRING
		do
			list := argument_list
			list.wipe_out

			from i := 1 until i > args.count loop
				if i > 1 then
					list.append (once ", ")
				end
				if args.is_reference_item (i) then
					argument := args.reference_item (i)
					if attached {EL_EIFFEL_IDENTIFIER} argument as once_function_identifier then
						list.append (once_function_identifier)

					elseif attached {EVOLICITY_SERIALIZEABLE_AS_XML} argument as serializeable then
						serializeable_argument := serializeable
						list.append_character ('{')
						list.append (serializeable.generator)
						list.append_character ('}')

					elseif attached {STRING} argument as string_literal then
						list.append_character ('%'')
						list.append (string_literal)
						list.append_character ('%'')

					end
				else
					list.append (args.item (i).out)
				end
				i := i + 1
			end
		end

	serializeable_argument: EVOLICITY_SERIALIZEABLE_AS_XML

	argument_list: STRING
		-- string argument_list

feature {NONE} -- Evolicity

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["serializeable_argument", agent: EVOLICITY_SERIALIZEABLE_AS_XML do Result := serializeable_argument end],
				["expression", agent: STRING do Result := expression end]
			>>)
		end

	Template: STRING =
		--
	"[
		#evaluate ($serializeable_argument.template_name, $serializeable_argument)
		<?call $expression?>
	]"

feature -- Constants

	Default_serializeable_argument: EL_EROS_DEFAULT_ARGUMENT
			--
		once
			create Result.make
		end

	Expression_template: EL_STRING_8_TEMPLATE
			--
		once
			create Result.make (Call_template + " ($argument_list)")
		end

	Empty_arguments_expression_template: EL_STRING_8_TEMPLATE
			--
		once
			create Result.make (Call_template)
		end

	Call_template: STRING = "{$class_name}.$routine_name"

	Underscore_proxy: STRING = "_PROXY"

end
