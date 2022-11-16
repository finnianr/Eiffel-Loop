note
	description: "HTTP cookie"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "10"

class
	EL_HTTP_COOKIE

inherit
	EL_STRING_8_CONSTANTS

	EL_SHARED_UTF_8_ZCODEC

	DATE_CONSTANTS
		export
			{NONE} all
		end

create
	make

feature -- Initialization

	make (a_name: STRING; a_value: READABLE_STRING_GENERAL)
			-- Create a new cookie with 'a_name' and 'a_value'
		require
			name_not_reserved_word: not is_reserved_cookie_word (a_name)
		do
			name := a_name
			create value.make_empty
			value.append_general (a_value)

			domain := Empty_string_8
			path := Empty_string_8
			comment := Empty_string_8
			max_age := -1
		end

feature -- Access

	comment: STRING
			-- Optional cookie comment

	domain: STRING
			-- Optional dDomain that will see cookie

	max_age: INTEGER
			-- Optional maximum age of this cookie, -1 if no expiry.

	name: STRING
			-- Name of this cookie

	path: STRING
			-- Optional URL that will see cookie

	secure: BOOLEAN
			-- Optional use SSL?

	value: EL_COOKIE_STRING_8
			-- Value of this cookie

	version: INTEGER
			-- Version

feature -- Status setting

	set_comment (a_comment: like comment)
			-- Set 'comment' to 'a_comment'
		do
			comment := a_comment
		end

	set_domain (a_domain: like domain)
			-- Set 'domain' to 'a_domain'
		do
			domain := a_domain
		end

	set_max_age (a_max_age: like max_age)
			-- Set 'max_age' to 'a_max_age'
		do
			max_age := a_max_age
		end

	set_path (a_path: like path)
			-- Set 'path' to 'a_path'
		do
			path := a_path
		end

	set_secure (flag: like secure)
			-- Set 'secure' to 'flag'
		do
			secure := flag
		end

	set_version (a_version: like version)
			-- Set 'version' to a_version
		do
			version := a_version
		end

feature -- Validation

	is_reserved_cookie_word (word: STRING): BOOLEAN
			-- Is 'word' a reserved cookie word?
		do
			Result := Reserved_words.has (word.as_lower)
		end

feature -- Conversion

	header_string: STRING
			-- Return string representation of this cookie suitable for
			-- a request header value. This routine formats the cookie using
			-- version 0 of the cookie spec (RFC 2109).
			-- See also http://www.netscape.com/newsref/std/cookie_spec.html
		local
			string: STRING; buffer: EL_STRING_8_BUFFER_ROUTINES
		do
			string := buffer.empty
			-- optional secure, no value
			across header_terms as term loop
				if not string.is_empty then
					string.append (once "; ")
				end
				string.append (term.key)
				string.append_character ('=')
				string.append (term.item)
			end
			if secure then
				string.append ("; secure")
			end
			create Result.make_from_string (string)
		end

	max_age_to_date (age: INTEGER): ZSTRING
			-- Convert max_age to a date
		local
			time: DATE_TIME
		do
			time := Date_time
			time.make_now_utc
			time.second_add (age)
			create Result.make (Expired_date.count)
			Result.append_string_general (Days_text [time.date.day_of_the_week])
			Result.to_proper_case
			Result.append_string_general (once ", ")
			Result.append_string_general (time.formatted_out (Time_format))
			Result.append_string_general (once " GMT")
		end

feature {NONE} -- Implementation

	header_terms: HASH_TABLE [STRING, STRING]
		do
			create Result.make (0)
			Result [name] := value
			Result [once "Version"] := version.out
			if not comment.is_empty then
				Result [once "Comment"] := comment
			end
			if max_age >= 0 then
				if max_age = 0 then
					Result [Expires_label] := Expired_date
				else
					Result [Expires_label] := max_age_to_date (max_age).to_latin_1
				end
			end
			if not domain.is_empty then
				Result [once "Domain"] := domain
			end
			if not path.is_empty then
				Result [once "Path"] := path
			end
		end

feature {NONE} -- Constants

	Date_time: DATE_TIME
		once
			create Result.make_now
		end

	Expired_date: STRING = "Tue, 01-Jan-1970 00:00:00 GMT"

	Expires_label: STRING = "Expires"

	Max_age_label: STRING = "Max-Age"

	Reserved_words: ARRAY [STRING]
		once
			Result := << "comment", "discard", "domain", "expires", "max-age", "path", "secure", "version" >>
			Result.compare_objects
		end

	Time_format: STRING = "yyyy-[0]mm-[0]dd hh:[0]mi:[0]ss"

end