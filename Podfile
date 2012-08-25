platform :ios

pod 'TestFlightSDK'
pod 'AFNetworking'
pod 'GMGridView'

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

pod do |s|
  s.name     = 'JBKenBurnsView'
  s.version  = '0.1'
  s.license  = 'MIT'
  s.summary  = 'UIView that can generate a Ken Burns transition when given an array of UIImage objects.'
  s.framework = 'QuartzCore'
  
  s.homepage = 'https://github.com/jberlana/iOSKenBurns'
  s.author   = { 'Javier Berlana' => 'info@sweetbits.es' }
  s.source   = { :git => 'https://github.com/jberlana/iOSKenBurns.git', :commit => '04feef2a64117c2a6c4dd21db51e42d1425ea649' }
  s.platform = :ios
  s.source_files = 'KenBurns/*.{h,m}'
  s.requires_arc = false
end