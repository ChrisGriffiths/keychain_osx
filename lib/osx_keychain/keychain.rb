KEYCHAIN_LOCATION = "/tmp/temp_keychain.keychain"

class Keychain

    def initialize(key_password)
        create(key_password)
        unlock
        set_default
    end 

    def unlock 
        command = "security default-keychain -s #{KEYCHAIN_LOCATION}"
        Command::run(command)
    end

     def import(cert, password)
        command = "security import '#{cert}' -k \"#{KEYCHAIN_LOCATION}\" -P #{password} -T /usr/bin/codesign"
        Command::run(command)
    end

    def delete
        command  = "security delete-keychain #{KEYCHAIN_LOCATION}"
        Command::run(command)
    end
    
private
    def create(key_password)
        command  = "security create-keychain -p #{key_password} \"#{KEYCHAIN_LOCATION}\""
        Command::run(command)
    end

    def set_default
        command = "security default-keychain -s #{KEYCHAIN_LOCATION}"
    end
end

# Create keychain 
# Set default  
# Unlock 
# Import keys/certs 
# Run stuff 
# Delete keychain 
 
# #!/bin/sh 
# security create-keychain -p travis ios-build.keychain 
# security import ./scripts/certs/apple.cer -k ~/Library/Keychains/ios-build.keychain -T /usr/bin/codesign 
# security import ./scripts/certs/dist.cer -k ~/Library/Keychains/ios-build.keychain -T /usr/bin/codesign 
# security import ./scripts/certs/dist.p12 -k ~/Library/Keychains/ios-build.keychain -P $KEY_PASSWORD -T /usr/bin/codesign 
# security default-keychain -s ios-build.keychain 
# mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles 
# cp "./scripts/profile/$PROFILE_NAME.mobileprovision" ~/Library/MobileDevice
