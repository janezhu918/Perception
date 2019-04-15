# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'

use_frameworks!

def perception_pods
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'
  pod 'Firebase/Storage'
  pod 'Kingfisher'
  pod 'Toucan'
  pod 'ProgressHUD'
end

target 'Perception' do
  perception_pods
  pod 'paper-onboarding'
  pod 'ExpandingMenu', '~> 0.4'
end

target 'PerceptionTests' do
  perception_pods
end
