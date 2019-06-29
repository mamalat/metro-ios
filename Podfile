# Uncomment the next line to define a global platform for your project
platform :ios, '11.4'
use_modular_headers!
use_frameworks!

target 'Metro' do
	pod 'Reveal-SDK', :configurations => ['Debug']
	pod 'Cartography', '~> 4.0'
	pod 'RealmSwift', '~> 3.16'
	pod 'IGListKit', '~> 3.4'
	pod 'Localize-Swift', '~> 2.0'
	pod 'DeviceKit', '~> 2.0'

	target 'MetroTests' do
		inherit! :search_paths

		pod 'Quick', '~> 2.1'
		pod 'Nimble', '~> 8.0'
	end

	target 'MetroUITests' do
		inherit! :search_paths
	end
end