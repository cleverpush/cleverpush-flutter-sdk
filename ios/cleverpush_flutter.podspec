Pod::Spec.new do |s|
  s.name             = 'cleverpush_flutter'
  s.version          = '1.24.35'
  s.summary          = 'CleverPush Flutter SDK'
  s.description      = 'CleverPush'
  s.homepage         = 'https://cleverpush.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'CleverPush GmbH' => 'info@cleverpush.com' }
  s.source           = { :path => '.' }
  s.source_files = 'cleverpush_flutter/Sources/cleverpush_flutter/**/*.{h,m}'
  s.public_header_files = 'cleverpush_flutter/Sources/cleverpush_flutter/include/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'CleverPush', '1.34.47'
  s.static_framework = true
  s.ios.deployment_target = '8.0'
end
