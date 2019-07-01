#
#  Be sure to run `pod spec lint OdinShare.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  spec.name         = "OdinShare"
  spec.version      = "0.0.7"
  spec.summary      = "奥丁分享SDK"

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  spec.description  ="奥丁分享SDK,一行代码实现分享各大主流平台"

  spec.homepage     = "https://github.com/odindata/OdinShare.git"
  # spec.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Licensing your code is important. See https://choosealicense.com for more info.
  #  CocoaPods will detect a license file if there is a named LICENSE*
  #  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
  #

 
  spec.license      = { :type => "MIT", :file => "LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the authors of the library, with email addresses. Email addresses
  #  of the authors are extracted from the SCM log. E.g. $ git log. CocoaPods also
  #  accepts just a name if you'd rather not provide an email address.
  #
  #  Specify a social_media_url where others can refer to, for example a twitter
  #  profile URL.
  #

  spec.author             = { "odindata" => "odindata@163.com" }


  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #

  # spec.platform     = :ios
  # spec.platform     = :ios, "5.0"

  #  When using multiple platforms
  spec.ios.deployment_target = "8.0"
  # spec.osx.deployment_target = "10.7"
  # spec.watchos.deployment_target = "2.0"
  # spec.tvos.deployment_target = "9.0"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

  spec.source       = { :git => "https://github.com/odindata/OdinShare.git", :tag => "#{spec.version}" }

  spec.frameworks = 'CoreGraphics'
  spec.libraries = 'sqlite3'
  
  spec.subspec 'Core' do |c|
    c.vendored_frameworks ='OdinShare/Core/*.framework'
  end

  spec.subspec 'UI' do |ui|
    ui.vendored_frameworks ='OdinShare/UI/OdinShareSDKUI.framework'
    ui.resource_bundle = { 'ShareSDKUI' => 'OdinShare/UI/ShareSDKUI.bundle' }
    ui.dependency 'OdinShare/Core'
  end

  spec.subspec 'Social' do |social|
    social.subspec 'SocialWeChat' do |wx|
      wx.source_files = 'OdinShare/Social/SocialWeChat/**/*.h'
      wx.vendored_libraries = 'OdinShare/Social/SocialWeChat/*.a'
      wx.vendored_libraries = 'OdinShare/Social/SocialWeChat/**/*.a' 
      wx.frameworks = 'SystemConfiguration', 'CoreTelephony'
      wx.libraries = 'sqlite3', 'c++', 'z'
      wx.dependency 'OdinShare/Core'
    end
    social.subspec 'SocialQQ' do |qq|
      qq.source_files = 'OdinShare/Social/SocialQQ/*.h'
      qq.vendored_frameworks ='OdinShare/Social/SocialQQ/QQSDK/*.framework'
      qq.vendored_libraries ='OdinShare/Social/SocialQQ/*.a'
      qq.frameworks = 'SystemConfiguration'
      qq.libraries = 'c++'
      qq.dependency 'OdinShare/Core'
    end
    social.subspec 'SocialSina' do |sina|
      sina.source_files = 'OdinShare/Social/SocialSina/**/*.h'
      sina.vendored_libraries ='OdinShare/Social/SocialSina/*.a'
      sina.vendored_libraries = 'OdinShare/Social/SocialSina/**/**/*.a'
      sina.resource = 'OdinShare/Social/SocialSina/**/**/*.bundle'
      sina.frameworks = 'Photos','SystemConfiguration', 'CoreTelephony','ImageIO'
      sina.libraries = 'sqlite3', 'z'
      sina.dependency 'OdinShare/Core'
    end
    social.subspec 'SocialAliPay' do |ap|
      ap.source_files = 'OdinShare/Social/SocialAliPay/**/*.h'
      ap.vendored_libraries ='OdinShare/Social/SocialAliPay/*.a'
      ap.vendored_libraries ='OdinShare/Social/SocialAliPay/**/*.a'
      ap.dependency 'OdinShare/Core'
    end
    social.subspec 'SocialFacebook' do |fb|
      fb.source_files = 'OdinShare/Social/SocialFacebook/*.h'
      fb.vendored_libraries ='OdinShare/Social/SocialFacebook/*.a'
      fb.vendored_frameworks ='OdinShare/Social/SocialFacebook/**/*.framework'
      fb.dependency 'OdinShare/Core'
    end
    social.subspec 'SocialTwitter' do |twitter|
      twitter.source_files = 'OdinShare/Social/SocialTwitter/*.h'
      twitter.vendored_libraries ='OdinShare/Social/SocialTwitter/*.a'
      twitter.vendored_frameworks ='OdinShare/Social/SocialTwitter/**/*.framework'
      twitter.frameworks = 'CoreData'
      
      twitter.dependency 'OdinShare/Core'
    end
    social.subspec 'SoicalInstagram' do |ins|
      ins.source_files = 'OdinShare/Social/SoicalInstagram/*.h'
      ins.vendored_libraries ='OdinShare/Social/SoicalInstagram/*.a'
      ins.dependency 'OdinShare/Core'
    end
  end
end
