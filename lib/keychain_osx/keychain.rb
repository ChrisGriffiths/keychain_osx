KEYCHAIN_LOCATION = "/tmp/temp_keychain#{Time.now.to_i}.keychain"
TEMP_PASSWORD = "keychain_password"

module OSX
        
    class Keychain

        attr_accessor :keychain_path

        def initialize(keychain_path, key_password)
            @keychain_path = keychain_path
            create(key_password)
            unlock(key_password)
            add_to_search_path
        end 

        def unlock(password)
            command = "security unlock-keychain -p #{password} \"#{@keychain_path}\""
            OSX::Command::run(command)
        end

        def import(cert, password)
            command = "security import '#{cert}' -k \"#{@keychain_path}\" -P #{password} -T /usr/bin/codesign"
            OSX::Command::run(command)
        end

        def delete
            command  = "security delete-keychain #{@keychain_path}"
            OSX::Command::run(command)
        end
        
        def set_default
            command = "security default-keychain -s #{@keychain_path}"
            OSX::Command::run(command)
        end

        def add_to_search_path
            keychains = []

            `security list-keychain`.split.map do |keychain| 
                keychains << keychain.strip.gsub(/\"/,'')
            end

            keychains << @keychain_path

            command = "security list-keychain -s #{keychains.join(' ')}"
            OSX::Command::run(command)
        end

        def self.temp(&block)
            kc = OSX::Keychain.new(KEYCHAIN_LOCATION, TEMP_PASSWORD)
            kc.unlock(TEMP_PASSWORD)

            if block_given? # block is given
                begin
                    yield(kc)
                ensure
                    kc.delete
                end
            else 
                kc.delete
            end
        end

        private
        def create(key_password, timeout = 600)
            command  = "security create-keychain -p #{key_password} \"#{@keychain_path}\""
            OSX::Command::run(command)

            command  = "security set-keychain-settings -u \"#{@keychain_path}\""
            OSX::Command::run(command)
        end
    end
end
