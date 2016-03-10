note
	description: "Summary description for {EIFFEL_FEATURE_LABEL_EXPANDER_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:34 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EIFFEL_FEATURE_LABEL_EXPANDER_APP

inherit
	EIFFEL_SOURCE_EDIT_SUB_APP
		redefine
			Option_name
		end

create
	make

feature {NONE} -- Implementation

	create_file_editor: EIFFEL_FEATURE_LABEL_EXPANDER
		do
			create Result.make_from_file (file_path)
		end

feature {NONE} -- Constants

	Checksum: NATURAL = 489355222

	Option_name: STRING = "expand_features"

	Description: STRING = "Expand feature label abbreviations"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{EIFFEL_FEATURE_LABEL_EXPANDER_APP}, "*"],
				[{EL_TEST_ROUTINES}, "*"],
				[{EIFFEL_FEATURE_LABEL_EXPANDER}, "*"]
			>>
		end

end
