note
	description: "Summary description for {RANDOM_RSA_KEY_PAIR}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-24 12:38:19 GMT (Monday 24th June 2013)"
	revision: "2"

class
	EL_STORABLE_RSA_KEY_PAIR

inherit
	EL_RSA_KEY_PAIR
		redefine
			public, private
		end

create
	make

feature -- Element change

	save (location: EL_DIR_PATH; name: STRING)
			--
		do
			public.save_as_xml (location + (name + ".public-key.xml"))
			private.save_as_xml (location + (name + ".private-key.xml"))
		end

feature -- Access

	public: EL_STORABLE_RSA_PUBLIC_KEY

	private: EL_STORABLE_RSA_PRIVATE_KEY

end
