note
	description: "[
		Format EROS request something like:
			
			<?xml version="1.0" encoding="ISO-8859-1"?>
			<?create $generator?>
			<vector-complex>
				<row..
			</vector-complex>
			<?call {MY_CLASS}.my_routine (1, {COLUMN_VECTOR_COMPLEX_64}, 0.1, 2.3e-15, 'hello')?>
		OR
			<?call{MY_CLASS}.my_routine?>

		Note: `COLUMN_VECTOR_COMPLEX_64' is an example of a place holder for an instance of a class
		deserialized from XML
	]"
	notes: "[
		String arguments for now, use single quotes, are not escaped, and limited to ASCII characters.
		Ideally they should be implemented as XML escaped strings using double quotes. The escape character
		for a double quote in a string could be the usual `%"'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-18 7:03:31 GMT (Tuesday 18th March 2025)"
	revision: "20"

class
	EROS_REMOTE_REQUEST

inherit
	EVC_SERIALIZEABLE_AS_XML
		rename
			make_default as make
		redefine
			make
		end

	EL_MODULE_NAMING

	EL_MODULE_TUPLE

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			create argument_list.make_empty
			create expression.make_empty
			serializeable := Default_serializeable
			Precursor
		end

feature -- Access

	expression: STRING
		-- Call expression

feature -- Element change

	set_processing_instruction (proxy_object: EROS_PROXY; routine_name: STRING; args: TUPLE)
			-- Set expression in processing instruction <?call $expression?>
			-- and serializeable
		require
			class_name_has_proxy_suffix: proxy_object.generator.ends_with (Underscore_proxy)
		local
			class_name: STRING
		do
			class_name := Naming.class_as_snake_upper (proxy_object, 0, 1)

			serializeable := Default_serializeable

			if args.is_empty then
				expression := Format.without_arguments #$ [class_name, routine_name]
			else
				set_argument_list (args, proxy_object.routine_table)
				expression := Format.with_arguments #$ [class_name, routine_name, argument_list]
			end
		end

feature {NONE} -- Implementation

	set_argument_list (args: TUPLE; routines_table: HASH_TABLE [EROS_ROUTINE, STRING])
			--
		local
			i: INTEGER; argument: ANY; list: STRING
			s: EL_STRING_8_ROUTINES
		do
			list := argument_list
			list.wipe_out
			from i := 1 until i > args.count loop
				if i > 1 then
					list.append (once ", ")
				end
				if args.is_reference_item (i) then
					argument := args.reference_item (i)
					if attached {STRING} argument as string then
						if routines_table.has (string) then
							list.append (string)
						else
							list.append (s.enclosed (string, '%'', '%''))
						end

					elseif attached {EVC_SERIALIZEABLE_AS_XML} argument as l_arg then
						serializeable := l_arg
						list.append (s.enclosed (l_arg.generator, '{', '}'))
					end
				else
					list.append (args.item (i).out)
				end
				i := i + 1
			end
		end

feature {NONE} -- Internal attributes

	argument_list: STRING
		-- string argument_list

	serializeable: EVC_SERIALIZEABLE_AS_XML
		-- serializeable argument to requested routine

feature {NONE} -- Evolicity

	getter_function_table: like getter_functions
			--
		do
			create Result.make_assignments (<<
				["serializeable", agent: EVC_SERIALIZEABLE_AS_XML do Result := serializeable end],
				["expression",		agent: STRING do Result := expression end]
			>>)
		end

feature -- Constants

	Default_serializeable: EROS_DEFAULT_RESULT
			--
		once
			create Result.make
		end

	Format: TUPLE [with_arguments, without_arguments: ZSTRING]
		-- Call formats
		-- `with_arguments' "{$class_name}.$routine_name ($argument_list)"
		-- `without_arguments' "{$class_name}.$routine_name"
		once
			create Result
			Tuple.fill (Result, "{%S}.%S (%S), {%S}.%S")
		end

	Template: STRING = "[
		#evaluate ($serializeable.template_name, $serializeable)
		<?call $expression?>
	]"

	Underscore_proxy: STRING = "_PROXY"

end