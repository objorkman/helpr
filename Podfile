# Uncomment this line to define a global platform for your project
# platform :ios, '6.0'

use_frameworks!
target 'helpr' do
	pod 'SwiftSpinner', '~> 0.7'
	pod 'FBSDKLoginKit', '~> 4.4'
	pod 'FBSDKCoreKit', '~> 4.4'
	pod 'ParseFacebookUtilsV4'
	pod 'ParseUI', '~> 1.1'
	pod 'Parse', '~> 1.7'
	pod 'Mixpanel', '~> 2.8'
	pod 'Pages'	
end

target 'helprTests' do

end

post_install do | installer |
  require 'fileutils'
  FileUtils.cp_r('Pods/Target Support Files/Pods-helpr/Pods-helpr-acknowledgements.plist', 'Settings.bundle/Acknowledgements.plist', :remove_destination => true)
end

