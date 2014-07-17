module OSX

    class ProvisioningProfile
        attr_reader :path, :name, :uuid, :identifiers, :devices, :appstore
        
        def initialize(path)
          
              raise "Provisioning profile '#{path}' does not exist" unless File.exists? path
              
              @path = path
              @identifiers = []
              @devices = []
              @appstore = true
              @enterprise = false
                            
              uuid = nil
              find_profile_uuid(path)
        end

        def find_profile_uuid(path)
            File.open(path, "rb") do |f|
                input = f.read

                if input=~/ProvisionedDevices/
                    @appstore = false
                end

                if input=~/<key>ProvisionsAllDevices<\/key>/
                    @enterprise = true
                end

                if input=~/<key>ProvisionedDevices<\/key>.*?<array>(.*?)<\/array>/im
                    $1.split(/<string>/).each do |id|
                          next if id.nil? or id.strip==""
                          @devices << id.gsub(/<\/string>/,'').strip
                    end
                end

                input=~/<key>UUID<\/key>.*?<string>(.*?)<\/string>/im
                @uuid = $1.strip
                      
                input=~/<key>Name<\/key>.*?<string>(.*?)<\/string>/im
                @name = $1.strip

                input=~/<key>ApplicationIdentifierPrefix<\/key>.*?<array>(.*?)<\/array>/im
                $1.split(/<string>/).each do |id|
                    next if id.nil? or id.strip==""
                    @identifiers << id.gsub(/<\/string>/,'').strip
                end
            end
        end

        def appstore?
            @appstore
        end

        def enterprise?
            @enterprise
        end

        def self.profiles_path
            File.expand_path "~/Library/MobileDevice/Provisioning\\ Profiles/"  
        end

        def install_path
            "#{ProvisioningProfile.profiles_path}/#{self.uuid}.mobileprovision"
        end

        def install
            # Do not reinstall if profile is same and is already installed
            return if (self.path == self.install_path.gsub(/\\ /, ' '))

            ProvisioningProfile.installed_profiles.each do |installed|
                if installed.identifiers==self.identifiers and installed.uuid==self.uuid
                  installed.uninstall
                end
            end

            command = "cp #{self.path} #{self.install_path}"
            OSX::Command::run(command)
        end

        def uninstall
            command = "rm -f #{self.install_path}"
            OSX::Command::run(command)
        end

        def self.installed_profiles
            Dir["#{self.profiles_path}/*.mobileprovision"].map do |file|
                ProvisioningProfile.new(file)
            end
        end

        def self.find_installed_by_uuid uuid
            ProvisioningProfile.installed_profiles.each do |p|
                return p if p.uuid == uuid
            end
        end

        def self.installed_profile(name)
            self.installed_profiles.select {|p| p.name == name.to_s}.first;
        end

    end

end