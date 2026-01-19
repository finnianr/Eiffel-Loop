# coding: utf-8
import hmac
import hashlib

def sign (message):
	utf_8 = message.encode ('utf-8')
	API_SECRET = "secret"
	digest = hmac.new(
		API_SECRET,
		msg=utf_8,
		digestmod=hashlib.sha256
	).hexdigest().upper()

	print utf_8, '=', digest

sign (u'€ 100')
sign ('one\ntwo\nthree')
