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
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-24 12:03:11 GMT (Monday 24th June 2013)"
	revision: "2"

deferred class
	E2X_VECTOR_COMPLEX_DOUBLE

inherit
	VECTOR_COMPLEX_DOUBLE
		rename
			make as make_matrix,
			count as count_times_2,
			log as natural_log
		undefine
			default_create
		redefine
			make_row, make_column
		end

	EL_BUILDABLE_XML_FILE_PERSISTENT
		undefine
			is_equal, copy, out
		redefine
			default_create, building_action_table
		end

feature {NONE} -- Initialization

	make_row (nb_rows: INTEGER)
			--
		do
			make
			Precursor (nb_rows)
		end

	make_column (nb_columns: INTEGER)
			--
		do
			make
			Precursor (nb_columns)
		end

	default_create
			--
		do
			make_matrix (1, 1)
		end

feature -- Access

	count: INTEGER
			--
		deferred
		end

feature {NONE} -- Evolicity reflection

	get_vector_type: STRING
			--
		do
			Result := vector_type
		end

	get_generator: STRING
			--
		do
			Result := generator
		end

	get_complex_double_list: ITERABLE [E2X_COMPLEX_DOUBLE]
			--
		do
			create {VECTOR_COMPLEX_DOUBLE_SEQUENCE} Result.make_from_vector (Current)
		end

	get_count: INTEGER_REF
			--
		do
			Result := count.to_reference
		end

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["generator", agent get_generator],
				["count", agent get_count],
				["vector_type", agent get_vector_type],
				["complex_double_list", agent get_complex_double_list]
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

	building_action_table: like Type_building_actions
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
