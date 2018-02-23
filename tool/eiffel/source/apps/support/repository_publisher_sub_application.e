note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	REPOSITORY_PUBLISHER_SUB_APPLICATION [C -> REPOSITORY_PUBLISHER]

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [C]

feature {NONE} -- Implementation

	argument_specs: ARRAY [like specs.item]
		do
			Result := <<
				valid_required_argument ("config", "Path to publisher configuration file", << file_must_exist >>),
				required_argument ("version", "Repository version number"),
				optional_argument ("threads", "Number of threads to use for reading files")
			>>
		end

end
