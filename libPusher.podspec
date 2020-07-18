Pod::Spec.new do |s|
  s.name            = 'libPusher'
  s.version         = '1.6.5'
  s.license         = 'MIT'
  s.summary         = 'An Objective-C client for the Pusher service'
  s.homepage        = 'https://github.com/pusher/libPusher'
  s.author          = 'Luke Redpath'
  s.source          = { git: 'https://github.com/pusher/libPusher.git', tag: 'v1.6.5' }
  s.requires_arc    = true
  s.header_dir      = 'Pusher'
  s.default_subspec = 'Core'

  s.ios.deployment_target = '6.0'
  s.osx.deployment_target = '10.9'

  s.preserve_paths = 'libraries/SocketRocket/include/SocketRocket/*.h'
  s.vendored_libraries = 'libraries/SocketRocket/lib/libSocketRocket.a'
  s.libraries = 'SocketRocket'
  s.xcconfig = {
      'HEADER_SEARCH_PATHS' => "${PODS_ROOT}/#{s.name}/libraries/SocketRocket/include",
      'LIBRARY_SEARCH_PATHS' => "${PODS_ROOT}/#{s.name}/libraries/SocketRocket/lib"
  }

  s.subspec 'Core' do |subspec|
    subspec.source_files         = 'Library/**/*.{h,m}'
    subspec.private_header_files = 'Library/Private Headers/*'
    subspec.xcconfig             = {
      'GCC_PREPROCESSOR_DEFINITIONS' => 'kPTPusherClientLibraryVersion=@\"1.6.5\"'
    }
  end

  s.subspec 'ReactiveExtensions' do |subspec|
    subspec.dependency 'libPusher/Core'
    subspec.dependency 'ReactiveCocoa', '~> 2.1'

    subspec.source_files = 'ReactiveExtensions/*'
    subspec.private_header_files = 'ReactiveExtensions/*_Internal.h'
  end
end
