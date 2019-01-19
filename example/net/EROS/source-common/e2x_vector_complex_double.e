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
	date: "2019-01-18 12:40:48 GMT (Friday 18th January 2019)"
	revision: "3"

deferred class
	E2X_VECTOR_COMPLEX_DOUBLE

inherit
	VECTOR_COMPLEX_DOUBLE
		rename
			make as make_matrix,
			count as count_times_2,
			log as natural_log,
			make_empty as make_default
		redefine
			make_default, make_row, make_column
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

	make_default
		do
			Precursor {VECTOR_COMPLEX_DOUBLE}
			Precursor {EL_FILE_PERSISTENT_BUILDABLE_FROM_XML}
		end

	make_row (nb_rows: INTEGER)
			--
		do
			make_default
			Precursor (nb_rows)
		end

	make_column (nb_columns: INTEGER)
			--
		do
			make_default
			Precursor (nb_columns)
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
				["complex_double_list", agent: VECTOR_COMPLEX_DOUBLE_SEQUENCE do create Result.make_from_vector (Current) end]
			>>)
		end

feature {NONE} -- Implementation

	index: INTEGER

	new_complex: COMPLEX_DOUBLE

	vector_type: STRING
			--
		deferred
		end

feature {NONE} -- Building from XML

	increment_index
			--
		do
			index := index + 1
		end

	set_real_at_index_from_node
			--
		do
			new_complex.set_real (node.to_double)
		end

	set_imag_at_index_from_node
			--
		do
			new_complex.set_imag (node.to_double)
			put (new_complex, index)
		end

	set_array_size_from_node
			--
		deferred
		end

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

	Root_node_name: STRING = "vector-complex-double"

feature -- Constants

	Template: STRING =
		-- Substitution template
	"[
		<?xml version="1.0" encoding="iso-8859-1"?>
		<?create {$generator}?>
		<vector-complex-double count="$count">
			#foreach $item in $complex_double_list loop
			<$vector_type real="$item.real" imag="$item.imag"/>
			#end
		</vector-complex-double>
	]"

end
