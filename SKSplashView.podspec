Pod::Spec.new do |s|

  s.name             = "SKSplashView"
  s.version          = "0.1.0"
  s.summary          = "A drop-in view to create custom animated splash views for your iOS apps."
  s.homepage         = "https://github.com/sachinkesiraju/SKSplashView"
  s.license          = { :type => 'MIT', :text => 'Copyright 2014 Sachin Kesiraju' }
  s.author           = { "Sachin Kesiraju" => "me@sachinkesiraju.com" }
  s.source           = { :git => "https://github.com/sachinkesiraju/SKSplashView.git", :tag => '0.1.0'}
  s.social_media_url = "https://twitter.com/sachinkesiraju"
  s.platform     = :ios, '7.0'
  s.requires_arc = true
  s.source_files = 'SKSplashView'

end
