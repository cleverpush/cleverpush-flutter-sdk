Pod::Spec.new do |s|
  s.name             = 'cleverpush_flutter'
  s.version          = '1.16.0'
  s.summary          = 'CleverPush Flutter SDK'
  s.description      = 'CleverPush'
  s.homepage         = 'https://cleverpush.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'CleverPush GmbH' => 'info@cleverpush.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'CleverPush', '1.21.4'
  s.static_framework = true
  s.ios.deployment_target = '8.0'
end
