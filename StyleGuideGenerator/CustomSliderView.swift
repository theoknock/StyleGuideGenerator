//
//  CustomSliderView.swift
//  StyleGuideGenerator
//
//  Created by Xcode Developer on 5/3/24.
//

import Foundation
import SwiftUI
import UIKit

struct CustomColorSlider: UIViewRepresentable {
    @Binding var value: Double
    var range: ClosedRange<Double>
    
    func makeUIView(context: Context) -> UISlider {
        let slider = UISlider(frame: .zero)
        slider.minimumTrackTintColor = UIColor.clear
        slider.maximumTrackTintColor = UIColor.clear
        slider.minimumValue = Float(range.lowerBound)
        slider.maximumValue = Float(range.upperBound)
        slider.value = Float(value)
        slider.minimumValueImage = UIImage(systemName: "h.circle")
        slider.maximumValueImage = UIImage(systemName: "h.circle.fill")


        slider.addTarget(
            context.coordinator,
            action: #selector(Coordinator.valueChanged(_:)),
            for: .valueChanged
        )
        return slider
    }
    
    func updateUIView(_ uiView: UISlider, context: Context) {
        uiView.value = Float(value)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: CustomColorSlider
        
        init(_ parent: CustomColorSlider) {
            self.parent = parent
        }
        
        @objc func valueChanged(_ sender: UISlider) {
            parent.value = Double(sender.value)
        }
    }
}

struct HSLSliderView: View {
    @State private var circleHeight: Double = 207.0 // State to store the circle height
    @State private var hue: Double = 0.6
    @State private var saturation: Double = 1.0
    @State private var brightness: Double = 1.0
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(LinearGradient(
                    gradient: Gradient(colors: [
                        Color(UIColor(hue: 0.0, saturation: 1.0, brightness: 1.0, alpha: 1.0)),
                        Color(UIColor(hue: 0.333, saturation: 1.0, brightness: 1.0, alpha: 1.0)),
                        Color(UIColor(hue: 0.667, saturation: 1.0, brightness: 1.0, alpha: 1.0))
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                ))
                .frame(width: UIScreen.main.bounds.size.width * 0.9, height: 30)
            
            CustomColorSlider(value: $hue, range: 0.0 ... 1.0)
        }
        .frame(width: UIScreen.main.bounds.size.width, height: 30)
        .padding(.horizontal)
        
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(LinearGradient(
                    gradient: Gradient(colors: [
                        Color(UIColor(hue: hue, saturation: 0.0, brightness: brightness, alpha: 1.0)),
                        Color(UIColor(hue: hue, saturation: 1.0, brightness: brightness, alpha: 1.0))
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                ))
                .frame(width: UIScreen.main.bounds.size.width * 0.9, height: 30)
            
            CustomColorSlider(value: $saturation, range: 0.0 ... 1.0)
        }
        .frame(width: UIScreen.main.bounds.size.width , height: 30)
        .padding(.horizontal)
        
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(LinearGradient(
                    gradient: Gradient(colors: [
                        Color(UIColor(hue: hue, saturation: saturation, brightness: 0.0, alpha: 1.0)),
                        Color(UIColor(hue: hue, saturation: saturation, brightness: 1.0, alpha: 1.0))
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                ))
                .frame(width: UIScreen.main.bounds.size.width * 0.9, height: 30)
        
            CustomColorSlider(value: $brightness, range: 0.0 ... 1.0)
        }
        .frame(width: UIScreen.main.bounds.size.width, height: 30)
    
        .padding(.horizontal)

    }
}

#Preview {
    HSLSliderView()
}
