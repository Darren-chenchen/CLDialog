Pod::Spec.new do |s|
  s.name = 'CLDialog'
  s.version = '1.0.1'
  s.swift_version = '4.0'
  s.license = 'MIT'
  s.summary = 'This is a Dialog'
  s.homepage = 'https://github.com/Darren-chenchen/CLDialog'
  s.authors = { 'Darren-chenchen' => '1597887620@qq.com' }
  s.source = { :git => 'https://github.com/Darren-chenchen/CLDialog.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'CLDialog/CLDialog/**/*.swift'
  s.resource_bundles = { 
	'CLDialog' => ['CLDialog/CLDialog/Images/**/*.png','CLDialog/CLDialog/**/*.{xib,storyboard}','CLDialog/CLDialog/**/*.{lproj,strings}']
  }

end
