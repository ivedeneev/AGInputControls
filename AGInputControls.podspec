Pod::Spec.new do |s|
  s.name             = 'AGInputControls'
  s.version          = '1.1.3'
  s.summary          = 'Commonly used text input controls'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/ivedeneev/AGInputControls.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ivedeneev' => 'getmaxx@hotmail.com' }
  s.source           = { :git => 'https://github.com/ivedeneev/AGInputControls.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'
  s.swift_version = '5.0'
  s.source_files = 'AGInputControls/Source/*'
  
end
