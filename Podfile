platform :ios

pod 'TestFlightSDK'
pod 'AFNetworking'
pod 'GMGridView'
pod 'JBKenBurnsView'
pod 'Facebook-iOS-SDK'

pod do |s|
  s.name     = 'Mixpanel-Custom'
  s.version  = '0.0.2'
  s.license  = ''
  s.summary  = 'iPhone tracking library for Mixpanel Analytics.'
  s.homepage = 'http://mixpanel.com'
  s.author   = { 'Mixpanel' => 'support@mixpanel.com' }
  s.source   = { :git => 'git://github.com/mixpanel/mixpanel-iphone.git', :commit => '8656f676959a85c484c4be899075b00eaff083d8' }
  s.platform = :ios
  s.source_files = 'MPLib/**/*.{h,m}'
  s.clean_paths = FileList['*'].exclude(/(MPLib|readme.mdown)$/)
end
