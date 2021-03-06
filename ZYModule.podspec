#
#  Be sure to run `pod spec lint ZYModule.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "ZYModule"
  s.version      = "1.0.29"
  s.summary      = "A short description of ZYModule."

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description  = <<-DESC
			ZYModule是一个自定义第三方类库
                   DESC

  s.homepage     = "https://github.com/aaa510665117/ZYModule"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Licensing your code is important. See http://choosealicense.com for more info.
  #  CocoaPods will detect a license file if there is a named LICENSE*
  #  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
  #

  s.license      = { :type => "MIT", :file => "LICENSE" }
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the authors of the library, with email addresses. Email addresses
  #  of the authors are extracted from the SCM log. E.g. $ git log. CocoaPods also
  #  accepts just a name if you'd rather not provide an email address.
  #
  #  Specify a social_media_url where others can refer to, for example a twitter
  #  profile URL.
  #

  s.author             = { "ZY" => "510665117@qq.com" }
  # Or just: s.author    = "ZY"
  # s.authors            = { "ZY" => "510665117@qq.com" }
  # s.social_media_url   = "http://twitter.com/ZY"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #

  # s.platform     = :ios
    s.platform     = :ios, "9.0"

  #  When using multiple platforms
  # s.ios.deployment_target = "5.0"
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

  s.source       = { :git => "https://github.com/aaa510665117/ZYModule.git", :tag => "#{s.version}" }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

  
  #s.source_files  = "ZYModule"
  #s.source_files = "ZYModule/**/*.{h,m}"


  #s.default_subspecs = 'AudioVoice'
  s.subspec 'AudioVoice' do |ss|
    ss.source_files          = 'ZYModule/AudioVoice/*.{h,m}'
    #ss.public_header_files  = 'ZYModule/AudioVoice/*.h'
  end

  s.subspec 'DiyMJRefresh' do |ss|

    ss.dependency 'MJRefresh','~>3.2.0'
    ss.source_files         = 'ZYModule/DiyMJRefresh/*.{h,m}'
    #ss.resource     	    = 'ZYModule/DiyMJRefresh/DiyMJRefresh.bundle'
    #ss.public_header_files  = 'ZYModule/DiyMJRefresh/*.h'
  end

  s.subspec 'PhotoBrowser' do |ss|

    ss.dependency 'SDWebImage', '~>5.0.1'
    ss.source_files         = 'ZYModule/PhotoBrowser/*.{h,m}'
    ss.resources 	    = "ZYModule/PhotoBrowser/PhotoBrowserResources/*.{png,xib,nib,bundle}"
    #ss.public_header_files  = 'ZYModule/PhotoBrowser/*.h'
  end

  s.subspec 'FingerVerification' do |ss|

    ss.source_files         = 'ZYModule/FingerVerification/*.{h,m}'
    #ss.public_header_files  = 'ZYModule/FingerVerification/*.h'
  end

  s.subspec 'SpeechRecognizer' do |ss|
    ss.source_files          = 'ZYModule/SpeechRecognizer/*.{h,m}'
    #ss.public_header_files  = 'ZYModule/SpeechRecognizer/*.h'
  end

  s.subspec 'ZYDataBaseManager' do |ss|
    ss.dependency 'FMDB', '~> 2.7.5'
    ss.dependency 'LKDBHelper','~> 2.5.1'
    ss.source_files          = 'ZYModule/ZYDataBaseManager/*.{h,m}'
    #ss.public_header_files  = 'ZYModule/ZYDataBaseManager/*.h'
  end

  s.subspec 'ZYExtenClass' do |ss|
    ss.dependency 'Masonry','~>1.1.0'
    ss.source_files          = 'ZYModule/ZYExternClass/*.{h,m}'
    #ss.public_header_files  = 'ZYModule/ZYExternClass/*.h'
  end

  s.subspec 'ZYHttp' do |ss|
    ss.dependency 'AFNetworking','~>4.0.0'
    ss.dependency 'TMCache', '~> 2.1.0'
    ss.source_files          = 'ZYModule/ZYHttp/*.{h,m}'
    #ss.public_header_files  = 'ZYModule/ZYHttp/*.h'
  end

  s.subspec 'ZYToolsFunction' do |ss|
    ss.dependency 'MBProgressHUD','~> 1.1.0'
    ss.dependency 'SVProgressHUD','~> 2.2.5'
    ss.source_files          = 'ZYModule/ZYToolsFunction/*.{h,m}'
    #ss.public_header_files  = 'ZYModule/ZYToolsFunction/*.h'
  end

  s.subspec 'ZYUnility' do |ss|

    ss.dependency 'MBProgressHUD','~> 1.1.0'
    ss.dependency 'SVProgressHUD','~> 2.2.5'
    #ss.public_header_files  = 'ZYModule/ZYUnility/HUD/*.h'

    ss.dependency 'HMSegmentedControl','~> 1.5.5'
    #ss.public_header_files  = 'ZYModule/ZYUnility/SosSegment/*.h'

    ss.dependency 'Masonry','~>1.1.0'
    #ss.public_header_files  = 'ZYModule/ZYUnility/DropDownMenuList/*.h'

    #ss.public_header_files  = 'ZYModule/ZYUnility/UICollectionFlowLayout/*.h'

    ss.source_files         = 'ZYModule/ZYUnility/*/*.{h,m}'
  end

  s.exclude_files = "Classes/Exclude"

  # s.public_header_files = "Classes/**/*.h"
  #s.resources = "ZYModule/Resources/*.{png,xib,nib,bundle}"


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # s.framework  = "SomeFramework"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  # s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  #s.dependency "Masonry"
  #s.dependency "AFNetworking"
  #s.dependency "UAProgressView"
  #s.dependency "SBJson5", "~>5.0.0"
  s.dependency "Colours" , "~> 5.13.0"
  s.dependency "AFSoundManager" , "~> 2.1"
  s.dependency "ZLPhotoBrowser" , "~> 3.0.6"

end
