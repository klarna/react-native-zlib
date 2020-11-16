
require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = 'RNReactNativeZlib'
  s.version      = package["version"]
  s.summary      = package["description"]
  s.author       = package["author"]

  s.homepage     = package["homepage"]

  s.license      = package["license"]
  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/author/RNReactNativeZlib.git", :tag => "#{s.version}" }
  s.source_files = "ios/**/*.{h,m,swift}"
  s.requires_arc = true
  s.preserve_paths  = "**/*.js"

  s.dependency 'React'
end
