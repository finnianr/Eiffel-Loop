note
	description: "[
		NEL class `VECTOR_COMPLEX_DOUBLE' serializable to XML format:
		
			<?xml version="1.0" encoding="ISO-8859-1"?>
			<?create ROW_VECTOR_COMPLEX_64?>
			<vector-complex count="3">
				<row real="2.2" imag="3"/>
				<row real="2.2" imag="6.03"/>
				<row real="1.1" imag="3.5"/>
			</vector-complex>
		OR
			<?xml version="1.0" encoding="ISO-8859-1"?>
			<?create COLUMN_VECTOR_COMPLEX_64?>
			<vector-complex count="3">
				<col real="2.2" imag="3"/>
				<col real="2.2" imag="6.03"/>
				<col real="1.1" imag="3.5"/>
			</vector-complex>
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-11 15:20:18 GMT (Friday 11th August 2023)"
	revision: "13"

deferred class
	VECTOR_COMPLEX_64

inherit
	VECTOR_COMPLEX_DOUBLE
		rename
			make as make_matrix,
			count as count_times_2,
			log as natural_log
		redefine
			make_row, make_column
		end

	EROS_XML_RESULT
		rename
			Dot as Dot_character,
			put_real as put_real_variable,
			make as make_default
		undefine
			is_equal, copy, out
		redefine
			make_default, building_action_table, getter_function_table, Template
		end

	EL_MODULE_CHECKSUM
		rename
			checksum as Mod_checksum
		end

feature {NONE} -- Initialization

	make_column (nb_columns: INTEGER)
			--
		do
			make_default
			Precursor (nb_columns)
		end

	make_default
		do
			area := Default_area
			height := 1; width := 1
			Precursor {EROS_XML_RESULT}
		end

	make_from_binary_stream (a_stream: IO_MEDIUM)
			--
		require
			open_stream: a_stream.is_open_read
		do
			make_default
			set_parser_type ({EL_BINARY_ENCODED_PARSE_EVENT_SOURCE})
			build_from_stream (a_stream)
		end

	make_row (nb_rows: INTEGER)
			--
		do
			make_default
			Precursor (nb_rows)
		end

feature -- Access

	count: INTEGER
			--
		deferred
		end

	checksum: NATURAL
		local
			content: MANAGED_POINTER
		do
			create content.make_from_pointer (area.base_address, 2 * count * {PLATFORM}.Real_32_bytes)
			Result := Mod_checksum.data (content)
		end

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			Result := Precursor +
				["count", agent: INTEGER_REF do Result := count.to_reference end] +
				["element_name", agent: STRING do Result := element_name end] +
				[Var_current, agent: ITERABLE_COMPLEX_64_VECTOR do create Result.make (Current) end]
		end

feature {NONE} -- Implementation

	element_name: STRING
			--
		deferred
		ensure
			valid_count: Result.count = 3
		end

feature {NONE} -- Internal attributes

	index: INTEGER

	new_complex: COMPLEX_DOUBLE

feature {NONE} -- Building from XML

	building_action_table: EL_PROCEDURE_TABLE [STRING]
			--
		do
			create Result.make (<<
				["@count",						agent set_array_size_from_node],
				[element_name,					agent do index := index + 1 end],
				[element_name + "/@real",	agent do put_real (node.to_double, index) end],
				[element_name + "/@imag",	agent do put_imag (node.to_double, index) end]
			>>)
		end

	set_array_size_from_node
			--
		deferred
		end

feature {NONE} -- Constants

	Default_area: SPECIAL [DOUBLE]
		once
			create Result.make_filled (0, 2)
		end

	Template: STRING = "[
		<?xml version="1.0" encoding="ISO-8859-1"?>
		<?create {$generator}?>
		<$root_name count="$count">
		#across $Current as $complex_double loop
			<$element_name real="$complex_double.item.real" imag="$complex_double.item.imag"/>
		#end
		</$root_name>
	]"

end