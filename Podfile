platform :ios, '13.1'
use_frameworks!
inhibit_all_warnings!

def common
    pod 'GoogleAPIClientForREST/Calendar'
    pod 'GTMSessionFetcher'
end

target 'Calendarish' do
  common
  pod 'GTMAppAuth'
end

target 'CalendarishAPI' do
  platform :watchos, '6.0'
  common
end

target 'CalendarishAPITests' do
  common
end
