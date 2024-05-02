//
//  ContentView.swift
//  StyleGuideGenerator
//
//  Created by Xcode Developer on 5/2/24.
//

import SwiftUI
import UIKit
import Combine
import Observation

@Observable class Hue: Equatable {
    static func == (lhs: Hue, rhs: Hue) -> Bool {
        return lhs.angle == rhs.angle
    }
    
    var angle: CGFloat = 0.0
    var value: CGFloat = 0.0
}

struct ContentView: View {
    @State var hue = Hue()

    var body: some View {
        ZStack {
            SliderView(hue: hue)
//            Slider(value: $hue.angle, in: 0.0...360)
        }
    }
}

struct SliderView: View {
    @Bindable var hue: Hue
    
    let minimumValue: CGFloat = 0.0
    let maximumValue: CGFloat = 360.0
    let totalValue: CGFloat = 360.0
    
    var _knobSize: CGSize = CGSize(width: 30.0, height: 30.0)
    var knobSize: CGSize {
        get { return _knobSize }
        set { _knobSize = newValue }
    }
    
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        var _radius: CGFloat = UIScreen.main.bounds.midX - UIScreen.main.bounds.minX
        var radius: CGFloat {
            get { return _radius}
            set { _radius = newValue }
        }
        
        var _diameter: CGSize = CGSize(width: (UIScreen.main.bounds.maxX - 15.0) - (UIScreen.main.bounds.minX + 15.0), height: (UIScreen.main.bounds.maxY - 15.0) - (UIScreen.main.bounds.minY + 15.0))
        var diameter: CGSize {
            get { return _diameter }
            set { _diameter = newValue }
        }
        
        ZStack(alignment: Alignment(horizontal: .center, vertical: .center), content: {
            // Wheel
            Circle()
                .strokeBorder(
                    AngularGradient(gradient: .init(colors: hueColors()), center: .center),
                    lineWidth: knobSize.height
                )
                .frame(width: diameter.width, height: diameter.height)
                .contentShape(Circle())
                .rotationEffect(.degrees(-90))

//            // Spoke
            Circle()
                .fill(Color(hue: CGFloat(hue.angle) / 360.0, saturation: 1.5, brightness: 1.5))
                .frame(width: knobSize.width, height: knobSize.height)
                .padding(EdgeInsets(top: knobSize.height, leading: knobSize.width, bottom: knobSize.height, trailing: knobSize.width))
                .offset(y: -(radius))
                .rotationEffect(Angle.degrees(CGFloat(hue.angle).rounded()))
                .gesture(DragGesture(minimumDistance: 0.0)
                    .onChanged({ value in
                        change(location: value.location)
                        feedbackGenerator.impactOccurred()
                    }))
                .shadow(color: Color(hue: CGFloat(hue.angle) / 360.0, saturation: 0.5, brightness: 0.5), radius: 7.5)
                
            
            Text(String(format: "%.0f°", ($hue.angle).wrappedValue))
                    .font(.largeTitle).dynamicTypeSize(.xLarge)
                    .foregroundStyle(Color(hue: CGFloat(hue.angle) / 360.0, saturation: 1.0, brightness: 1.0))
                    .onChange(of: ($hue.angle).wrappedValue, { oldValue, newValue in
                        if (newValue != oldValue) {
                            hue.angle = newValue
                        }
                    })
        })
        .scaledToFit()
    }
    
    func hueColors() -> [Color] {
        (0...360).map { i in
            Color(hue: CGFloat(i) / 360.0, saturation: 1.0, brightness: 1.0)
        }
    }
//    
    private func change(location: CGPoint) {
        // creating vector from location point
        let vector = CGVector(dx: location.x, dy: location.y)
        
        // geting angle in radian need to subtract the knob radius and padding from the dy and dx
        let angle = atan2(vector.dy - (knobSize.width), vector.dx - (knobSize.width)) + .pi/2.0
        
        // convert angle range from (-pi to pi) to (0 to 2pi)
        let fixedAngle = angle < 0.0 ? angle + 2.0 * .pi : angle
        // convert angle value to temperature value
        let value = fixedAngle / (2.0 * .pi) * totalValue
        
        if minimumValue >= 0.0 && maximumValue <= 360.0 {
            hue.angle = value.rounded()
            hue.value = fixedAngle * 180 / .pi // converting to degrees
        }
    }
}

#Preview {
    ContentView()
}
