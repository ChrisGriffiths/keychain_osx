keychain_osx
============

keychain_osx is a gem to help make like easier when working with the keychain.
When your working with CI or multiple developor it can be difficult to manage keys. 
This gem Allwo you to create a temporay keychain where the new certificates can be imported.

###Temporay keychain
Creates a Temporay keychain that is deleted after the block has completed

```
require 'keychain_osx'
        
OSX::Keychain.temp do |keychain|

    keychain.import('PrivateKey.p12','password')
    OSX::ProvisioningProfile.new('ROVISONING_PROFILE').install
    run_some_stuff(things)

end
```

###Permanent Support
####Create a new Keychain
```
Keychain.new("keychain_password")
```

####Import a certificate
Passing the certificate path and the password
```
keychain.import(cert_path , "password")
```

####Delete a Keychain
```
keychain.delete
```

####Unlock Keychain
```
keychain.unlock(password)
```

###Example

```
require "osx_keychain"

keychain = Keychain.new("keychain_password")

cert_path = "DeveloperCert/PrivateKey.p12"
keychain.set_default
keychain.import(cert_path , "password")

keychain.delete
```
