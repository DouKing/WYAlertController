Pod::Spec.new do |s|
  s.name         = "WYAlertController"
  s.version      = "0.0.4"
  s.summary      = "统一`UIAlertView`、`UIActionSheet`、`UIAlertController`"
  s.homepage     = "https://github.com/DouKing/WYAlertController"
  s.license      = "MIT"
  s.author       = { "wuyikai" => "wuyikai@secoo.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/DouKing/WYAlertController.git", :tag => "0.0.2" }
  s.source_files = "WYAlertController/WYAlertController", "WYAlertController/WYAlertController/**/*.{h,m}"
  s.requires_arc = true
end
