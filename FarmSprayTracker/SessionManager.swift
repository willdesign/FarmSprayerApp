import Foundation

class SessionManager: ObservableObject {
    import SwiftUI
    
    struct SessionSummaryView: View {
        var sessions: [SpraySession]
        
        var body: some View {
            List {
                ForEach(sessions) { session in
                    SessionCell(session: session)
                }
            }
            .navigationTitle("Spray Sessions")
        }
    }
    
    struct SessionCell: View {
        var session: SpraySession
        
        var body: some View {
            VStack(alignment: .leading) {
                Text(session.name)
                    .font(.headline)
                Text("Area: \(session.area, specifier: "%.2f") acres")
                    .font(.subheadline)
                if session.isCompleted {
                    Text("Completed")
                        .foregroundColor(.green)
                        .font(.caption)
                } else {
                    Text("In Progress")
                        .foregroundColor(.orange)
                        .font(.caption)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
        }
    }
    
    struct SpraySession: Identifiable {
        let id: UUID
        let name: String
        let area: Double
        let isCompleted: Bool
    }
    
    struct SessionSummaryView_Previews: PreviewProvider {
        static var previews: some View {
            SessionSummaryView(sessions: [
                SpraySession(id: UUID(), name: "Field 1", area: 10.5, isCompleted: true),
                SpraySession(id: UUID(), name: "Field 2", area: 7.3, isCompleted: false)
            ])
        }
    }
}
