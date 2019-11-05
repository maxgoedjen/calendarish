import SwiftUI

struct SettingsView: View {

    var settings: Settings
    var te: Bool = false

    var body: some View {
        List(settings.all) { setting in
            Toggle(isOn: setting.binding) {
                Text(setting.description)
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(settings: Settings())
    }
}
