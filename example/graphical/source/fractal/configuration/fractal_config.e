note
	description: "Fractal config"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-05-29 14:19:33 GMT (Wednesday 29th May 2019)"
	revision: "1"

class
	FRACTAL_CONFIG

inherit
	EL_BUILDABLE_FROM_PYXIS
		rename
			make_default as make
		redefine
			make
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			create image_path
			create background_image_path
			Precursor
		end

feature -- Access

	background_image_path: EL_FILE_PATH

	image_path: EL_FILE_PATH

feature {NONE} -- Build from nodes

	building_action_table: EL_PROCEDURE_TABLE [STRING]
		do
			create Result.make (<<
				["@background_image_path",	agent do background_image_path := node.to_expanded_file_path end],
				["@image_path",				agent do image_path := node.to_expanded_file_path end]
			>>)
		end

feature {NONE} -- Constants

	Root_node_name: STRING = "fractal"

end
