#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint rwa_deep_ar.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'rwa_deep_ar'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter plugin.'
  s.description      = <<-DESC
A new Flutter plugin.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'
  s.swift_version = '5.0'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }

  #My own addition to the .podspec
  s.preserve_paths = 'DeepAR.framework'
  s.xcconfig = { 'OTHER_LDFLAGS' => '-framework DeepAR' }
  s.vendored_frameworks = 'DeepAR.framework'
  s.resources = ['Effects/*']
  s.resource_bundle = { 'Effects' => 'Effects/*.' }
end
