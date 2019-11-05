import SwiftUI

struct SettingsView: View {

    var settingsStore: SettingsStore

    var body: some View {
        List(settingsStore.allSettings) { setting in
            Toggle(isOn: setting.binding) {
                Text(setting.description)
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(settingsStore: SettingsStore())
    }
}
