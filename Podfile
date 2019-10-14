platform :ios, '13.1'
use_frameworks!
inhibit_all_warnings!

def common
    pod 'GoogleAPIClientForREST/Calendar'
    pod 'GTMSessionFetcher'
  	pod 'GTMAppAuth', :git => 'https://github.com/maxgoedjen/GTMAppAuth.git'
end

target 'Calendarish' do
  common
end

target 'CalendarishAPI' do
  platform :watchos, '6.0'
  common
end

target 'Calendarish WatchKit Extension' do
  platform :watchos, '6.0'
  common
end

target 'CalendarishAPITests' do
  common
end
