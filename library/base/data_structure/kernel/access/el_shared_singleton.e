note
	description: "Shared singleton"
	notes: "[
		redefine `item' as a once ("PROCESS") function
		
			deferred class SHARED_MY_CLASS
			inherit
				EL_SHARED_SINGLETON [MY_CLASS]
					rename
						item as My_class
					redefine
						My_class
					end
			
			feature {NONE} -- Constants

				My_class: MY_CLASS
					once ("PROCESS")
						Result := Precursor
					end

			end

		and make the following call in make procedure of singleton class.
		
			class MY_CLASS		
				make
					do
						check_singleton (My_class)
						..
					end
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-18 18:38:45 GMT (Thursday 18th July 2019)"
	revision: "1"

deferred class
	EL_SHARED_SINGLETON [G]

inherit
	EL_ANY_SHARED

feature {NONE} -- Implementation

	check_singleton (a_item: G)
		-- check that `a_item' is the same as `Current'
		require
			called_from_singleton_type: generating_type ~ {G}
		local
			exception: DEVELOPER_EXCEPTION
		do
			if a_item /= item then
				create exception
				exception.set_description ("Shared singleton was not instantiated from {" + ({G}).name + "}.make")
				exception.raise
			end
		end

feature {NONE} -- Constants

	item: G
		-- singleton item
		do
			if attached {G} Current as l_result then
				Result := l_result
			end
		ensure
			attached_result: attached Result
		end

end
