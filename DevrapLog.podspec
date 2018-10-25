#  Be sure to run `pod spec lint DevrapLog.podspec --allow-warnings' to ensure this is a
Pod::Spec.new do |s|
  s.name         = "DevrapLog"
  s.version      = "0.0.1"
  s.summary      = "DevrapLog."


  s.description  = <<-DESC
			Computes the meaning of life.
                     Features:
                     1. Is self aware
                     ...
                     42. Likes candies.
                   DESC

  s.homepage     = "http://DevrapLog.com"
  s.license      = "MIT"
  s.author             = { "v_dh" => "vincent.dhalluin@gmail.com" }
  s.platform     = :ios
  s.ios.deployment_target = '8.0'
  s.swift_version = '4.0'
  s.source       = { :git => "git@github.com:v-dh/DevrapLog.git" }
  s.source_files  = "Sources/DevLog/", "Sources/Reachability/"
  s.dependency 'CocoaLumberjack/Swift', '~> 3.4.0'
  s.dependency 'Zip', '~> 1.1.0'
end
