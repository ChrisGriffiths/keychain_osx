module OSX
    
    module Command
        def self.run(*cmd, &block)
            unless block_given?
              block = lambda { |ok, status|
                ok or fail "Command failed with status (#{status.exitstatus}): [#{cmd.join(" ")}]"
              }
            end
            puts cmd
            res = system(*cmd)      
            block.call(res, $?)
        end
    end
end