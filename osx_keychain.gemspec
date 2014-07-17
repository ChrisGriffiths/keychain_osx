$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name    = "osx_keychain"
  s.version = "0.0.2"
  s.authors = ["Chris Griffiths"]
  s.email   = ["Christopher_Griffiths@hotmail.com"]
  s.homepage= "https://github.com/ChrisGriffiths/osx_keychain.git"
  s.summary  = "A ruby wrapper to add Certificates to a temporary keychain"
	
  s.files = Dir.glob("lib/**/*")
  
  s.require_paths = ["lib"]
end
