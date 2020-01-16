note
	description: "[
		VECTOR_COMPLEX_DOUBLE serializable to format:
		
			<?xml version="1.0" encoding="ISO-8859-1"?>
			<?type row?>
			<vector-complex-double count="3">
				<row real="2.2" imag="3"/>
				<row real="2.2" imag="6.03"/>
				<row real="1.1" imag="3.5"/>
			</vector-complex-double>
		OR
			<?xml version="1.0" encoding="ISO-8859-1"?>
			<?type col?>
			<vector-complex-double count="3">
				<col real="2.2" imag="3"/>
				<col real="2.2" imag="6.03"/>
				<col real="1.1" imag="3.5"/>
			</vector-complex-double>
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-16 19:15:38 GMT (Thursday 16th January 2020)"
	revision: "5"

deferred class
	VECTOR_COMPLEX_DOUBLE

inherit
	NEL_VECTOR_COMPLEX_DOUBLE
		rename
			make as make_matrix,
			count as count_times_2,
			log as natural_log
		redefine
			make_row, make_column
		end

	EL_FILE_PERSISTENT_BUILDABLE_FROM_XML
		rename
			put_real as put_real_variable
		undefine
			is_equal, copy, out
		redefine
			make_default, building_action_table
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
			Precursor {EL_FILE_PERSISTENT_BUILDABLE_FROM_XML}
		end

	make_from_binary_stream (a_stream: IO_MEDIUM)
			--
		require
			open_stream: a_stream.is_open_read
		do
			make_default
			set_parser_type ({EL_BINARY_ENCODED_XML_PARSE_EVENT_SOURCE})
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

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["generator", agent: STRING do Result := generator end],
				["count", agent: INTEGER_REF do Result := count.to_reference end],
				["vector_type", agent: STRING do Result := vector_type end],
				["Current", agent: ITERABLE_COMPLEX_DOUBLE_VECTOR do create Result.make (Current) end]
			>>)
		end

feature {NONE} -- Implementation

	vector_type: STRING
			--
		deferred
		end

feature {NONE} -- Internal attributes

	index: INTEGER

	new_complex: NEL_COMPLEX_DOUBLE

feature {NONE} -- Building from XML

	Root_node_name: STRING = "vector-complex-double"

	building_action_table: EL_PROCEDURE_TABLE [STRING]
			--
		do
			create Result.make (<<
				["@count", agent set_array_size_from_node],
				["col", agent increment_index],
				["col/@real", agent set_real_at_index_from_node],
				["col/@imag", agent set_imag_at_index_from_node],

				["row", agent increment_index],
				["row/@real", agent set_real_at_index_from_node],
				["row/@imag", agent set_imag_at_index_from_node]
			>>)
		end

	increment_index
			--
		do
			index := index + 1
		end

	set_array_size_from_node
			--
		deferred
		end

	set_imag_at_index_from_node
			--
		do
			new_complex.set_imag (node.to_double)
			put (new_complex, index)
		end

	set_real_at_index_from_node
			--
		do
			new_complex.set_real (node.to_double)
		end

feature {NONE} -- Constants

	Default_area: SPECIAL [DOUBLE]
		once
			create Result.make_filled (0, 2)
		end

	Template: STRING = "[
		<?xml version="1.0" encoding="iso-8859-1"?>
		<?create {$generator}?>
		<vector-complex-double count="$count">
			#across $Current as $complex_double loop
			<$vector_type real="$complex_double.item.real" imag="$complex_double.item.imag"/>
			#end
		</vector-complex-double>
	]"

end
