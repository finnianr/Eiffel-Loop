note
	description: "Shared table of [https://en.wikipedia.org/wiki/Singleton_pattern singleton objects]"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "6"

deferred class
	EL_SHARED_SINGLETONS

inherit
	EL_ANY_SHARED

feature {NONE} -- Implementation

	put_singleton (obj: ANY)
		-- for clarity we supply `Current' as argument `obj'
		do
			Singleton_table.put (obj)
		end

feature {NONE} -- Constants

	Singleton_table: EL_SINGLETON_TABLE
		-- singleton item
		once ("PROCESS")
			create Result.make (11)
		end

note
	notes: "[
		To shared an object with the rest of an application as a singleton,
		make a call to routine `set_singleton' as follows:

			class MY_CLASS
			inherit
				EL_SHARED_SINGLETONS

			feature {NONE}	-- Initialization
				make
					do
						put_singleton (Current)
						..
					end

		then define shared once function as follows:

			deferred class SHARED_GLOBAL_INSTANCE
			inherit
				EL_ANY_SHARED

			feature {NONE} -- Constants

				Global_instance: MY_CLASS
					local
						l: EL_SINGLETON [MY_CLASS]
					once ("PROCESS")
						create l
						Result := l.singleton
					end
			end
			
		See also class: ${EL_SINGLETON [G]}
	]"

end