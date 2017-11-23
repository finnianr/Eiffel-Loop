note
	description: "Summary description for {EL_SHA_256}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_SHA_256

inherit
	SHA256
		redefine
			reset
		end

create
	make

feature -- Element change

	reset
		do
			Precursor
			byte_count := 0
		end
end
