import SwiftUI

struct BlurredOverlay: View {
    
    private struct BlurView: UIViewRepresentable {
        var style: UIBlurEffect.Style

        func makeUIView(context: Context) -> UIVisualEffectView {
            UIVisualEffectView(effect: UIBlurEffect(style: style))
        }

        func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
            uiView.effect = UIBlurEffect(style: style)
        }
    }
    
    var body: some View {
        Color.clear
            .background(BlurView(style: .systemUltraThinMaterialDark))
            .ignoresSafeArea(.all)
    }
}

struct BlurredOverlay_Previews: PreviewProvider {
    static var previews: some View {
        BlurredOverlay()
    }
}
