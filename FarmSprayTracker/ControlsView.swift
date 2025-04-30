import SwiftUI

struct ControlsView: View {
    @Binding var sprayWidthText: String
    @Binding var isTrackingActive: Bool
    @Binding var isPaused: Bool
    var startAction: () -> Void
    var stopAction: () -> Void
    var pauseAction: () -> Void
    var resumeAction: () -> Void

    var body: some View {
        VStack {
            TextField("Spray Width (ft)", text: $sprayWidthText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            if !isTrackingActive {
                Button(action: startAction) {
                    Text("Start")
                        .fontWeight(.bold)
                        .frame(minWidth: 80)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            } else if isPaused {
                Button(action: resumeAction) {
                    Text("Resume")
                        .fontWeight(.bold)
                        .frame(minWidth: 80)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                Button(action: stopAction) {
                    Text("Stop")
                        .fontWeight(.bold)
                        .frame(minWidth: 80)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            } else {
                Button(action: pauseAction) {
                    Text("Pause")
                        .fontWeight(.bold)
                        .frame(minWidth: 80)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                Button(action: stopAction) {
                    Text("Stop")
                        .fontWeight(.bold)
                        .frame(minWidth: 80)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
    }
}
