use_frameworks!
inhibit_all_warnings!

def common
    pod 'GoogleAPIClientForREST/Calendar'
end

target 'Calendarish' do
  platform :ios, '13.1'
  common
end

target 'CalendarishAPI' do
  platform :ios, '13.1'
  common
  pod 'GTMAppAuth'
end

target 'CalendarishAPIWatch' do
  platform :watchos, '6.0'
  common
end

target 'CalendarishAPITests' do
  common
end
