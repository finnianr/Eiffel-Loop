note
	description: "Summary description for {EVOLICITY_CACHEABLE_SERIALIZEABLE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EVOLICITY_CACHEABLE_SERIALIZEABLE

inherit
	EVOLICITY_SERIALIZEABLE
		rename
			as_text as new_text,
			as_utf_8_text as new_utf_8_text
		export
			{NONE} new_text, new_utf_8_text
		redefine
			make_default
		end

	EVOLICITY_CACHEABLE
		redefine
			make_default
		end

feature {NONE} -- Initialization

	make_default
			--
		do
			Precursor {EVOLICITY_CACHEABLE}
			Precursor {EVOLICITY_SERIALIZEABLE}
		end
end
