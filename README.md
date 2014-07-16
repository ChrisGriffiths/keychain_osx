osx_keychain
============

osx_keychain is a gem to help make like easier when working with the keychain.
When your working with CI or multiple developor it can be difficult to manage keys. 
This gem Allwo you to create a temporay keychain where the new certificates can be imported.

###Create a new Keychain
```
Keychain.new("keychain_password")
```

###Import a certificate
Passing the certificate path and the password
```
keychain.import(cert_path , "password")
```

###Delete a Keychain
```
keychain.delete
```

###Example

```
require "osx_keychain"

keychain = Keychain.new("keychain_password")

cert_path = "DeveloperCert/PrivateKey.p12"
keychain.import(cert_path , "password")

keychain.delete
```
