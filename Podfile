# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'

def import_pods
  pod 'Firebase/Core'
  pod 'Firebase/Messaging'
  pod 'Firebase/RemoteConfig'
  pod 'Firebase/Database'
  pod 'Firebase/Firestore'
  pod 'Firebase/Auth'
  pod 'Firebase/Storage'
  pod 'Firebase/Functions'
  pod 'Firebase/InAppMessagingDisplay'
  pod 'Firebase/MLVision'
  pod 'Firebase/MLVisionFaceModel'
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'SVProgressHUD'
  pod 'Nuke'
  pod 'Alamofire'
  pod 'Hero'
  pod 'IBMWatsonAssistantV1', '~> 3.0.0'
  pod 'IBMWatsonAssistantV2', '~> 3.0.0'
  pod 'IBMWatsonCompareComplyV1', '~> 3.0.0'
  pod 'IBMWatsonDiscoveryV1', '~> 3.0.0'
  pod 'IBMWatsonLanguageTranslatorV3', '~> 3.0.0'
  pod 'IBMWatsonNaturalLanguageClassifierV1', '~> 3.0.0'
  pod 'IBMWatsonNaturalLanguageUnderstandingV1', '~> 3.0.0'
  pod 'IBMWatsonPersonalityInsightsV3', '~> 3.0.0'
  pod 'IBMWatsonSpeechToTextV1', '~> 3.0.0'
  pod 'IBMWatsonTextToSpeechV1', '~> 3.0.0'
  pod 'IBMWatsonToneAnalyzerV3', '~> 3.0.0'
  pod 'IBMWatsonVisualRecognitionV3', '~> 3.0.0'
  pod 'kintone-ios-sdk', '~> 0.1.0'
  pod 'PromisesSwift', '~> 1.2.6'
  pod 'lottie-ios'
end

target 'nri_hack' do
  use_frameworks!

  import_pods

  target 'nri_hackTests' do
    inherit! :search_paths
  end

  target 'nri_hackUITests' do
    inherit! :search_paths
  end

end
