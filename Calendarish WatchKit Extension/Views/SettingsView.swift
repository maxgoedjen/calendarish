import SwiftUI

struct SettingsView: View {

    @State var settings: Settings
    @State var te: Bool = false

    var body: some View {
        List(settings.all) { setting in
            Toggle(isOn: self.$te) {
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
