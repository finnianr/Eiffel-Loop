note
	description: "Summary description for {EL_KEY_IDENTIFIABLE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_KEY_IDENTIFIABLE

feature -- Access

	key: NATURAL

feature -- Element change

	set_key (a_key: like key)
		do
			key := a_key
		end
	
end
