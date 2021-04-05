# ignore all warnings from all pods
inhibit_all_warnings!

use_frameworks!
platform :ios, '12.1'

def app_pods
	pod 'SDWebImage', '5.10.4'
end

def test_pods
	# Example: SnapshotTesting
end

target 'MarvelBabel-MOCK' do
	app_pods
  target 'MarvelBabelTests' do
    inherit! :search_paths
    test_pods
  end
end

target 'MarvelBabel-PRO' do
	app_pods
end

target 'Domain' do
	# Example: RxSwift
	target 'DomainTests' do
		inherit! :search_paths
	end
end

target 'Data' do
	pod 'Alamofire', '5.4.1'
	target 'DataTests' do
		inherit! :search_paths
	end
end
