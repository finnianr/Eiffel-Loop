note
	description: "Smil audio clip"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "8"

class
	SMIL_AUDIO_CLIP

inherit
	EL_EIF_OBJ_BUILDER_CONTEXT
		rename
			make_default as make
		redefine
			make, on_context_exit
		end

	EVOLICITY_EIFFEL_CONTEXT
		rename
			make_default as make
		redefine
			make
		end

	EL_SMIL_VALUE_PARSING

	OUTPUT_ROUTINES

create
	make

feature {NONE} -- Initialization

	make
		do
			Precursor {EVOLICITY_EIFFEL_CONTEXT}
			Precursor {EL_EIF_OBJ_BUILDER_CONTEXT}
		end

feature -- Access

	source: ZSTRING

	title: ZSTRING

	onset: REAL

	offset: REAL

	id: INTEGER

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["id", 		agent: INTEGER_REF do Result := id.to_reference end],
				["source",	agent: ZSTRING do Result := source end],
				["title", 	agent: ZSTRING do Result := title end],
				["onset",	agent: STRING do Result := Seconds.formatted (onset) end],
				["offset",	agent: STRING do Result := Seconds.formatted (offset) end]
			>>)
		end

feature {NONE} -- Build from XML

	on_context_exit
		do
			lio.put_line ("on_context_exit")
			lio.put_string_field ("Audio clip", title); lio.put_integer_field (" id", id); lio.put_new_line
			lio.put_string_field ("source", source); lio.put_new_line
			lio.put_real_field ("onset", onset); lio.put_real_field (" offset", offset)
			lio.put_new_line_x2
		end

	building_action_table: EL_PROCEDURE_TABLE [STRING]
			-- Relative to nodes /smil/body/seq/audio
		do
			create Result.make (<<
				["@id", agent do id := node_as_integer_suffix end],
				["@src", agent do source := node.to_string end],
				["@title", agent do title := node.to_string end],
				["@clipBegin", agent do onset := node_as_real_secs end],
				["@clipEnd", agent do offset := node_as_real_secs end]
			>>)
		end

feature {NONE} -- Implementation

	Seconds: FORMAT_DOUBLE
			--
		once
			create Result.make (3, 1)
		end

end