Pod::Spec.new do |s|
  s.name         = "NSOperationQueue+CompletionBlock"
  s.version      = "1.0.0"
  s.summary      = "A missing completionBlock for NSOperationQueue."
  s.homepage     = "https://github.com/devxoul/NSOperationQueue-CompletionBlock"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "devxoul" => "devxoul@gmail.com" }
  s.source       = { :git => "https://github.com/devxoul/NSOperationQueue-CompletionBlock.git",
                     :tag => "#{s.version}" }
  s.platform     = :ios, '3.1'
  s.requires_arc = true
  s.source_files = 'NSOperationQueue+CompletionBlock/NSOperationQueue+CompletionBlock.{h,m}'
  s.frameworks   = 'Foundation'
end
